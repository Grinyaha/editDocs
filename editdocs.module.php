<?php

if (IN_MANAGER_MODE != "true" || empty($modx) || !($modx instanceof DocumentParser)) {
    die("<b>INCLUDE_ORDERING_ERROR</b><br /><br />Please use the MODX Content Manager instead of accessing this file directly.");
}
if (!$modx->hasPermission('exec_module')) {
    header("location: " . $modx->getManagerPath() . "?a=106");
}
if(!is_array($modx->event->params)){
    $modx->event->params = array();
}

//Подключаем обработку шаблонов через DocLister
include_once(MODX_BASE_PATH.'assets/snippets/DocLister/lib/DLTemplate.class.php');
$dlt = DLTemplate::getInstance($modx);

$moduleurl = 'index.php?a=112&id='.$_GET['id'].'&';
$action = isset($_GET['action']) ? $_GET['action'] : 'branch';

//tv-name list
$query = $modx->db->query("SELECT name FROM ".$modx->getFullTableName('site_tmplvars'));
$tvs = '';
while( $row = $modx->db->getRow($query) ) {
    $tvs .= '<option value="'.$row['name'].'">'.$row['name'].'</option>';
}

//templates list
$query2 = $modx->db->query("SELECT id,templatename FROM ".$modx->getFullTableName('site_templates'));
$tpl = '';
while( $rou = $modx->db->getRow($query2) ) {
    $tpl .= '<option value="'.$rou['id'].'">'.$rou['templatename'].'</option>';
}

$data = array ('tpl'=>$tpl,'tvs'=>$tvs,'moduleurl'=>$moduleurl, 'manager_theme'=>$modx->config['manager_theme'], 'manager_path'=>$modx->getManagerPath(), 'base_url'=>$modx->config['base_url'], 'session'=>$_SESSION,'get'=>$_GET, 'action'=>$action , 'selected'=>array($action=>'selected'));

if($action=='branch') {
    $branch = '@CODE:'.file_get_contents(dirname(__FILE__).'/tpl/branch.tpl');
    $outTpl = $dlt->parseChunk($branch,$data);


}

if($action=='excel') {
    $excel = '@CODE:'.file_get_contents(dirname(__FILE__).'/tpl/excel.tpl');
    $outTpl = $dlt->parseChunk($excel,$data);


}

if($action=='import') {
    $import = '@CODE:'.file_get_contents(dirname(__FILE__).'/tpl/import.tpl');
    $outTpl = $dlt->parseChunk($import,$data);


}



$header = '@CODE:'.file_get_contents(dirname(__FILE__).'/tpl/header.tpl');
$footer = '@CODE:'.file_get_contents(dirname(__FILE__).'/tpl/footer.tpl');

$output = $dlt->parseChunk($header,$data).$outTpl.$dlt->parseChunk($footer,$data);
echo $output;

?>