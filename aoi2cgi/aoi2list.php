<?php
include_once("cgi/aoi2sqlite.inc");

# mode = (pop|new)
$mode = isset($_GET['mode']) ? $_GET['mode'] : "new";

$h = sqlite_open("cgi/data/filedb.db");

# counter
if ($mode == "pop") {
  $sql = "select * from counter order by count DESC limit 100";
} else {
  $sql = "select * from counter;";
}
$counter_top = sqlite_array_query($h, $sql, SQLITE_ASSOC);
$counter = array();
foreach ($counter_top as $line) {
  $counter[$line["file_id"]] = $line["count"];
}

# files
$sql = "select file_id,user_name,filename,update_time  from files where public_attr=1 order by file_id DESC limit 300;";
$files = sqlite_array_query($h, $sql, SQLITE_ASSOC);

# pop ?
if ($mode == 'pop') {
  # make file_id hash
  $tmp = array();
  foreach($files as $line) {
    $file_id = $line["file_id"];
    $tmp[$file_id] = $line;
  }
  # sort
  $files = array();
  $i = 0;
  foreach($counter_top as $line) {
    $file_id = $line["file_id"];
    if (isset($tmp[$file_id])) {
      $files[$i++] = $tmp[$file_id];
    }
  }
}

foreach ($files as $line) {
  $file_id = $line["file_id"];
  $count = isset($counter[$file_id]) ? $counter[$file_id] : 0;
  $line2 = array(
    $line['file_id'],
    linktarget($line['file_id'],$line['filename']),
    $line['user_name'],
    date("Y-m-d",$line['update_time']),
    $count
  );
  $s = "<tr>";
  foreach ($line2 as $cell) {
    if ($cell == "") { $cell = "&nbsp;"; }
    $s .= "<td>".$cell."</td>";
  }
  $s .= "</tr>\n";
  $body .= $s;
}
sqlite_close($h);

// output
$html = file_get_contents("aoi2list_template.html");
$html = preg_replace("/__BODY__/", $body, $html);
echo $html;

function linktarget($id, $fname) {
  return "<a href='aoi2show.php?file_id=$id'>$fname</a>";
}
?>
