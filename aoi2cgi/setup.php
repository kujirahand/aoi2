<html lang="ja">

<head>
  <meta http-equiv="Content-Type" content="text/html; charset=euc-jp">
  <title>葵2CGI版のセットアップ</title>
</head>

<body>

<h1>葵2CGI版のセットアップ</h1>
<blockquote>
<?php
// -------------------------------------------------------------
// DBを作る
// -------------------------------------------------------------
include_once("cgi/aoi2config_ini.php");
// -------------------------------------------------------------
// setup finished?
if (file_exists("config_editor.xml")) {
  echo '<pre>';
  err('既にセットアップが完了しています。'."\n".
      'セットアップをやり直す時は、.xml/.jsファイルを削除してください。');
}

// -------------------------------------------------------------
if ($_GET['mode'] == 'chk') {
  echo "<p><a href='./setup.php'>→セットアップを行う</a></p>";
  echo phpinfo();
  exit(-1);
}
// -------------------------------------------------------------
// path の指定があるか？
$path = isset($_GET['path']) ? $_GET['path'] : FALSE;
if ($path == "http://") $path = FALSE;
if (!$path) {
  ?>
    <form action="./setup.php" method="GET">
      インストールパスを指定してください。:<br>
      <input type="text" name="path" value="http://" size=50>
      <input type="submit" value="実行">
      <p><a href='./setup.php?mode=chk'>→PHPの設定を見る</a></p>
    </form></body></html>
  <?php
  exit(-1);
}


// -------------------------------------------------------------
// Check writable readable
echo "<pre>\n";
echo "セットアップを始めます。\n";

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
    echo "書き込み権限をつけてください。: $f \n";
  }
}
foreach ($writable_ary as $f) {
  if (!is_writable($f)) {
    echo "読み込み権限をつけてください。: $f \n";
  }
}


// -------------------------------------------------------------
// create db
echo "データベースを作成 : $FILE_FILEDB\n";
$db = sqlite_open("$DIR_CGI/$FILE_FILEDB", 0666, $errmsg);
if (!$db) err( $errmsg );

// sql
$sql = file_get_contents("$DIR_CGI/$FILE_FILEDB_DEF");

echo "データベースを初期化\n";
$res = sqlite_exec($db, $sql);
if ($res == FALSE) err('データベースの初期化に失敗');

sqlite_close($db);

// -------------------------------------------------------------
// path
if (substr($path, strlen($path) - 1, 1) != "/") {
  $path .= "/";
}
echo "設定パスを書き換えます。: $path\n";

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
無事セットアップが完了しました。
安全のため、setup.php と cgi/setup フォルダを削除してください。
ok.
</p>
</blockquote>


<?php
//----------------------------------------------------------------------
function err($msg)
{
    echo "失敗しました。理由：$msg\n";
    echo "---\n";
    echo "*「table info already exist」のエラーが出たときは、dataフォルダの中をを削除して再実行してください。\n";
    echo "*SQLite2が使えるか確認してください。\n";
    echo "*書き込み権限、読み込み権限を確認してください。";
    exit(-1);
}
//----------------------------------------------------------------------
?>
</body>
</html>
