<?php

use PhpOffice\PhpSpreadsheet\Spreadsheet;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

define('MODX_API_MODE', true);
define('IN_MANAGER_MODE', true);
define('NO_TRACY', true);

include_once(__DIR__ . "/../../../index.php");
$modx->db->connect();
if (empty ($modx->config)) {
    $modx->getSettings();
}

if (!isset($_SERVER['HTTP_X_REQUESTED_WITH']) || (strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) != 'xmlhttprequest')) {
    $modx->sendRedirect($modx->getConfig('site_url'));
}
//////
if (IN_MANAGER_MODE != "true" || empty($modx) || !($modx instanceof DocumentParser)) {
    die("<b>INCLUDE_ORDERING_ERROR</b><br /><br />Please use the MODX Content Manager instead of accessing this file directly.");
}
if (!$modx->hasPermission('exec_module')) {
    header("location: " . $modx->getManagerPath() . "?a=106");
}
/*if (!is_array($modx->event->params)) {
    $modx->event->params = array();
}*/
if (!isset($_SESSION['mgrValidated'])) {
    die();
}
/////

require_once(MODX_BASE_PATH . "assets/modules/editdocs/editdocs.class.php");

$obj = new editDocs($modx);

if (!empty($_POST['clear'])) {
    $obj->clearCache();
    echo $obj->lang['cleared'];
}


if (!empty($_POST['edit'])) {
    echo $obj->getAllList();
}


if (!empty($_POST['id'])) {

    echo $obj->editDoc();

}

if (!empty($_FILES['myfile'])) {
    //print_r($_FILES);
    echo $obj->uploadFile();

}

if (!empty($_POST['imp'])) {
    //print_r($_FILES);
    echo $obj->importExcel();
}

if (!empty($_POST['export'])) {
    //print_r($_FILES);
    echo $obj->export();
}


if (!empty($_POST['parent1']) && !empty($_POST['parent2'])) {
    echo $obj->massMove();
} else if (isset($_POST['parent1']) || isset($_POST['parent2'])) echo '<div class="alert alert-danger">' . $obj->lang['notall'] . '</div>';

if (!empty($_POST['cls']) && $_POST['cls'] == 1) {
    //удаляем сессии после обработки
    $_SESSION['import_start'] = 2; //начинаем импорт со второй строки файла
    $_SESSION['import_i'] = 0;
    $_SESSION['import_j'] = 0;
    $_SESSION['tabrows'] = '';
    return;
}

//save config
if (!empty($_POST['save_config'])) {

    $obj->saveConfig($_POST);
}

//ajax select render config files
if (!empty($_POST['getlist_files'])) {

    echo $obj->loadListFiles($_POST['getlist_files']);
}

//load config files
if (!empty($_POST['cfg_file'])) {
    echo $obj->loadCfgFile($_POST['cfg_file']);
}


?>
