<?php
//--------------------------------------------------------------
// Redirect to IRCode
//--------------------------------------------------------------
$id = isset($_GET['id']) ? $_GET['id'] : 0;
$base = "http://".$_SERVER['HTTP_HOST'].$_SERVER['PHP_SELF'];
$base = str_replace("v/", "", $base);
$base = str_replace("swf.php", "", $base);
$mainfile = $base."cgi/cmd_loadCode.php?file_id=".$id;
$mainfile = urlencode($mainfile);
$url = $base."webparts/aoivm.swf?mainfile=".$mainfile."";
//--------------------------------------------------------------
// redirect
header("HTTP/1.x 303 See Other");
header("Location: ". $url);
header("Connection: Keep-Alive");
header("Content-Type: text/plain");

?>
