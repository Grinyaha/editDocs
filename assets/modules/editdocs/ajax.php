<?php

define('MODX_API_MODE', true);
define('IN_MANAGER_MODE', true);

include_once(__DIR__ . "/../../../index.php");
$modx->db->connect();
if (empty ($modx->config)) {
    $modx->getSettings();
}

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

$obj = new editDocs($modx);

if ($_POST['clear']) {
    $obj->clearCache();
    echo 'Кэш очищен';
}


if ($_POST['bigparent'] || $_POST['bigparent'] == '0') {
    echo $obj->getAllList();
}
if ($_POST['bigparent']=='' && $_POST['edit']==1) echo '<div class="alert alert-danger">Выберите ID родителя!</div>';


if ($_POST['id']) {

    echo $obj->editDoc();

}

if ($_FILES['myfile']) {
    //print_r($_FILES);
    echo $obj->uploadFile();

}

if ($_POST['imp']) {
    //print_r($_FILES);
    echo $obj->importExcel();
}

if ($_POST['export'] && $_POST['stparent']!='') {
    //print_r($_FILES);
    echo $obj -> export();
}
if ($_POST['export']==1 && $_POST['stparent']=='') echo '<div class="alert alert-danger">Выберите ID родителя!</div>';

if (isset($_POST['parent1']) && isset($_POST['parent2']) && $_POST['parent1']!='' && $_POST['parent2']!='') {
    echo $obj -> massMove();
}
else if(isset($_POST['parent1']) || isset($_POST['parent2'])) echo '<div class="alert alert-danger">Не все поля заполнены!</div>';

if($_POST['cls']==1) {
    //удаляем сессии после обработки
    $_SESSION['import_start'] = 2; //начинаем импорт со второй строки файла
    $_SESSION['import_i']=0;
    $_SESSION['import_j']=0;
    unset($_SESSION['tabrows']);
    return;
}
/////////////// CLASS ////////////

class editDocs
{
    public function __construct($modx)
    {
        $this->modx = $modx;
        $this->params = $this->parseModuleParams('editDocs');
        include_once(MODX_BASE_PATH . "assets/lib/MODxAPI/modResource.php");
        $this->doc = new modResource($this->modx);
        $this->step = !empty($this->params['step']) && (int)$this->params['step'] > 0 ? (int)$this->params['step'] : 500;//сколько строк за раз импортируем
        $this->start_line = 2;//начинаем импорт со второй строки файла
        $this->params['max_rows'] = false; //количество выводимых на экран строк таблицы после импорта / загрузки файла . false - если не нужно ограничивать
        $this->snipPrepare = !empty($this->params['prepare_snippet']) ? $this->params['prepare_snippet'] : 'editDocsPrepare1';//сниппет prepare
    }

    public function parseModuleParams($name)
    {
        $params = array();
        $props = $this->modx->db->getValue("SELECT `properties` FROM " . $this->modx->getFullTableName("site_modules") . " WHERE `name` LIKE '%" . $name . "%' AND disabled=0 ORDER BY id DESC LIMIT 0,1");
        if (!empty($props)) {
            $params = $this->modx->parseProperties($props);
        }
        return $params;
    }

    public function editDoc()
    {


        $id = $_POST['id'];
        $data = $_POST['dat'];
        $pole = $_POST['pole'];

        $this->doc->edit($id);
        $this->doc->set($pole, $data);
        $end = $this->doc->save(true, false);
        if($pole=='category' && $data!='' && $data!=0 && $this->checkTableMC() ) {
            $ctm = explode(',',$data);
            $que = $this->modx->db->query("DELETE FROM " . $this->modx->getFullTableName('site_content_categories') . " WHERE doc=" . $end);
            foreach ($ctm as $valoc) {
                $que2 = $this->modx->db->query("INSERT INTO ".$this->modx->getFullTableName('site_content_categories')." SET category=".$valoc.", doc=".$end);
            }
        }

        if ($end) {
            return 'Ресурс ' . $id . ' - отредактирован!';
        } else {
            return '<div class="alert alert-danger">ERROR!</div>';
        }

    }


    public function getAllList()
    {

        $this->parent = $this->modx->db->escape($_POST['bigparent']);

        //return $this->parent;

        if ($_POST['fields']) {

            $this->fields = $this->modx->db->escape($_POST['fields']);
            $this->depth = $this->modx->db->escape($_POST['tree']);

            if ($_POST['paginat']) $this->disp = 40; else $this->disp = 0;
            if ($_POST['neopub']) $this->addw = 1; else $this->addw = '';



            foreach ($this->fields as $val) {
                $this->r .= '[+' . $val . '+] - ';
                $this->tvlist .= $val . ',';
                if(!empty($_POST['tvpic'])) $this->tvlist .= $_POST['tvpic'].',';
                $this->rowth .= '<td>' . $val . '</td>';

                //for multiCategories header
                if(isset($_POST['multed']) && $this->checkTableMC() ) $this->rowth .= '<td>category</td>';

                $this->rowtd .= '<td><textarea name="' . $val . '" class="tarea">[+' . $val . '+]</textarea></td>';
                //for multiCategories
                if(isset($_POST['multed']) && $this->checkTableMC() ) $this->rowtd .= '<td><input name="category" class="tarea" type="text" value="[+category+]"></input></td>';
            }

            $this->tvlist = substr($this->tvlist, 0, strlen($this->tvlist) - 1);
            $this->tab = '
<form id="dataf">
    <table class="tabres">
        <tr>
            <td width="100">id</td>' . $this->rowth . '
        </tr>
        ';
            $this->endtab = '</table></form><br/>';

            if($_POST['filters']!='') $this->filters = $_POST['filters']; else $this->filters ='';
            if($_POST['addwhere']!='') $this->addwhere = $_POST['addwhere']; else $this->addwhere ='';

            $this->out = $this->modx->runSnippet('DocLister', array(
                'idType' => 'parents',
                'depth' => $this->depth,
                'parents' => $this->parent,
                'showParent' => 1,
                'id' => 'list',
                'paginate' => 'pages',
                'pageLimit' => '1',
                'pageAdjacents' => '5',
                'TplPage' => '@CODE:<span class="page" work="[+num+]">[+num+]</span>',
                'TplCurrentPage' => '@CODE:<b class="current" work="[+num+]">[+num+]</b>',
                'TplNextP' => '',
                'TplPrevP' => '',
                'TplDotsPage' => '@CODE:&nbsp;...&nbsp;',
                'display' => $this->disp,
                'tvPrefix' => '',
                'ownerTPL' => '@CODE: [+dl.wrap+][+list.pages+]',
                'TplWrapPaginate' => '@CODE: <tr><td colspan="100" align="center"><br/>[+wrap+]<br/></td></tr>',
                'tvList' => $this->tvlist,
                'filters' => $this->filters,
                'tpl' => '@CODE:  <tr class="ed-row"><td class="idd">[+id+]<br>[+piczzz+]</td>' . $this->rowtd . '</tr>',
                'addWhereList' => $this->addwhere,
                'showNoPublish' => $this->addw,
                'prepare' => function($data) {
                    //проверяем существование таблицы MultiCat и вкл. чекбокса
                    if(isset($_POST['multed']) && $this->checkTableMC() ) {
                        $que = $this->modx->db->query("SELECT category FROM ".$this->modx->getFullTableName('site_content_categories')." WHERE doc=".$data['id']);
                        if($this->modx->db->getRecordCount($que)>0) {

                            while ($rr = $this->modx->db->getRow($que)) {
                                $mcat[] = $rr['category'];
                            }
                            $rez = implode(',', $mcat);
                            if ($rez!='') $data['category'] = $rez;
                        }
                        else $data['category']='';
                    }

                    //show IMG
                    if(!empty($_POST['tvpic'])) {
                        $tvpic = $_POST['tvpic'];
                        $slash = '/';
                        if(substr($data[$tvpic], 0, 1)=='/') $slash = '';
                        if(substr($data[$tvpic], 0, 4)=='http') $slash = '';
                            //substr("abcdef", 0, 1)
                        $data['piczzz'] = '<img src="'.$slash.$data[$tvpic].'" width="100"/>';
                    }
                    else $data['piczzz'] = '';


                    return $data;
                }

            ));

            //$this->paginate = $this->modx->getPlacholder('list.pages');

            return $this->tab . $this->out . $this->endtab;

        } else return '<div class="alert alert-danger">Выберите поля/TV для редактирования!</div>';
    }


    public function uploadFile()
   {

        $output_dir = MODX_BASE_PATH . "assets/modules/editdocs/uploads/";

        $ret = array();
        $pathinfo = array();
        $error = $_FILES["myfile"]["error"];
        if (!is_array($_FILES["myfile"]["name"])) {//single file
            $fileName = $_FILES["myfile"]["name"];
            move_uploaded_file($_FILES["myfile"]["tmp_name"], $output_dir . $fileName);
            $ret[] = $fileName;
            $pathinfo = pathinfo($output_dir . $fileName);
        }
        if (isset($pathinfo['extension']) && $pathinfo['extension'] == 'csv') {
            //загрузили csv
            $tmp[] = array();
            if (($handle = fopen($output_dir . $fileName, "r")) !== false) {
                while (($tmp2 = fgetcsv($handle, 1000, ";")) !== false) {
                    $row = array();
                    foreach ($tmp2 as $k => $v) {
                        $encoding = mb_detect_encoding($v, array("Windows-1251", "UTF-8"));
                        if ($encoding && $encoding != "UTF-8") {
                            $v = iconv($encoding, "UTF-8", $v);
                        }
                        $row[$k] = $v;
                    }
                    $tmp[] = $row;
                }
            }
            unset($tmp[0]);
            $sheetData = $tmp;
        } else {
            //загрузили xls/xlsx
            include_once MODX_BASE_PATH . "assets/modules/editdocs/libs/PHPExcel/IOFactory.php";
            $objPHPExcel = PHPExcel_IOFactory::load($output_dir . $fileName);
            $sheetData = $objPHPExcel->getActiveSheet()->toArray(null, true, true, true);
        }

        //заменяем . на , в category
       $keyz = array_keys($sheetData);
       $firstKey = $keyz[0];
       $findcat = array_search('category', $sheetData[$firstKey]);

       if(!empty($findcat)) {
           foreach($sheetData as $keysh => $valsh) {
               $sheetData[$keysh][$findcat] = str_replace('.',',',$sheetData[$keysh][$findcat]);
           }}

        $_SESSION['data'] = $sheetData;
        $_SESSION['import_start'] = $this->start_line;
        $_SESSION['import_total'] = count($_SESSION['data']) + $_SESSION['import_start'] - 1;
        $_SESSION['import_i'] = $_SESSION['import_j'] = 0;
        echo $_SESSION['import_start'] . '#@Всего строк - ' . ($_SESSION['import_total'] - $this->start_line) . '#@' . $this->table($sheetData, $this->params['max_rows']);
        //print_r($sheetData);
        $_SESSION['tabrows'] = '';
    }

    public function importExcel()
    {

        // if (!$_POST['parimp'] || $_POST['parimp']=='') {
        //     return '<div class="alert alert-danger ">Введите ID родителя!</div>' . $this->table($_SESSION['data'], $this->params['max_rows']);
        // }
        if ($_SESSION['data']) {
            return $this->importReady($this->newMassif($_SESSION['data'])) ; //$this->table($_SESSION['data'], $this->params['max_rows'])
        } else return '<div class="alert alert-danger">Сессия устарела, загрузите файл заново! </div>';
    }


    protected function importReady($data)
    {
        $uniq = isset($_POST['checktv']) && $_POST['checktv'] != '0' ? $_POST['checktv'] : 'id';
        $check = $this->checkField($uniq);
        $i = 0;//количество добавленных
        $j = 0;//количество отредактированных
        $start = isset($_SESSION['import_start']) ? $_SESSION['import_start'] : 0;
        $finish = isset($_SESSION['import_start']) ? ($start + $this->step) : count($data);


        $this->checkPrepareSnip();//проверяем, есть ли обработчик prepare (сниппет)
        if($_SESSION['header_table']) {
            $theader = '';
            foreach($_SESSION['header_table'] as $valt) {
                $theader .= '<td>'.$valt.'</td>';
                if($valt=='parent') $parh = ''; else $parh = '<td>parent</td>';
                if($valt=='template') $ptmplh = ''; else $ptmplh = '<td>template</td>';
            }
        }
        $tabh = '<table  class="tabres"><tr>'.$theader.$ptmplh.$parh.'</tr>';
        $tabe = '</table>';

        for ($ii = $start; $ii < $finish; $ii++){
            if (!isset($data[$ii])) continue;
            $val = $data[$ii];

            $inbase = 0;
            if (isset($val[$uniq])) {
                $check[2] = $val[$uniq];
                $inbase = $this->getID($check);
            }
            foreach ($val as $key => $value) {
                $create[$key] = $value;
            }

            //если parent нет в массиве, смотрим в POST,
            if (empty($create['parent'])) {
                if(empty($_POST['parimp'])) unset($create['parent']);
                else $create['parent']= $this->modx->db->escape($_POST['parimp']);
            }

             //если НЕ тестовый режим
                if ( !$inbase) { //не существует в базе

                    if ($_POST['tpl']) $tpl = $this->modx->db->escape($_POST['tpl']);
                    if ($tpl != 'file') $create['template'] = $tpl;
                    if($tpl=='blank')  $create['template'] = 0;

                    //боевой режим (добавление)
                    if (!isset($_POST['test']) && empty($_POST['notadd']) ) {
                        //prepare create
                        if ($this->issetPrepare) {
                            $create = $this->makePrepare($create, 'new', 'import', 1); // 1 - game mode
                         }
                         $this->doc->create($create);
                         $new = $this->doc->save(true, false);

                         if (array_key_exists('category', $create) && isset($_POST['multi']) && $new>0 && $this->checkTableMC() ) {
                             $create['category'] = trim($create['category']);
                             $arrmc = explode(',',$create['category']);
                             foreach($arrmc as $vl) {
                            $que = $this->modx->db->query("INSERT INTO ".$this->modx->getFullTableName('site_content_categories')." SET category=".$vl.",doc=".$new);                                           }
                         }
                    }
                   //тестовый режим (добавление)
                   else {
                    if ($this->issetPrepare) {
                        $create = $this->makePrepare($create, 'new', 'import', 0); // 0 - test mode
                     }
                   }

                    if(!empty($_POST['notadd'])) { $css = 'td_notadd'; }
                    else $css = '';

                    $td = '';
                    foreach ($create as $key => $val) {

                        $td .= '<td class="td_add '.$css.'">'.$val.' </td>'; //add
                    }
                    $tr .= '<tr>'.$td.'</tr> ';
                    //$_SESSION['log'] .= '<hr>';
                    $i++;

                //боевой режим (обновление)
                } else if ($inbase > 0) {
                    if (!isset($_POST['test'])) {
                        if ($this->issetPrepare) {
                            $create = $this->makePrepare($create, 'upd', 'import',1); // 1 - game mode
                        }
                    $edit = $this->doc->edit($inbase)->fromArray($create)->save(true, false);

                            //если вкл.мультикатегории
                            if (array_key_exists('category', $create) && isset($_POST['multi']) && $this->checkTableMC() ) {
                                $ctm = explode(',',$create['category']);
                                $que = $this->modx->db->query("DELETE FROM " . $this->modx->getFullTableName('site_content_categories') . " WHERE doc=" . $edit);
                                foreach ($ctm as $valoc) {
                                    $que2 = $this->modx->db->query("INSERT INTO ".$this->modx->getFullTableName('site_content_categories')." SET category=".$valoc.", doc=".$edit);
                                }
                                //$que = $this->modx->db->query("UPDATE ".$this->modx->getFullTableName('site_content_categories')." SET category=".$create['category']." WHERE doc=".$edit);

                            }
                            $testInfo = '';
                    }
                    //тестовый режим (обновление)
                    else {
                        if ($this->issetPrepare) {
                            $create = $this->makePrepare($create, 'upd', 'import', 0); // 1 - game mode
                        }
                    }


                    $td = '';
                    foreach ($create as $key => $val) {
                        //$_SESSION['log'] .= $key . ' - ' . $val . ' - <b class="upd-text">обновление</b> '.$testInfo.'<br>';
                        $td .= '<td class="td_upd">'.$val.' </td>'; //edit
                    }
                    $tr .= '<tr>'.$td.'</tr> ';
                    //$_SESSION['log'] .= '<hr>';
                    $j++;
                }

        }
$_SESSION['tabrows'] .= $tr ;
        //$fulltab = $tabh.$tr.$tabe;
        $fortab = '<span class="td_add">&nbsp;</span>  добавлено &nbsp;&nbsp;&nbsp; <span class="td_notadd">&nbsp;</span> запрет на добавление&nbsp;&nbsp;&nbsp; <span class="td_upd">&nbsp;</span> отредактировано<br><br>';

        $_SESSION['import_i'] += $i;
        $_SESSION['import_j'] += $j;
        $_SESSION['import_start'] = $start + $i + $j;
        //тестовый режим
        if (isset($_POST['test'])) {
            //$this->modx->logEvent(1,1,$_SESSION['import_start'],'проверка заголовка таблицы '.$_SESSION['import_start']);
            $_SESSION['log'] = '<br><div class="alert alert-danger">Тестовый режим. Изменения <b>НЕ</b> вносятся</div>';

            return ($_SESSION['import_start'] - $this->start_line) . '#@' . ($_SESSION['import_total'] - $this->start_line) . '#@' . $_SESSION['log'].$fileobr. $fortab . $tabh . $_SESSION['tabrows'] . $tabe;
        }

        //боевой режим
        if (!isset($_POST['test'])) {
            $_SESSION['log'] = '<br><b>Добавлено - ' . $_SESSION['import_i'] . ', отредактировано - ' . $_SESSION['import_j'] . '</b> <hr>';
            //$fileobr = '<div class="alert alert-warning">Файл обработан. Для дальнейшей работы необходимо загрузить файл заново.</div>';

        }



        return ($_SESSION['import_start'] - $this->start_line) . '#@' . ($_SESSION['import_total'] - $this->start_line) . '#@' . $_SESSION['log']. $fortab . $tabh . $_SESSION['tabrows'] . $tabe;
        // #@ разделители для JS
    }

    protected function newMassif($data)
    {
        $j = 0;
        $this->data = $data;
        $this->sheetDataNew = array();

        foreach ($this->data[1] as $zna) {
            $this->newkeys[$j] = $zna;
            $j++;
        }

        foreach ($this->data as $k => $val) {
            if ($k > 1) {
                $i = 0;
                foreach ($val as $key => $value) {
                    $z = $this->newkeys[$i];
                    $this->dn[$z] = $value;

                    $i++;
                }
                $this->sheetDataNew[$k] = $this->dn;
            }
        }
        unset ($this->data);
        //print_r($this->sheetDataNew);
        return $this->sheetDataNew;
    }

    protected function table($data, $max = false)
    {
        $this->header = '<table class="tabres">';
        $this->footer = '</table>';
        //$this->zag = $data[1];
        $out = '';
        $i = 0;
        $_SESSION['header_table'] = array();
        foreach ($data as $k => $val) {
            $row = '';
            $i++;
            if ($max && $max + 1 < $i) break;
            foreach ($val as $key => $value) {
                if($i==1) $_SESSION['header_table'][] = $value; //заголовок таблицы
                $row .= '<td>' . $value . '</td>';
            }
            $this->out .= '<tr>' . $row  . '</tr>';
        }
        return $this->header . $this->out . $this->footer;
    }

    protected function checkField($field)
    {
        $this->field = $field;

        $this->param = array();
        $this->res = $this->modx->db->query("SELECT name FROM " . $this->modx->getFullTableName('site_tmplvars'));
        $this->temp = 0;
        while ($this->row = $this->modx->db->getRow($this->res)) {
            if ($this->row['name'] == $this->field) {
                $this->temp = 1;
                $this->param[0] = 'tv';
                $this->param[1] = $this->field;
            }
        }
        if ($this->temp == 0) {
            $this->res = $this->modx->db->query("SHOW columns FROM " . $this->modx->getFullTableName('site_content') . " where Field = '" . $field . "'");
            if ($this->modx->db->getRecordCount($this->res) > 0) {
                $this->param[0] = 'nonetv';
                $this->param[1] = $this->field;
            } else {
                $this->param[0] = 'notfound';
                $this->param[1] = $this->field;
            }
        }
        return $this->param;

    }

    public function getID($mode)
    {

        $this->mode = $mode;
        if ($this->mode[0] == 'tv') {
            $this->res = $this->modx->db->query("SELECT contentid FROM " . $this->modx->getFullTableName('site_tmplvar_contentvalues') . " WHERE value='" . $this->mode[2] . "'");
            if ($this->modx->db->getRecordCount($this->res) > 0) {
                $this->row = $this->modx->db->getRow($this->res);
                return $this->row['contentid'];
            }
        } elseif ($this->mode[0] == 'nonetv') {

            $this->res = $this->modx->db->query("SELECT id FROM " . $this->modx->getFullTableName('site_content') . " WHERE " . $this->mode[1] . "='" . $this->mode[2] . "'");
            if ($this->modx->db->getRecordCount($this->res) > 0) {
                $this->row = $this->modx->db->getRow($this->res);
                return $this->row['id'];
            }
        } else return 'Error, check your file!';

    }

    public function export()
    {
        $depth = $this->modx->db->escape($_POST['depth']);
        $parent = $this->modx->db->escape($_POST['stparent']);
        $filename = MODX_BASE_PATH .'assets/modules/editdocs/uploads/export.csv';
        $this->checkPrepareSnip();//проверяем, есть ли обработчик prepare (сниппет)
        if ($_POST['neopub']) $addw = 1; else $addw = '';

        if ($_POST['fieldz']) {

            if(!empty($_POST['filters'])) $filters = $_POST['filters']; else $filters ='';
            if(!empty($_POST['addwhere'])) $addwhere = $_POST['addwhere']; else $addwhere ='';

            if (!isset($_SESSION['export_total'])) {
                //только начинаем процесс
                $json = $this->modx->runSnippet('DocLister', array(
                'api' => 'id',
                'JSONformat' => 'new',
                'idType' => 'parents',
                'depth' => $depth,
                'parents' => $parent,
                'makeUrl' => 0,
                'showParent' => -1,
                'filters' => $filters,
                'addWhereList' => $addwhere,
                'showNoPublish' => $addw
                ));
                $total = json_decode($json, true)['total'];
                $_SESSION['export_total'] = $total;
                $_SESSION['export_start'] = 0;
                if (file_exists($filename)) {
                    unlink($filename);
                }
            }
            $file = fopen($filename, 'a+');

            $fields = $this->modx->db->escape($_POST['fieldz']);
            array_unshift($fields, 'id');
            $url = '';
            foreach ($fields as $key => $val) {
                //if($val=='url') $url = '[+url+];';
                $tvlist .= $val . ',';
                $ph .= '[+' . $val . '+];';
                $head .= $val . ';';
                $header[] = $val;
            }
            $tvlist = substr($tvlist, 0, strlen($tvlist) - 1);

            $ph = substr($ph, 0, strlen($ph) - 1);
            $head = substr($head, 0, strlen($head) - 1) . "\r\n";
            //$this->last = array_pop($fields);

            if(!empty($_POST['dm'])) $dm = $_POST['dm'];
            else $dm = ';'; //разделитель

            if($_SESSION['export_start']==0) { //header только в начале ставим
                fputcsv($file, $header, $dm);
            }



            $DL = $this->modx->runSnippet('DocLister', array(
                'api' => 1,
                'idType' => 'parents',
                'depth' => $depth,
                'parents' => $parent,
                'showParent' => -1,
                'id' => 'list',
                'display' => $this->step,
                'offset' => $_SESSION['export_start'],
                'tvPrefix' => '',
                'orderBy' => 'id ASC',
                'tvList' => $tvlist,
                'tpl' => '@CODE:' . $ph,
                'filters' => $filters,
                'addWhereList' => $addwhere,
                'prepare' =>  function($data) {
                    // foreach ($this->params['prevent_date'] as $v) {
                    //     $v = trim($v);
                    //     if (isset($data[$v])) {
                    //         $data[$v] = str_replace('.', ',', $data[$v]);
                    //     }
                    // }
                    if ($this->issetPrepare) {
                        $data = $this->makePrepare($data, 'upd', 'export',1);
                    }
                    $data['url'] = MODX_SITE_URL.$this->modx->makeUrl($data['id']);
                    $data['url'] = str_replace('//','/',$data['url']);
                    return $data;
                },
                'showNoPublish' => $addw,
                'urlScheme' => 'full'
            ));

            $DL = json_decode($DL, true);

            foreach ($DL as $string) {
                $import = array();

                foreach ($header as $k => $v) {
                    $import[] = ($_POST['win'] == 1) ? iconv('UTF-8', 'WINDOWS-1251', $string[$v]) : $string[$v];
                }
                //$this->modx->logEvent(1,1,print_r($header, true),'header');
                fputcsv($file, $import, $dm);
                $_SESSION['export_start'] ++;
            }
            fclose($file);

        }
        $out = $_SESSION['export_start'] . '|' . $_SESSION['export_total'];
        if ($_SESSION['export_start'] >= $_SESSION['export_total']) {
            unset($_SESSION['export_start']);
            unset($_SESSION['export_total']);
        }
        if(file_exists($filename)) return $out;
        else return 'Файла не существует!';

    }

    public function clearCache($type = 'full')
    {
        $this->modx->clearCache($type);
        foreach (glob(MODX_BASE_PATH . 'assets/modules/editdocs/uploads/*') as $file) {
            unlink($file);
        }
        unset($_SESSION['export_start']);
        unset($_SESSION['export_total']);
    }

    protected function checkArt($art){

        $this->art = $art;
        $this->res = $this->modx->db->query("SELECT contentid,value FROM " .$this->modx->getFullTableName('site_tmplvar_contentvalues')." WHERE  value = '".$this->art."'");
        $this->data = $this->modx->db->getRecordCount($this->res);
        return $this->data;

    }
    public function massMove()
    {
        $res = $this->modx->db->query("UPDATE " .$this->modx->getFullTableName('site_content')." SET parent = ".$_POST['parent2']." WHERE  parent = ".$_POST['parent1']."");

        if($res) {
            $this->modx->db->query("UPDATE " .$this->modx->getFullTableName('site_content')." SET isfolder = 1 WHERE  id = ".$_POST['parent2']."");
            $this->modx->db->query("UPDATE " .$this->modx->getFullTableName('site_content')." SET isfolder = 0 WHERE  id = ".$_POST['parent1']."");
            $out = '<div class="alert alert-success">Перенос успешно завершен! <b>(Не забывайте обновить кэш сайта для отображения изменений в дереве)</b></div>';
        }
        else $out = '<div class="alert alert-danger">Ошибка, проверьте ID родительских веток</div>';


        $this->clearCache();
        return $out;
    }

    public function makePrepare($data, $mode, $process, $doing)
    {
        $data = $this->modx->runSnippet($this->snipPrepare, array('data' => $data, 'mode' => $mode, 'process' => $process, 'doing'=>$doing));
        return $data;
    }

    public function checkPrepareSnip()
    {
        $this->issetPrepare = $this->modx->db->getValue("SELECT id FROM " . $this->modx->getFullTableName("site_snippets") . " WHERE `name`='" . $this->modx->db->escape($this->snipPrepare) . "' LIMIT 0,1") ? $this->modx->db->escape($this->snipPrepare) : false;
        return $this;
    }

    //проверяем есть ли у нас таблица для MultiCategories
    protected function checkTableMC() {
        global $table_prefix;
     $chmc = $this->modx->db->query("SHOW TABLES LIKE '".$table_prefix."site_content_categories' ");
     //$this->modx->logEvent(1,1, $table_prefix."site_content_categories",'таблица');
        if($this->modx->db->getRecordCount($chmc)>0 ) {
            $mc = true;
        }
        else $mc = false;
        return $mc;
    }
}
?>