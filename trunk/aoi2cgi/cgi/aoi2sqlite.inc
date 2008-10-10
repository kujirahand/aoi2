<?php
/**
 * @param $handle
 * @param $table    table name
 * @param $values   hash of values
 * @return          TRUE | FALSE
 * @example
 * aoi2db_insert($db, "test", array('user_id' => 3, 'mail' => 'xxx'));
 */
function aoi2db_insert($handle, $table, $values)
{
    $table = sqlite_escape_string($table);
    $sql_key   = "";
    $sql_value = "";
    foreach ($values as $key => $val) {
        // key
        $key = sqlite_escape_string($key);
        $sql_key .= $key . ",";
        if (is_string($val)) {
            $val = sqlite_escape_string($val);
            $sql_value .= "'$val',";
        }
        else {
            $sql_value .= $val.",";
        }
    }
    if ($sql_key == "") return; // no values
    $sql_key   = substr($sql_key,   0, strlen($sql_key) - 1);
    $sql_value = substr($sql_value, 0, strlen($sql_value) - 1);
    $sql = "INSERT INTO $table ($sql_key)VALUES($sql_value);";
    return @sqlite_exec($handle, $sql);
}

/**
 * @param $handle
 * @param $table    table name
 * @param $values   hash of values
 * @return          TRUE | FALSE
 * @example
 * aoi2db_update($db, "test", array('mail' => 'xxx'), array('user_id' => 3));
 */
function aoi2db_update($handle, $table, $values, $where)
{
    $table = sqlite_escape_string($table);
    $sql_let   = "";
    $sql_where = "";
    // let
    $let_ary = array();
    foreach ($values as $key => $val) {
        // key
        $key = sqlite_escape_string($key);
        if (is_string($val)) {
            $val = sqlite_escape_string($val);
            $let_ary[] = "$key='$val'";
        }
        else {
            $let_ary[] = "$key=$val";
        }
    }
    if (count($let_ary) == 0) return;
    // where
    $where_ary = array();
    foreach ($where as $key => $val) {
        // key
        $key = sqlite_escape_string($key);
        if (is_string($val)) {
            $val = sqlite_escape_string($val);
            $where_ary[] = "$key='$val'";
        }
        else {
            $where_ary[] = "$key=$val";
        }
    }
    if (count($where_ary) == 0) return;
    //
    $sql_let   = join(',', $let_ary);
    $sql_where = join(' AND ', $where_ary);
    //
    $sql = "UPDATE $table SET $sql_let WHERE $sql_where;";
    return @sqlite_exec($handle, $sql);
}

/**
 * @param $handle
 * @param $table    table name
 * @param $where    condition
 * @return          TRUE | FALSE
 * @example
 * aoi2db_delete($db, "test", array('mail' => 'xxx'));
 */
function aoi2db_delete($handle, $table, $where)
{
    $table = sqlite_escape_string($table);
    $sql_let   = "";
    $sql_where = "";
    // where
    $where_ary = array();
    foreach ($where as $key => $val) {
        // key
        $key = sqlite_escape_string($key);
        if (is_string($val)) {
            $val = sqlite_escape_string($val);
            $where_ary[] = "$key='$val'";
        }
        else {
            $where_ary[] = "$key=$val";
        }
    }
    if (count($where_ary) == 0) return;
    //
    $sql_where = join(' AND ', $where_ary);
    //
    $sql = "DELETE FROM $table WHERE $sql_where;";
    return @sqlite_exec($handle, $sql);
}


function aoi2db_getInfoInt($handle, $key)
{
    $r = aoi2db_select($handle,
          'info',
          array('v_int'),
          array('key' => $key)
    );
    if ($r) {
        return $r[0]['v_int'];
    } else {
        return $r;
    }
}

function aoi2db_getInfoStr($handle, $info_id)
{
    $r = aoi2db_select($handle,
          'info',
          array('v_str'),
          array('key' => $key)
    );
    if ($r) {
        return $r[0]['v_str'];
    } else {
        return $r;
    }
}

function aoi2db_updateInfoInt($handle, $key, $value)
{
    return aoi2db_update($handle, 'info', array('v_int'=>intval($value)),
        array('key'=>$key));
}

function aoi2db_updateInfoStr($handle, $key, $value)
{
    return aoi2db_update($handle, 'info', array('v_str'=>$value),
        array('key'=>$key));
}

function aoi2db_select($handle, $table, $values, $where)
{
    $table = sqlite_escape_string($table);
    // values
    $sql_values = join(',', $values);
    if (count($values) == 0) $sql_values = '*';
    // where
    $where_ary = array();
    foreach ($where as $key => $val) {
        // key
        $key = sqlite_escape_string($key);
        if (is_string($val)) {
            $val = sqlite_escape_string($val);
            $where_ary[] = "$key='$val'";
        }
        else {
            $where_ary[] = "$key=$val";
        }
    }
    //
    $sql_where = join(' AND ', $where_ary);
    //
    if ($sql_where == '') {
        $sql = "SELECT $sql_values FROM $table limit 300;";
    }
    else {
        $sql = "SELECT $sql_values FROM $table WHERE $sql_where limit 1000;";
    }
    $r = sqlite_array_query($handle, $sql, SQLITE_ASSOC);
    return $r;
}

?>
