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
function str_in($str) {
    $tmp = explode(',', $str);
    foreach ($tmp as $k => $v) {
        $tmp[$k] = "'" . trim($v) . "'";
    }
    return implode(',', $tmp);
}
global $_lang;

//проверяем версию evo
$v = $modx->getConfig('settings_version');
$vm = explode('.',$v);
if($vm[0]==3) {
    if(!file_exists(MODX_BASE_PATH.'core/vendor/pathologic/modxapi/src/modResource.php'))
    {
    echo '<p><br>Для работы модуля необходимо установить пакет MODxAPI для EVO 3. <br><a href="https://github.com/Pathologic/MODxAPI" target="_blank" >https://github.com/Pathologic/MODxAPI</a></p>
    <p>В папке <b>core</b> выполняем команду из командной строки <b>composer require pathologic/modxapi</b></p>';
    die;
    }
}

//Подключаем обработку шаблонов через DocLister
include_once(MODX_BASE_PATH . 'assets/snippets/DocLister/lib/DLTemplate.class.php');
$dlt = DLTemplate::getInstance($modx);
$dlt->setTemplatePath('assets/modules/editdocs/tpl/');
$dlt->setTemplateExtension('tpl');

$moduleurl = 'index.php?a=112&id=' . $_GET['id'] . '&';
$action = isset($_GET['action']) ? $_GET['action'] : 'branch';

//site_content fields
$fields = '';
if (isset($modx->event->params['include_fields']) && $modx->event->params['include_fields'] != '') {
    $tmp = array_map('trim', explode(',', $modx->event->params['include_fields']));
    $field_names = array('longtitle' => 'long_title', 'content' => 'resource_content', 'published' => 'page_data_published', 'introtext' => 'resource_summary', 'alias' => 'resource_alias', 'template' => 'page_data_template', 'menutitle' => 'resource_opt_menu_title', 'menuindex' => 'resource_opt_menu_index');
    foreach ($tmp as $field) {
        if ($field != 'id') {
            $field_name = isset($field_names[$field]) ? $field_names[$field] : $field;
            $fields .= '<option value="' . $field . '">' . (isset($_lang[$field_name]) ? $field.' ('.$_lang[$field_name].')' : $field) . '</option>';
        }
    }
}
//tv-name list
$where_tv = '';
if (isset($modx->event->params['include_tvs']) && $modx->event->params['include_tvs'] != '') {
    $where_tv .= ' WHERE name IN (' . str_in($modx->event->params['include_tvs']) . ') ';
}
$query = $modx->db->query("SELECT name,caption FROM " . $modx->getFullTableName('site_tmplvars') . " " . $where_tv . " ORDER BY caption ASC");
$tvs = '';
while ($row = $modx->db->getRow($query)) {
    $tvs .= '<option value="' . $row['name'] . '">' . $row['name'].' ('.$row['caption'] . ')</option>';
}

//language
$lng = $modx->getConfig('manager_language');
if(file_exists(MODX_BASE_PATH.'assets/modules/editdocs/lang/'.$lng.'.inc.php')) require_once(MODX_BASE_PATH.'assets/modules/editdocs/lang/'.$lng.'.inc.php');
else require_once(MODX_BASE_PATH.'assets/modules/editdocs/lang/russian-UTF8.inc.php');

//templates list
$where_tmpl = '';
if (isset($modx->event->params['include_tmpls']) && $modx->event->params['include_tmpls'] != '') {
    $where_tmpl .= ' WHERE id IN (' . str_in($modx->event->params['include_tmpls']) . ') ';
}
$query2 = $modx->db->query("SELECT id,templatename FROM " . $modx->getFullTableName('site_templates') . $where_tmpl);
$tpl = '';
while ($row = $modx->db->getRow($query2)) {
    $tpl .= '<option value="' . $row['id'] . '">' . $row['templatename'] . '</option>';
}

//prepare snippets
$pquery = $modx->db->query("SELECT name FROM " . $modx->getFullTableName('site_snippets') . " WHERE name LIKE '%editDocs%' AND disabled=0");
$prp = '';
while ($rou = $modx->db->getRow($pquery)) {
    $prp .= '<option value="' . $rou['name'] . '">' . $rou['name'] . '</option>';
}

if (isset($modx->event->params['win1251']) && $modx->event->params['win1251']=='true') $checked = 'checked';

$data = array (
    'tpl' => $tpl,
    'fields' => $fields,
    'tvs' => $tvs,
    'moduleurl' => $moduleurl,
    'manager_theme' => $modx->config['manager_theme'],
    'manager_path' => $modx->getManagerPath(),
    'base_url' => $modx->config['base_url'],
    'session' => $_SESSION,
    'get' => $_GET,
    'action' => $action ,
    'selected' => array($action => 'selected'),
    'checked' => $checked,
    'lang' => $lang,
    'prepare_options' => $prp
);

if ($action == 'branch') {
    if(!empty($_SESSION['data'])) unset($_SESSION['data']);
    $outTpl = $dlt->parseChunk('@FILE:branch', $data);
}
if ($action == 'import') {
    if(!empty($_SESSION['data'])) unset($_SESSION['data']);
    $outTpl = $dlt->parseChunk('@FILE:import', $data);
}
if ($action == 'export') {
    if(!empty($_SESSION['data'])) unset($_SESSION['data']);
    $outTpl = $dlt->parseChunk('@FILE:export', $data);
}
if ($action == 'mass') {
    if(!empty($_SESSION['data'])) unset($_SESSION['data']);
    $outTpl = $dlt->parseChunk('@FILE:mass', $data);
}

$output = $dlt->parseChunk('@FILE:header', $data) . $outTpl . $dlt->parseChunk('@FILE:footer', $data);
echo $output;

?>
