<html lang="ja">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=euc-jp">
  <title>��2CGI�ǤΥ��åȥ��å�</title>
</head>

<body>

<h1>��2CGI�ǤΥ��åȥ��å�</h1>
<blockquote>
<?php
// -------------------------------------------------------------
// DB����
// -------------------------------------------------------------
include_once("cgi/aoi2config_ini.php");
// -------------------------------------------------------------
// setup finished?
if (file_exists("config_editor.xml")) {
  echo '<pre>';
  err('���˥��åȥ��åפ���λ���Ƥ��ޤ���'."\n".
      '���åȥ��åפ���ľ�����ϡ�.xml/.js�ե�����������Ƥ���������');
}

// -------------------------------------------------------------
if ($_GET['mode'] == 'chk') {
  echo "<p><a href='./setup.php'>�����åȥ��åפ�Ԥ�</a></p>";
  echo phpinfo();
  exit(-1);
}
// -------------------------------------------------------------
// path �λ��꤬���뤫��
$path = isset($_GET['path']) ? $_GET['path'] : FALSE;
if ($path == "http://") $path = FALSE;
if (!$path) {
  ?>
    <form action="./setup.php" method="GET">
      ���󥹥ȡ���ѥ�����ꤷ�Ƥ���������:<br>
      <input type="text" name="path" value="http://" size=50>
      <input type="submit" value="�¹�">
      <p><a href='./setup.php?mode=chk'>��PHP������򸫤�</a></p>
    </form></body></html>
  <?php
  exit(-1);
}


// -------------------------------------------------------------
// Check writable readable
echo "<pre>\n";
echo "���åȥ��åפ�Ϥ�ޤ���\n";

// check path
// data dir
$writable_ary = array(
  "cgi/data",
  "."
  );
$readable_ary = array(
  "cgi/data",
  "cgi",
  );
foreach ($writable_ary as $f) {
  if (!is_writable($f)) {
    echo "�񤭹��߸��¤�Ĥ��Ƥ���������: $f \n";
  }
}
foreach ($writable_ary as $f) {
  if (!is_writable($f)) {
    echo "�ɤ߹��߸��¤�Ĥ��Ƥ���������: $f \n";
  }
}


// -------------------------------------------------------------
// create db
echo "�ǡ����١�������� : $FILE_FILEDB\n";
$db = sqlite_open("$DIR_CGI/$FILE_FILEDB", 0666, $errmsg);
if (!$db) err( $errmsg );

// sql
$sql = file_get_contents("$DIR_CGI/$FILE_FILEDB_DEF");

echo "�ǡ����١���������\n";
$res = sqlite_exec($db, $sql);
if ($res == FALSE) err('�ǡ����١����ν�����˼���');

sqlite_close($db);

// -------------------------------------------------------------
// path
if (substr($path, strlen($path) - 1, 1) != "/") {
  $path .= "/";
}
echo "����ѥ���񤭴����ޤ���: $path\n";

// -------------------------------------------------------------
// replace [[BASE_PATH_URL]]
$xml = file_get_contents("config_editor.xml.tmp");
$xml = str_replace("[[BASE_PATH_URL]]", $path, $xml);
$fp  = fopen("config_editor.xml", "w");
fwrite($fp, $xml);
fclose($fp);
// -------------------------------------------------------------
$js = file_get_contents("config_cgi.js.tmp");
$js = str_replace("[[BASE_PATH_URL]]", $path, $js);
$fp  = fopen("config_cgi.js", "w");
fwrite($fp, $js);
fclose($fp);



?>
<p>
̵�����åȥ��åפ���λ���ޤ�����
�����Τ��ᡢsetup.php �� cgi/setup �ե�����������Ƥ���������
ok.
</p>
</blockquote>


<?php
//----------------------------------------------------------------------
function err($msg)
{
    echo "���Ԥ��ޤ�������ͳ��$msg\n";
    echo "---\n";
    echo "*��table info already exist�פΥ��顼���Ф��Ȥ��ϡ�data�ե���������������ƺƼ¹Ԥ��Ƥ���������\n";
    echo "*SQLite2���Ȥ��뤫��ǧ���Ƥ���������\n";
    echo "*�񤭹��߸��¡��ɤ߹��߸��¤��ǧ���Ƥ���������";
    exit(-1);
}
//----------------------------------------------------------------------
?>
</body>
</html>
