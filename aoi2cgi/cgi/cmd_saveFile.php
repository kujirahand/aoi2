<?php
//----------------------------------------------------------------------
// cmd_saveFile.php
//----------------------------------------------------------------------
include_once('aoi2file.inc');
include_once('JSON.php');

// check
if (getParam("filename", FALSE) == FALSE) {
  echo '{"result":false, "message":"no filename"}';
  return;
}
if (getParam("source", FALSE) == FALSE) {
  echo '{"result":false, "message":"no source"}';
  return;
}


$db = new AOI2_DB();
$db->open();

$file_id = getParam('file_id', FALSE);

$result  = TRUE;
$message = '';

// new | update ?
if (FALSE == $file_id) {
    // new
    $result = $db->insertFile(
        getParam('filename', 'noname'),
        getParam('source', ''),
        getParam('lang','.aoi'),
        getParam('ircode', ''),
        getParam('password', ''),
        intval(getParam('user_id', 0)),
        getParam('user_name','unknown'),
        getParam('public_attr', 0)
    );
    if ($result) { $file_id = $result; $result = TRUE; }
    if ($result == FALSE) {
        $message = $db->lasterror;
    }
}
else {
    // update
    $f = $db->getFile($file_id);
    if ($f == FALSE) {
        $result = FALSE;
        $message = 'no file';
    }
    else {
        // CHECK PASSWORD
        $pass_param = getParam('password', '');
        $pass_db    = $f['password'];
        if (strcmp($pass_param,$pass_db) != 0) {
            $result = FALSE;
            $message = 'wrong password';
        }
    }
    // set update fields
    $fields = array(
      'filename', 'source', 'lang', 'ircode', 'password',
      'user_id', 'public_attr', 'user_name');
    foreach ($fields as $key) {
        $f[$key] = getParam($key, $f[$key]);
    }
    // update
    if ($result) {
        $result = $db->updateFile($file_id, $f);
        if ($result == FALSE) {
            $message = $db->lasterror;
        }
    }
}

$db->close();

$json = new Services_JSON();
echo $json->encode(
  array(
    "result"=>$result,
    "message"=>$message,
    "file_id"=>$file_id
  ));

?>


