<html lang="ja">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=euc-jp"> 
  <title>��2</title>
  <style type="text/css"><!--
  .loading { color: #000033; background-color: #CCCCFF; padding:16px; font-weight:bold; }
  .mark    { color: #000000; background-color: #FFCCCC; }
  .mp      { margin:0; padding:0; text-align:center; }
  body     { width:1024; height:640; }
  --></style> 
  <script type="text/javascript" src="webparts/benri.js"></script>
  <script type="text/javascript" src="webparts/swfobject.js"></script>
</head>

<body bgcolor="#F0F0FF" class="mp">
<center class="mp">
<?php
$x = isset($_GET['x']) ? $_GET['x'] : 640;
$y = isset($_GET['y']) ? $_GET['y'] : 400;
$file_id = isset($_GET['file_id']) ? $_GET['file_id'] : 0;
if ($file_id == 0) {
    echo "�ե����뤬����ޤ���";
}
else {
if ($x < 1000) {
  echo "<br/>\n";
}
?>
<div id="swf" class="mp">
�¹Ԥˤϡ�Flash Player���ʹߤ�ɬ�פǤ���
</div>
<script type="text/javascript"><!--
  var file_id = <?php echo $file_id;?>;
  var url = "webparts/aoivm.swf?mainfile=../cgi/cmd_loadCode.php?file_id=" + file_id;
  var swf = new SWFObject(url, "aoivm", "<?php echo $x;?>", "<?php echo $y;?>", "7", "white");//
  swf.addVariable("library_path", "webparts");//
  swf.write("swf");//
//-->
</script>
<?php
}
// ---- �̾掠������ SWF �Ǥ�������ɽ������
if ($x < 1000) {
?>
<br><div id='info'></div><a href="./aoi2show.php?file_id=<?php echo $file_id; ?>&x=1024&y=640">[���粽]</a><br>
<br>
<script type="text/javascript"><!--
  var file_id = <?php echo $file_id;?>;
  function getInfo() {
    var req = new KHttp();
    var url = "cgi/cmd_files.php?file_id=" + file_id;
    req.onComplete = getInfo_complete;
    req.onError = function(err,code) { $('info').innerHTML = "***"; }
    req.send(url, "GET");
  }
  function getInfo_complete(json) {
    var obj;
    try {
      eval("obj="+json+";");
    } catch (e) {
      $('info').innerHTML = "***";
      return;
    }
    if (obj && obj.files && obj.files[0]) {
      var info = obj['files'][0];
      var user_name = info['user_name'];
      var filename  = info['filename'];
      var public_attr = info['public_attr'];
      if (public_attr == 1) {
        $('info').innerHTML = filename + " posted by (c)" + user_name;
      } else {
        $('info').innerHTML = "���Υץ����ϸ�������Ƥ��ޤ���";
      }
    } else {
      $('info').innerHTML = "***";
    }
  }
  getInfo();
//-->
</script>

<br>
<br>
<br>
<a href="http://aoi-project.com/">����2</a><br>
<?php
}
?>
</center>
</body>
</html>
