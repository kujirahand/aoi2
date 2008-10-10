<?php
//----------------------------------------------------------------------
// cmd_loadSource.php
//----------------------------------------------------------------------
include_once('aoi2file.inc');
include_once('JSON.php');

$db = new AOI2_DB();
$db->open();

$file_id  = getParam('file_id', FALSE);
$password = getParam('password', FALSE);

$result  = TRUE;
$message = '';
$file    = '';

if (FALSE == $file_id) {
    $result = FALSE;
}

if ($result) {
    $file = $db->getFileSource($file_id, $password);
    if ($file == FALSE) $result = FALSE;
}

if ($result == FALSE) {
    $message = $db->lasterror;
}


$db->close();

$json = new Services_JSON();
echo $json->encode(
  array(
    "result"=>$result,
    "message"=>$message,
    "file"=>$file)
  );

?>


