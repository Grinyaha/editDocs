<?php

define('MODX_API_MODE', true);
define('IN_MANAGER_MODE', true);

include_once(__DIR__."/../../../index.php");
$modx->db->connect();
if (empty ($modx->config)) {
    $modx->getSettings();
}
$modx->invokeEvent("OnWebPageInit");

if (!isset($_SERVER['HTTP_X_REQUESTED_WITH']) || (strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) != 'xmlhttprequest')) {
    $modx->sendRedirect($modx->config['site_url']);
}
//////
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
/////


include_once(MODX_BASE_PATH . "assets/lib/MODxAPI/modResource.php");


if ($_POST['clear']) {
    clearCache(MODX_BASE_PATH);
    echo 'Кэш очищен';
}


if ($_POST['bigparent']) {
    echo getAllList();
}


if ($_POST['id']) {

    echo editDoc();

}

/////////////// FUNCTIONS ////////////

function editDoc()
{
    global $modx;
    $doc = new modResource($modx);


    $id = $_POST['id'];
    $data = $_POST['dat'];
    $pole = $_POST['pole'];

    $doc->edit($id);
    $doc->set($pole, $data);
    $end = $doc->save(false, false);

    if ($end) {
        return '<div class="alert-ok">Ресурс ' . $id . ' - отредактирован!';
    } else {
        return '<div class="alert-err">ERROR!</div>';
    }
    //print_r($_POST);
}


function getAllList()
{
    global $modx;
    $doc = new modResource($modx);

    $parent = $modx->db->escape($_POST['bigparent']);

    if ($_POST['fields']) {

        $fields = $modx->db->escape($_POST['fields']);
        $depth = $modx->db->escape($_POST['tree']);
        $r = '';
        $tvlist = '';
        $rowth = '';

        foreach ($fields as $val) {
            $r .= '[+' . $val . '+] - ';
            $tvlist .= $val . ',';
            $rowth .= '<td>'.$val.'</td>';
            $rowtd .= '<td><input type="text" name="' . $val . '" value="[+'.$val.'+]"  /></td>';
        }

        $tvlist = substr($tvlist, 0, strlen($tvlist) - 1);
        $tab = '
        <form id="dataf">
            <table class="tabres">
            <tr>
                <td>id</td>' . $rowth . '
        </tr>   
         ';
        $endtab = '</table></form><br/>';

        $out = $modx->runSnippet('DocLister', array(
            'idType' => 'parents',
            'depth' => $depth,
            'parents' => $parent,
            'showParent' => -1,
            'tvPrefix' => '',
            'tvList' => $tvlist,
            'tpl' => '@CODE:  <tr class="row"><td class="idd">[+id+]</td>'.$rowtd.'</tr>'


        ));
        //$zz = $doc->edit($parent)->toArray();

        //print_r($zz);
        echo $tab.$out.$endtab;


    }


}




function clearCache($path)
{

    global $modx;
    $modx->clearCache();
    include_once $path . 'manager/processors/cache_sync.class.processor.php';
    $sync = new synccache();
    $sync->setCachepath($path . "assets/cache/");
    $sync->setReport(false);
    $sync->emptyCache();
}


?>