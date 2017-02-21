<?php
define('MODX_API_MODE', true);
define('IN_MANAGER_MODE', true);

include_once( dirname(__DIR__) . '../../../index.php');
include_once( MODX_BASE_PATH . 'assets/lib/MODxAPI/modResource.php');

$modx->db->connect();
if (empty ($modx->config)) {
    $modx->getSettings();
}
$modx->invokeEvent("OnWebPageInit");

if (!isset($_SERVER['HTTP_X_REQUESTED_WITH']) || (strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) != 'xmlhttprequest')) {
    $modx->sendRedirect($modx->config['site_url']);
}

if (IN_MANAGER_MODE != "true" || empty($modx) || !($modx instanceof DocumentParser)) {
    die("<b>INCLUDE_ORDERING_ERROR</b><br /><br />Please use the MODX Content Manager instead of accessing this file directly.");
}
if (!$modx->hasPermission('exec_module')) {
    header("location: " . $modx->getManagerPath() . "?a=106");
}
if (!is_array($modx->event->params)) {
    $modx->event->params = array();
}
if (!isset($_SESSION['mgrValidated'])) {
    die();
}

include_once(__DIR__ . '/core/EditDocs.php');

$obj = new editDocs($modx);

if ($_POST['clear']) {
    $obj->clearCache($modx);
    echo 'Кэш очищен';
}

if ($_POST['bigparent']) {
    echo $obj->getAllList($modx);
}

if ($_POST['id']) {
    echo $obj->editDoc($modx);
}

if ($_FILES['myfile']) {
    echo $obj->uploadFile($modx);
}
if ($_POST['upd']) {
    echo $obj->updateExcel($modx);
}

if ($_POST['imp']) {
    echo $obj->importExcel($modx);
}

?>