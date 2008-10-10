<?php
//----------------------------------------------------------------------
// aoi2file.inc
//----------------------------------------------------------------------
/**
 * ファイルの保存などを行う関数定義ファイル
 */
include_once('aoi2config_ini.php');
include_once('aoi2sqlite.inc');

function getParam($key, $def)
{
    $r = getParam_($key, $def);
    $r = stripslashes($r); 
    return $r;
}

function getParam_($key, $def)
{
    if (isset($_POST[$key])) {
        return $_POST[$key];
    }
    else if (isset($_GET[$key])) {
        return $_GET[$key];
    }
    else {
        return $def;
    }
}

class AOI2_DB
{
    var $handle = FALSE;
    var $lasterror = "";
    
    function open()
    {
        global $FILE_FILEDB;
        return $this->handle = sqlite_open($FILE_FILEDB);
    }
    
    function close()
    {
        return sqlite_close($this->handle);
    }
    
    function getError()
    {
        return sqlite_error_string( sqlite_last_error($this->handle) );
    }
    
    function getErrorJson()
    {
        $err = $this->getError();
        return "{'result':false,'message':'$err'}";
    }
    
    function begin()
    {
        return @sqlite_exec($this->handle, 'begin');
    }
    function commit()
    {
        return @sqlite_exec($this->handle, 'commit');
    }
    function rollback()
    {
        return @sqlite_exec($this->handle, 'rollback');
    }
    
    function getUser($email, $pass)
    {
        if ($user == '' || $pass == '') return 0;
        $r = aoi2db_select(
            $this->handle,
            'users',
            array('*'),
            array('email'=>$email,'password'=>$pass));
        return $r;
    }
    
    /**
     * @param   $email
     * @return  FALSE or user_id
     */
    function user_exists($email)
    {
        $r = aoi2db_select(
            $this->handle,
            'users',
            array('user_id'),
            array('email' => $email)
        );
        return $r;
    }
    
    function insertUser($email, $password, $name, $comment)
    {
        // unique?
        if (user_exists($email)) return FALSE;
        // get id
        if(FALSE == @sqlite_exec($thid->handle, "begin")) return FALSE;
        $last_user_id = aoi2db_getInfoInt('last_user_id') + 1;
        $r = aoi2db_insert(
            $this->handle,
            'users',
            array(
              'user_id' => $last_user_id,
              'email'   => $email,
              'password'=> $password,
              'name'    => $name,
              'comment' => $comment,
              'update_time' => time(),
              'create_time' => time())
        );
        if (FALSE == $r) return FALSE;
        aoi2db_updateInfoInt('last_user_id', $last_user_id);
        if (FALSE == @sqlite_exec($thid->handle, "commit")) return FALSE;
        return $last_user_id;
    }
    
    /**
     * @return FALSE or $file_id
     */
    function insertFile($filename, $source, $lang, $ircode, $password, $user_id, $public_attr)
    {
        $pub = $public_attr ? 1 : 0;
        if (FALSE == $this->begin()) return FALSE;
        $last_file_id = aoi2db_getInfoInt($this->handle, 'last_file_id');
        $last_file_id++;
        $r = aoi2db_insert(
            $this->handle,
            'files',
            array(
              'file_id'   => intval($last_file_id),
              'filename'  => strval($filename),
              'source'    => strval($source),
              'lang'      => strval($lang),
              'ircode'    => strval($ircode),
              'password'  => strval($password),
              'user_id'   => intval($user_id),
              'public_attr'=>intval($pub),
              'create_time'=>time(),
              'update_time'=>time()
            )
        );
        if ($r == FALSE) {
            global $lasterror;
            $this->lasterror = $lasterror;
            $this->rollback();
            return FALSE;
        }
        $r = aoi2db_insert(
            $this->handle,
            'counter',
            array(
              'file_id'     => $last_file_id,
              'count'       => 0,
              'update_time' => time()
            )
        );
        if (aoi2db_updateInfoInt($this->handle, 'last_file_id', $last_file_id)){
            $r = $this->commit();
            if ($r) {
                return $last_file_id;
            } else {
                $this->rollback();
                return FALSE;
            }
        } else {
            return FALSE;
        }
    }
    
    function updateFile($file_id, $values)
    {
        $values['update_time'] = time();
        $r = aoi2db_update(
            $this->handle,
            'files',
            $values,
            array(
              'file_id' => $file_id
            )
        );
        if ($r == FALSE) {
            global $lasterror;
            $this->lasterror = $lasterror;
            return FALSE;
        }
        return TRUE;
    }
    
    function enum_files($user_id, $file_id)
    {
        $cond = array('user_id' => $user_id);
        if ($file_id >= 0) {
            $cond['file_id'] = $file_id;
        }
        
        $r = aoi2db_select($this->handle,
            'files',
            array('file_id', 'user_name', 'filename', 'lang', 'public_attr','update_time'),
            $cond
        );
        return $r;
    }
    
    function getFileSource($file_id, $password)
    {
        $r = aoi2db_select($this->handle,
            'files',
            array('file_id','filename', 'source', 'lang', 'update_time', 'create_time', 'update_time', 'public_attr', 'user_id', 'password'),
            array('file_id' => $file_id)
        );
        if (!$r) return FALSE;
        $item = $r[0];
        if ($item['public_attr'] == 0) {
          if ($item['password'] != $password) {
            $this->lasterror = "Password incorrect";
            return FALSE;
          }
        }
        return $item;
    }
    
    function getFileIRCode($file_id)
    {
        $r = aoi2db_select($this->handle,
            'files',
            array('filename', 'ircode', 'update_time', 'create_time', 'update_time', 'public_attr', 'user_id'),
            array('file_id' => $file_id, 'public_attr' => 1)
        );
        if (!$r) return FALSE;
        return $r[0];
    }
    
    function getFile($file_id)
    {
        $r = aoi2db_select(
          $this->handle,
          'files',
          array('*'),
          array('file_id' => $file_id)
        );
        if (!$r) return FALSE;
        return $r[0];
    }
    
    function incCounter($file_id)
    {
        $this->begin();
        $count = aoi2db_select(
          $this->handle,
          "counter",
          array("count"),
          array("file_id"=>$file_id)
        );
        if ($count == FALSE) {
            $this->rollback();
            return;
        }
        $count = $count[0]["count"];
        $res = aoi2db_update(
          $this->handle,
          "counter",
          array(
            "count"=>$count+1,
            "update_time"=>time()
          ),
          array(
            "file_id"=>$file_id
          )
        );
        $this->commit();
    }
    
    function removeFile($file_id, $password)
    {
        $this->begin();
        
        $row = aoi2db_select(
          $this->handle,
          "files",
          array("file_id","password"),
          array(
            "file_id"=>$file_id
          )
        );
        if ($row == FALSE) {
            $this->lasterror = "No Exists";
            $this->rollback();
            return FALSE;
        }
        $row = $row[0];
        if ($row["password"] === $password) {
            $r = aoi2db_delete(
              $this->handle,
              "files",
              array("file_id"=>$file_id)
            );
            if (!$r) {
                $this->lasterror = "Database Error";
                $this->rollback();
                return FALSE;
            }
        }
        else {
            $this->lasterror = "Password incorrect. ";
            $this->rollback();
            return FALSE;
        }
        $this->commit();
        return TRUE;
    }
}
?>
