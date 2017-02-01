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

$obj = new editDocs();

if ($_POST['clear']) {
    $obj -> clearCache($modx);
    echo 'Кэш очищен';
}


if ($_POST['bigparent']) {
    echo $obj -> getAllList($modx);
}


if ($_POST['id']) {

    echo $obj -> editDoc($modx);

}

/////////////// CLASS ////////////

class editDocs
{


public function editDoc($modx)
    {
        include_once(MODX_BASE_PATH . "assets/lib/MODxAPI/modResource.php");
        $this->modx = $modx;
        $this->doc = new modResource($this->modx);


        $this->id = $_POST['id'];
        $this->data = $_POST['dat'];
        $this->pole = $_POST['pole'];

        $this->doc->edit($this->id);
        $this->doc->set($this->pole, $this->data);
        $this->end = $this->doc->save(false, false);

        if ($this->end) {
            return '<div class="alert-ok">Ресурс ' . $this->id . ' - отредактирован!';
        } else {
            return '<div class="alert-err">ERROR!</div>';
        }

    }


public function getAllList($modx)
{
    include_once(MODX_BASE_PATH . "assets/lib/MODxAPI/modResource.php");
    $this->modx = $modx;
    $this->doc = new modResource($this->modx);

    $this->parent = $this->modx->db->escape($_POST['bigparent']);

    //return $this->parent;

    if ($_POST['fields']) {

        $this->fields = $this->modx->db->escape($_POST['fields']);
        $this->depth = $this->modx->db->escape($_POST['tree']);

        if($_POST['paginat']) $this->disp = 20; else $this->disp = 0;


        foreach ($this->fields as $val) {
            $this->r .= '[+' . $val . '+] - ';
            $this->tvlist .= $val . ',';
            $this->rowth .= '<td>' . $val . '</td>';
            $this->rowtd .= '<td><input type="text" name="' . $val . '" value="[+' . $val . '+]"  /></td>';
        }

        $this->tvlist = substr($this->tvlist, 0, strlen($this->tvlist) - 1);
        $this->tab = '
<form id="dataf">
    <table class="tabres">
        <tr>
            <td>id</td>' . $this->rowth . '
        </tr>
        ';
        $this->endtab = '</table></form><br/>';

        $this->out = $this->modx->runSnippet('DocLister', array(
            'idType' => 'parents',
            'depth' => $this->depth,
            'parents' => $this->parent,
            'showParent' => -1,
            'id' => 'list',
            'paginate' => 'pages',
            'pageLimit' => '1',
            'pageAdjacents' => '5',
            'TplPage' => '@CODE:<span class="page">[+num+]</span>',
            'TplCurrentPage' => '@CODE:<b class="current">[+num+]</b>',
            'TplNextP' => '',
            'TplPrevP' => '',
            'TplDotsPage' => '@CODE:&nbsp;...&nbsp;',
            'display' => $this->disp,
            'tvPrefix' => '',
            'ownerTPL' => '@CHUNK: paginateEditDocs',
            'tvList' => $this->tvlist,
            'tpl' => '@CODE:  <tr class="row"><td class="idd">[+id+]</td>' . $this->rowtd . '</tr>'


        ));

        //$this->paginate = $this->modx->getPlacholder('list.pages');

        return $this->tab . $this->out . $this->endtab ;

    }
    else return 'Выберите поля/TV для редактирования!';
}







public function clearCache($modx)
    {
        include_once(MODX_BASE_PATH . "assets/lib/MODxAPI/modResource.php");
        $this->modx = $modx;
        $this->modx->clearCache();
        include_once MODX_BASE_PATH . 'manager/processors/cache_sync.class.processor.php';
        $this->sync = new synccache();
        $this->sync->setCachepath(MODX_BASE_PATH . "assets/cache/");
        $this->sync->setReport(false);
        $this->sync->emptyCache();
    }

}

?>