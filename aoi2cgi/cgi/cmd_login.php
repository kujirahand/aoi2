<?php
//----------------------------------------------------------------------
// cmd_login.php
//----------------------------------------------------------------------
/** login
 * @param   mail
 * @param   password
 * @return  json = {'result':true/false, 'user':{name:xxx,comment:xxx,..}}
 */

include_once('aoi2file.inc');

$mail = getParam('mail', '');
$pass = getParam('password', '');

if ($mail == '' || $pass == '') return 0;

$db = new AOI2_DB();
$db->open();
$result = $db->login($mail, $pass);
$db->close();

echo $result;
?>

