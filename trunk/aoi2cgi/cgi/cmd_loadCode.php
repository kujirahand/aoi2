<?php
//----------------------------------------------------------------------
// cmd_loadSource.php
//----------------------------------------------------------------------
include_once('aoi2file.inc');

$file_id = getParam('file_id', FALSE);
if ($file_id == FALSE) {
    echo '{type:"File Not Found"}';
    return;
}

$db = new AOI2_DB();
$db->open();

$result  = TRUE;
$message = '';
$file    = '';

if (FALSE == $file_id) {
    $result = FALSE;
}

if ($result) {
    $result = $db->getFileIRCode($file_id);
    if ($result) {
        $file = $result;
        $db->incCounter($file_id);
    }
}

if ($result == FALSE) {
    $message = $db->lasterror;
}


$db->close();

if ($result) {
  echo $file["ircode"];
}
else {
  echo '{type:"error"}';
}

?>


