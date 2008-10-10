<?php
//----------------------------------------------------------------------
// aoi2file.php
//----------------------------------------------------------------------
/**
 * エディタとやりとりして、ファイルの保存などを行うPHPファイル
 */
include_once('aoi2file.inc');
include_once('JSON.php');

$db = new AOI2_DB();
if(!$db->open()) {
    echo $db->getErrorJson();
    exit(-1);
}

$user_id = getParam('user_id', 0);
$file_id = getParam('file_id', -1);

$result  = TRUE;
$message = '';

$files = $db->enum_files($user_id, $file_id);

$db->close();

$json = new Services_JSON();
echo $json->encode(
  array(
    "result"  =>$result,
    "message" =>$message,
    "files"   =>$files)
  );

?>


