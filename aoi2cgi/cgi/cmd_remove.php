<?php
//----------------------------------------------------------------------
// cmd_loadSource.php
//----------------------------------------------------------------------
include_once('aoi2file.inc');
include_once('JSON.php');

$db = new AOI2_DB();
$db->open();

$file_id = getParam('file_id', FALSE);
$password = getParam('password', "");

$result  = TRUE;
$message = '';
$file    = '';

if (FALSE == $file_id) {
    $message = "Not enough parameter.";
    $result = FALSE;
}

if ($result) {
    $result = $db->removeFile($file_id, $password);
    if ($result == FALSE) {
        if ($db->lasterror == '') {
            $message = "DB Error";
        }
        else {
            $message = $db->lasterror;
        }
    }
    else { $message = "ok."; }
}

$db->close();

$json = new Services_JSON();
echo $json->encode(
  array(
    "result"=>$result,
    "message"=>$message
  )
);


?>
