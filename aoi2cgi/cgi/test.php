<pre>
<?php

include_once('aoi2sqlite.inc');

$db = sqlite_open('data/filedb.db');

$r = aoi2db_insert($db,'info',array('key'=>'test','v_str'=>'test'));
if ($r == FALSE) echo "r=false\n";

$r = aoi2db_select($db, 'info', array(), array());
if ($r == FALSE) echo "r=false\n";


print_r(
  $r
);

?>
