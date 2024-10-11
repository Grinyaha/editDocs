<?php


class editDocs
{
    public $modx, $params, $doc, $step, $start_line, $snipPrepare, $check, $currArr, $currArr2, $addArr, $lang, $issetPrepare, $uni, $dn;

    //public $params;
    public function __construct($modx)
    {
        $this->modx = $modx;
        $this->params = $this->parseModuleParams('editDocs');

        require MODX_BASE_PATH . "assets/modules/editdocs/libs/vendor/autoload.php";

        $apiClassName = 'Pathologic\EvolutionCMS\MODxAPI\modResource';
        if (!class_exists($apiClassName)) {
            include_once(MODX_BASE_PATH . "assets/lib/MODxAPI/modResource.php");
            $apiClassName = 'modResource';
        }

        $this->doc = new $apiClassName($this->modx);
        $this->step = !empty($this->params['step']) && (int)$this->params['step'] > 0 ? (int)$this->params['step'] : 500;//сколько строк за раз импортируем
        $this->start_line = 2;//начинаем импорт со второй строки файла
        $this->snipPrepare = !empty($_POST['prep_snip']) ? $_POST['prep_snip'] : false;//сниппет prepare

        $this->check = $this->checkTableMC();
        $this->currArr = []; //массив с которым сравниваемся
        $this->currArr2 = []; //для разделов подразделов
        $this->addArr = []; //массив для новых добавляемых документов

        //language
        $lng = $modx->getConfig('manager_language');
        if (file_exists(MODX_BASE_PATH . 'assets/modules/editdocs/lang/' . $lng . '.inc.php')) require_once(MODX_BASE_PATH . 'assets/modules/editdocs/lang/' . $lng . '.inc.php');
        else require_once(MODX_BASE_PATH . 'assets/modules/editdocs/lang/russian-UTF8.inc.php');

        $_SESSION['ed_tv'] = $this->tvBase();

        $this->lang = $lang;

        if ($this->params['event_plugins'] == 'true') $this->params['event_plugins'] = true;
        else $this->params['event_plugins'] = false;

        //Снятие с публикации
        if (!empty($_POST['unpub']) && !isset($_POST['test'])) {
            $this->unpublished();
        }


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

        //$this->modx->logEvent(1,1,'<pre>'.print_r($_POST,1).'</pre>','mas');

        $this->doc->edit($id);
        $this->doc->set($pole, $data);
        $end = $this->doc->save($this->params['event_plugins'], false);

        if ($pole == 'category' && $data != '' && $data != 0) {
            $ctm = explode(',', $data);

            if (!empty($end)) {
                $que = $this->modx->db->query("DELETE FROM " . $this->modx->getFullTableName('site_content_categories') . " WHERE doc=" . $end);
            }
            foreach ($ctm as $valoc) {
                if (!empty($valoc) && !empty($end)) {
                    $que2 = $this->modx->db->query("INSERT INTO " . $this->modx->getFullTableName('site_content_categories') . " SET category=" . $valoc . ", doc=" . $end);
                }
            }
        }

        if ($end) {
            return 'Ресурс ' . $id . ' - отредактирован!';
        } else {
            return '<div class="alert alert-danger">ERROR!</div>';
        }

    }

    protected function tvBase()
    {

        $query = $this->modx->db->query('SELECT type,name,elements FROM ' . $this->modx->getFullTableName('site_tmplvars') . '  ');

        $fields = [];

        while ($row = $this->modx->db->getRow($query)) {

            $fields[$row['name']][0] = $row['type'];
            $fields[$row['name']][1] = $row['elements'];
        }

        return $fields;

    }


    public function getAllList()
    {

        $parent = $this->modx->db->escape($_POST['bigparent']);

        if (!empty($_POST['fields'])) {

            $fields = $this->modx->db->escape($_POST['fields']);
            $depth = $this->modx->db->escape($_POST['tree']);

            if (!empty($_POST['paginat'])) $disp = 40; else $disp = 0;
            if (!empty($_POST['neopub'])) $neopubl = 1; else $neopubl = '';


            $tvlist = '';
            $rowth = '';
            $rowtd = '';

            foreach ($fields as $val) {
                //$this->r .= '[+' . $val . '+] - ';
                $tvlist .= $val . ',';
                if (!empty($_POST['tvpic'])) $tvlist .= $_POST['tvpic'] . ',';
                $rowth .= '<td>' . $val . '</td>';


                $rowtd .= '[+' . $val . '+]';

            }

            //for multiCategories header
            if (isset($_POST['multed'])) $rowth .= '<td>category</td>';
            //for multiCategories
            if (isset($_POST['multed'])) $rowtd .= '<td><input name="category" class="tarea" type="text" value="[+category+]"></input></td>';


            $tvlist = substr($tvlist, 0, strlen($tvlist) - 1);
            $tab = '
<form id="dataf">
    <table class="tabres">
        <tr>
            <td width="100">id</td>' . $rowth . '
        </tr>
        ';
            $endtab = '</table></form><br/>';

            if ($_POST['filters'] != '') $filters = $_POST['filters']; else $filters = '';
            if ($_POST['addwhere'] != '') $addwhere = $_POST['addwhere']; else $addwhere = '';


            if ($_POST['order']) $orderBy = $_POST['order'] . ' ' . $_POST['orderas'];

            $out = $this->modx->runSnippet('DocLister', array(
                'idType' => 'parents',
                'depth' => $depth,
                'parents' => $parent,
                'showParent' => 1,
                'id' => 'list',
                'paginate' => 'pages',
                'pageLimit' => '1',
                'orderBy' => $orderBy,
                'pageAdjacents' => '5',
                'TplPage' => '@CODE:<span class="page" work="[+num+]">[+num+]</span>',
                'TplCurrentPage' => '@CODE:<b class="current" work="[+num+]">[+num+]</b>',
                'TplNextP' => '',
                'TplPrevP' => '',
                'TplDotsPage' => '@CODE:&nbsp;...&nbsp;',
                'display' => $disp,
                'tvPrefix' => '',
                'ownerTPL' => '@CODE: [+dl.wrap+][+list.pages+]',
                'TplWrapPaginate' => '@CODE: <tr><td colspan="100" align="center"><br/>[+wrap+]<br/></td></tr>',
                'tvList' => $tvlist,
                'filters' => $filters,
                'tpl' => '@CODE:  <tr class="ed-row"><td class="idd" idd="[+id+]">[+id+]<br>[+piczzz+]</td>' . $rowtd . '</tr>',
                'addWhereList' => $addwhere,
                'showNoPublish' => $neopubl,
                'prepare' => function ($data) {
                    //проверяем существование таблицы MultiCat и вкл. чекбокса
                    if (isset($_POST['multed'])) {
                        $que = $this->modx->db->query("SELECT category FROM " . $this->modx->getFullTableName('site_content_categories') . " WHERE doc=" . $data['id']);
                        if ($this->modx->db->getRecordCount($que) > 0) {

                            while ($rr = $this->modx->db->getRow($que)) {
                                $mcat[] = $rr['category'];
                            }
                            $rez = implode(',', $mcat);
                            if ($rez != '') $data['category'] = $rez;
                        } else $data['category'] = '';
                    }

                    //renderTV
                    foreach ($data as $k => $v) {

                        if ($k == 'id' || $k == 'category') {
                        } else {
                            if (isset($_SESSION['ed_tv'][$k]) && !empty($_POST['rendertv'])) {

                                //SELECT && RADIO && LISTBOX
                                if ($_SESSION['ed_tv'][$k][0] == 'dropdown' || $_SESSION['ed_tv'][$k][0] == 'option' || $_SESSION['ed_tv'][$k][0] == 'listbox') {

                                    $tmp = explode('||', $_SESSION['ed_tv'][$k][1]);

                                    $rs1 = '<select name="' . $k . '" class="tarea sumosel">';
                                    $rs2 = '</select>';
                                    $rs = '<option value=""></option>';

                                    foreach ($tmp as $kk => $vv) {
                                        if (strpos($vv, '==') !== false) {
                                            $sel = explode('==', $vv);
                                            if ($sel[1] == $v) $selected = 'selected="selected"'; else $selected = '';
                                            $rs .= '<option value="' . $sel[1] . '" ' . $selected . '>' . $sel[0] . '</option>';
                                        } else {
                                            if ($vv == $v) $selected = 'selected="selected"'; else $selected = '';
                                            $rs .= '<option value="' . $vv . '" ' . $selected . '>' . $vv . '</option>';
                                        }

                                    }

                                    $data[$k] = '<td>' . $rs1 . $rs . $rs2 . '</td>';
                                } //CHECKBOX && MULTI-SELECT
                                else if ($_SESSION['ed_tv'][$k][0] == 'checkbox' || $_SESSION['ed_tv'][$k][0] == 'listbox-multiple') {

                                    $tmp = explode('||', $_SESSION['ed_tv'][$k][1]);

                                    //смотрим что в значениях
                                    $curch = [];
                                    $expch = explode('||', $v);

                                    foreach ($expch as $vch) {
                                        $curch[] = $vch;
                                    }

                                    $rs1 = '<select name="' . $k . '" kk="' . $k . '" class="tarea sumochb" multiple>';
                                    $rs2 = '</select>';
                                    $rs = '';


                                    foreach ($tmp as $kk => $vv) {
                                        if (strpos($vv, '==') !== false) {
                                            $sel = explode('==', $vv);
                                            if (array_search($sel[1], $curch) !== false) $selected = 'selected="selected"'; else $selected = '';
                                            //$ch .= '<input type="checkbox" value="'.$sel[1].'" '.$selected.' name="'.$k.'">'.$sel[0].'<br>';
                                            $rs .= '<option value="' . $sel[1] . '" ' . $selected . '>' . $sel[0] . '</option>';
                                        } else {
                                            if (array_search($vv, $curch) !== false) $selected = 'selected="selected"'; else $selected = '';
                                            $rs .= '<option value="' . $vv . '" ' . $selected . '>' . $vv . '</option>';
                                        }

                                    }

                                    $data[$k] = '<td>' . $rs1 . $rs . $rs2 . '</td>';
                                } else {

                                    if ($k != $_POST['tvpic']) {
                                        $data[$k] = '<td><textarea name="' . $k . '" class="tarea">' . $v . '</textarea></td>';
                                    } else $data[$k] = $v;
                                }


                            } else {
                                if ($k != $_POST['tvpic']) {
                                    $data[$k] = '<td><textarea name="' . $k . '" class="tarea">' . $v . '</textarea></td>';
                                } else $data[$k] = $v;
                            }
                        }
                    }

                    //show IMG
                    if (!empty($_POST['tvpic'])) {
                        $tvpic = $_POST['tvpic'];
                        $slash = '/';
                        if (substr($data[$tvpic], 0, 1) == '/') $slash = '';
                        if (substr($data[$tvpic], 0, 4) == 'http') $slash = '';

                        //$this->modx->logEvent(1,1,'<code>'.$data[$tvpic].'</code>','tv pic');
                        if (!empty($data[$tvpic])) $data['piczzz'] = '<img src="' . $slash . $data[$tvpic] . '" width="100"/>';
                        else $data['piczzz'] = '';

                    } else $data['piczzz'] = '';


                    return $data;
                }

            ));

            //$this->paginate = $this->modx->getPlacholder('list.pages');

            return $tab . $out . $endtab;

        } else return '<div class="alert alert-danger">' . $this->lang['error_empty_fields'] . '</div>';
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

            $reader = new \PhpOffice\PhpSpreadsheet\Reader\Csv();
            $reader->setDelimiter(';');

            $handle = file_get_contents($output_dir . $fileName);

            //$this->modx->logEvent(1,1,$handle,'Заголовок лога');

            if ($handle) {
                $c[] = 'UTF-8';
                $c[] = 'Windows-1251';

                $coding = mb_detect_encoding($handle, $c, true);
            } else $coding = '';

            if ($coding != 'UTF-8') $reader->setInputEncoding('CP1251');

            $spreadsheet = $reader->load($output_dir . $fileName);


        } else {
            //$spreadsheet = new Spreadsheet();
            $spreadsheet = \PhpOffice\PhpSpreadsheet\IOFactory::load($output_dir . $fileName);
        }


        $worksheet = $spreadsheet->getActiveSheet();
        $sheetData = $worksheet->toArray(null, true, true, true);

        //}

        //заменяем . на , в category
        $keyz = array_keys($sheetData);
        $firstKey = $keyz[0];
        $findcat = array_search('category', $sheetData[$firstKey]);

        if (!empty($findcat)) {
            foreach ($sheetData as $keysh => $valsh) {
                $sheetData[$keysh][$findcat] = str_replace('.', ',', $sheetData[$keysh][$findcat]);
            }
        }


        $_SESSION['data'] = $this->clearEmptyRows($sheetData);
        $_SESSION['import_start'] = $this->start_line;
        $_SESSION['import_total'] = count($_SESSION['data']) + $_SESSION['import_start'] - 1;
        $_SESSION['import_i'] = $_SESSION['import_j'] = 0;
        $_SESSION['tabrows'] = '';

        $data_table = $this->table($this->clearEmptyRows($sheetData), $this->params['max_rows']);

        $columns = '';
        if (isset($this->params['columns'])) {
            $columns = '#@' . $this->params['columns'];
        }


        echo $_SESSION['import_start'] . '#@' . $this->lang['totalrows'] . ' - ' . ($_SESSION['import_total'] - $this->start_line) . '#@' . $data_table . '#@' . implode('||', $_SESSION['header_table']) . $columns;


    }

    protected function clearEmptyRows($data)
    {

        foreach ($data as $index => $datum) {
            $i = 0;
            foreach ($datum as $kk => $vaa) {
                if (!empty($vaa)) $i++;
            }
            if ($i == 0) {
                unset($data[$index]);
            }
        }
        return $data;
    }

    public function importExcel()
    {

        // if (!$_POST['parimp'] || $_POST['parimp']=='') {
        //     return '<div class="alert alert-danger ">Введите ID родителя!</div>' . $this->table($_SESSION['data'], $this->params['max_rows']);
        // }
        $this->uni = isset($_POST['checktv']) && $_POST['checktv'] != '0' ? $_POST['checktv'] : 'id';
        if (isset($_POST['checktv2']) && $_POST['checktv2'] != '') $this->uni2 = $_POST['checktv2'];

        if ($_SESSION['data']) {
            return $this->importReady($this->newMassif($_SESSION['data'])); //$this->table($_SESSION['data'], $this->params['max_rows'])
        } else return '<div class="alert alert-danger">' . $this->lang['sessdead'] . '</div>';
    }


    protected function importReady($data)
    {

        $uniq = $this->uni;

        $check = $this->checkField($uniq);
        $i = 0;//количество добавленных
        $j = 0;//количество отредактированных
        $start = isset($_SESSION['import_start']) ? $_SESSION['import_start'] : 0;
        $finish = isset($_SESSION['import_start']) ? ($start + $this->step) : count($data);


        /*echo '<pre>';
        print_r($_SESSION['header_table']);
        echo '</pre>';*/

        $this->checkPrepareSnip();//проверяем, есть ли обработчик prepare (сниппет)
        $ptmplh = '';
        $parh = '';
        $parc = '';

        //$this->modx->logEvent(1,1,'<pre>'.print_r($_SESSION['header_table'],1).'</pre>','TEST!!!');

        if ($_SESSION['header_table']) {
            $theader = '';

            //переделываем шапку таблицы для MultiTV
            $_SESSION['header_table'] = $this->reHeader($_SESSION['header_table']);

            foreach ($_SESSION['header_table'] as $valt) {

                if (!empty($this->uni2) && $valt == $this->uni2) $valt = $this->uni; //меняем заголовок в рендерной таблице по полю по которому сравниваемся

                $theader .= '<td>' . $valt . '</td>';
            }

            if (array_search('parent', $_SESSION['header_table']) === false) {
                if ($_POST['parimp']) $parh = '<td>parent</td>';
            }

            if (array_search('template', $_SESSION['header_table']) === false) {
                if ($_POST['tpl'] != 'file') $ptmplh = '<td>template</td>';
            }

            //категории разделы
            if (array_search('ed_category1', $_SESSION['header_table']) && $parc == '') {
                $parc = '<td>parent</td>';
            }

            if (!empty($_POST['unpub']) || !empty($_POST['unpub2'])) $unphd = '<td>published</td>';
            else $unphd = '';


        }


        $tabh = '<table  class="tabres"><tr>' . $theader . $parh . $ptmplh . $parc . $unphd . '</tr>';
        $tabe = '</table>';

        $tr = '';

        //HERE
        $this->allArr($check, $uniq, $theader);

        for ($ii = $start; $ii < $finish; $ii++) {
            if (!isset($data[$ii])) continue;
            $val = $data[$ii];

            $inbase = 0;

            if (isset($val[$uniq])) {
                $check[2] = $val[$uniq];

                $checkf['xls_srav'] = $check[2];
                if ($this->issetPrepare) {
                    $checkf = $this->makePrepare($checkf, 'srav', 'srav', 1, $ii - 1); // 1 - game mode
                }

                //$this->modx->logEvent(1,1,'<pre>'.print_r($checkf, true).'</pre>','Заголовок лога!');
                $inbase = array_search($checkf['xls_srav'], $this->currArr); //Сверяемся со значением выбранного поля и данными в базе.
            }
            foreach ($val as $key => $value) {
                $create[$key] = $value;
            }

            //если parent нет в массиве, смотрим в POST,
            if (!isset($create['parent'])) {
                if (!empty($_POST['parimp'])) $create['parent'] = $this->modx->db->escape($_POST['parimp']);
            }

            if ($_POST['tpl']) $tpl = $this->modx->db->escape($_POST['tpl']);
            if ($tpl != 'file') $create['template'] = $tpl;
            if ($tpl == 'blank') $create['template'] = 0;

            //если включено снятие с публикации то принудительно публикуем добавляемые
            if (!empty($_POST['unpub']) || !empty($_POST['unpub2'])) $create['published'] = 1;


            //проверка на ноль
            foreach ($create as $kv => $vally) {
                if ($vally == '') $create[$kv] = '';
                if ($vally == '0' && empty($vally)) $create[$kv] = '0'; //если у значения есть ноль

            }
            //разделы и подразделы
            $create = $this->treeCategories($create, $_POST['test']);

            //режим (добавление)
            if (!$inbase) {  //не существует в базе

                if (!isset($_POST['test']) && empty($_POST['notadd'])) {


                    //prepare create
                    if ($this->issetPrepare) {
                        $create = $this->makePrepare($create, 'new', 'import', 1, $ii - 1); // 1 - game mode
                    }

                    //search & replace
                    $create = $this->smallPrepare($create);

                    //MultiTv
                    $create = $this->multiTv($create);

                    $this->doc->create($create);
                    $new = $this->doc->save($this->params['event_plugins'], false); //SAVE!!!

                    //защита от дублей с одинаковыми названиями в загружаемой таблице
                    /*$inbase2 = 0;
                    if (count($this->addArr)>0) {
                        $inbase2 = array_search($create['pagetitle'], $this->addArr);
                    }

                    if(empty($inbase2)) {
                        $new = $this->doc->save(true, false); //SAVE!!!
                    }

                    //add to addArr
                    if ($new > 0 && count($create) > 0) {
                        $this->addArr[$new] = $create['pagetitle'];
                        //$this->modx->logEvent(1,1,print_r($this->currArr, true),'Заголовок лога zzz!');
                    }*/


                    if (array_key_exists('category', $create) && isset($_POST['multi']) && $new > 0) {
                        if (!empty($create['category'])) {
                            $create['category'] = trim($create['category']);
                        }
                        $arrmc = explode(',', $create['category']);

                        foreach ($arrmc as $vl) {
                            if (!empty($vl) && !empty($new)) {
                                $que = $this->modx->db->query("INSERT INTO " . $this->modx->getFullTableName('site_content_categories') . " SET category=" . $vl . ",doc=" . $new);
                            }
                        }
                    }
                } //тестовый режим (добавление)
                else {
                    if ($this->issetPrepare) {
                        $create = $this->makePrepare($create, 'new', 'import', 0, $ii - 1); // 0 - test mode
                    }

                    //search & replace
                    $create = $this->smallPrepare($create);

                    //MultiTv
                    $create = $this->multiTv($create);

                }

                if (!empty($_POST['notadd'])) {
                    $css = 'td_notadd';
                } else $css = '';

                $td = '';
                foreach ($create as $key => $val) {

                    $td .= '<td class="td_add ' . $css . '">' . $val . ' </td>'; //add
                }
                $tr .= '<tr>' . $td . '</tr> ';
                //$_SESSION['log'] .= '<hr>';
                $i++;


            } else if ($inbase > 0) { //существует в базе
                if (!isset($_POST['test'])) {

                    //prepare
                    if ($this->issetPrepare) {
                        $create = $this->makePrepare($create, 'upd', 'import', 1, $ii - 1); // 1 - game mode
                    }

                    //search & replace
                    $create = $this->smallPrepare($create);

                    //MultiTv
                    $create = $this->multiTv($create);

                    //EDIT
                    $edit = $this->doc->edit($inbase)->fromArray($create)->save($this->params['event_plugins'], false);


                    //если вкл.мультикатегории
                    if (array_key_exists('category', $create) && isset($_POST['multi'])) {

                        $ctm = explode(',', $create['category']);

                        if (!empty($edit) && !empty($_POST['multi_reset'])) {
                            $que = $this->modx->db->query("DELETE FROM " . $this->modx->getFullTableName('site_content_categories') . " WHERE doc=" . $edit);
                        }

                        foreach ($ctm as $valoc) {
                            if (!empty($valoc) && !empty($edit)) {
                                $que2 = $this->modx->db->query("INSERT INTO " . $this->modx->getFullTableName('site_content_categories') . " SET category=" . $valoc . ", doc=" . $edit);
                            }
                        }
                        //$que = $this->modx->db->query("UPDATE ".$this->modx->getFullTableName('site_content_categories')." SET category=".$create['category']." WHERE doc=".$edit);

                    }
                    $testInfo = '';
                } //тестовый режим (обновление)
                else {
                    if ($this->issetPrepare) {
                        $create = $this->makePrepare($create, 'upd', 'import', 0, $ii - 1); // 0 - game mode
                    }
                    //search & replace
                    $create = $this->smallPrepare($create);

                    //MultiTv
                    $create = $this->multiTv($create);
                }


                $td = '';
                foreach ($create as $key => $val) {
                    //$_SESSION['log'] .= $key . ' - ' . $val . ' - <b class="upd-text">обновление</b> '.$testInfo.'<br>';
                    $td .= '<td class="td_upd">' . $val . ' </td>'; //edit
                }
                $tr .= '<tr>' . $td . '</tr> ';
                //$_SESSION['log'] .= '<hr>';
                $j++;
            }


        }

        //$this->modx->logEvent(1,1,'<pre>'.print_r($_SESSION, true).'</pre>','Заголовок лога!3');

        $_SESSION['tabrows'] .= $tr;
        //$fulltab = $tabh.$tr.$tabe;
        $fortab = '<span class="td_add">&nbsp;</span>  ' . $this->lang['added'] . ' &nbsp;&nbsp;&nbsp; <span class="td_notadd">&nbsp;</span> ' . $this->lang['stopadd'] . '&nbsp;&nbsp;&nbsp; <span class="td_upd">&nbsp;</span> ' . $this->lang['edited'] . '<br><br>';

        $_SESSION['import_i'] += $i;
        $_SESSION['import_j'] += $j;
        $_SESSION['import_start'] = $start + $i + $j;

        //тестовый режим
        if (isset($_POST['test'])) {
            //$this->modx->logEvent(1,1,$_SESSION['import_start'],'проверка заголовка таблицы '.$_SESSION['import_start']);
            $_SESSION['log'] = '<br><div class="alert alert-danger">' . $this->lang['nowtest'] . '</div>';

            return ($_SESSION['import_start'] - $this->start_line) . '#@' . ($_SESSION['import_total'] - $this->start_line) . '#@' . $_SESSION['log'] . $fortab . $tabh . $_SESSION['tabrows'] . $tabe;
        }

        //боевой режим
        if (!isset($_POST['test'])) {
            $_SESSION['log'] = '<br><b>' . $this->lang['added'] . ' - ' . $_SESSION['import_i'] . ', ' . $this->lang['edited'] . ' - ' . $_SESSION['import_j'] . '</b> <hr>';
            //$fileobr = '<div class="alert alert-warning">Файл обработан. Для дальнейшей работы необходимо загрузить файл заново.</div>';

        }


        return ($_SESSION['import_start'] - $this->start_line) . '#@' . ($_SESSION['import_total'] - $this->start_line) . '#@' . $_SESSION['log'] . $fortab . $tabh . $_SESSION['tabrows'] . $tabe;
        // #@ разделители для JS
    }

    protected function newMassif($data)
    {


        $j = 0;
        $newkeys = [];
        $sheetDataNew = array();

        foreach ($data[1] as $zna) {
            $newkeys[$j] = $zna;
            $j++;
        }

        foreach ($data as $k => $val) {
            if ($k > 1) {
                $i = 0;
                foreach ($val as $key => $value) {
                    $z = $newkeys[$i];

                    if (!empty($this->uni2) && $z == $this->uni2) $z = $this->uni;
                    if (!empty($z)) $z = trim($z);
                    $this->dn[$z] = $value;

                    $i++;
                }

                $sheetDataNew[trim($k)] = $this->dn;
            }
        }

        unset ($data);
        return $sheetDataNew;
    }

    protected function table($data, $max)
    {
        //$this->modx->logEvent(1,1,'_max'.$max,'header');
        $header = '<table class="tabres">';
        $footer = '</table>';
        $out = '';
        $i = 0;

        $_SESSION['header_table'] = array();
        foreach ($data as $k => $val) {
            $row = '';
            $limit_msg = '';
            $i++;
            if ($max && (int)$max + 1 < $i) {
                $limit_msg = '<br><div style="color: red">' . $this->lang['limit_msg'] . '</div>';
                break;
            }

            foreach ($val as $key => $value) {
                if (!empty($value)) $value = trim($value);
                if ($i == 1) $_SESSION['header_table'][] = $value; //заголовок таблицы
                $row .= '<td>' . $value . '</td>';
            }

            $out .= '<tr>' . $row . '</tr>';

        }
        return $header . $out . $footer . $limit_msg;
    }

    protected function checkField($field)
    {

        $param = array();
        $res = $this->modx->db->query("SELECT name FROM " . $this->modx->getFullTableName('site_tmplvars'));
        $temp = 0;
        while ($row = $this->modx->db->getRow($res)) {
            if ($row['name'] == $field) {
                $temp = 1;
                $param[0] = 'tv';
                $param[1] = $field;
            }
        }
        if ($temp == 0) {
            $res = $this->modx->db->query("SHOW columns FROM " . $this->modx->getFullTableName('site_content') . " where Field = '" . $field . "'");
            if ($this->modx->db->getRecordCount($res) > 0) {
                $param[0] = 'nonetv';
                $param[1] = $field;
            } else {
                $param[0] = 'notfound';
                $param[1] = $field;
            }
        }
        return $param;

    }

    protected function allArr($check, $name, $theader)
    {
        //для категории/разделы, проверяем нужно ли делать запрос на предмет всего массива документов
        $theader = strip_tags($theader);
        if (strpos($theader, 'ed_category1') !== false) {
            $que = $this->modx->db->query("SELECT pagetitle,id,parent FROM " . $this->modx->getFullTableName('site_content'));
            while ($ro = $this->modx->db->getRow($que)) {
                //собираем массив со всеми значениями поля по которому сравниваемся
                $this->currArr2[$ro['pagetitle']]['id'] = $ro['id'];
                $this->currArr2[$ro['pagetitle']]['parent'] = $ro['parent'];
            }
        }


        if ($check[0] == 'tv') {

            $tvquery = $this->modx->db->query("SELECT id FROM " . $this->modx->getFullTableName('site_tmplvars') . " WHERE name='" . $name . "'");
            $tvid = $this->modx->db->getRow($tvquery);

            $res = $this->modx->db->query("SELECT contentid,value FROM " . $this->modx->getFullTableName('site_tmplvar_contentvalues') . " WHERE tmplvarid='" . $tvid['id'] . "'");
            while ($row = $this->modx->db->getRow($res)) {
                //собираем массив со всеми значениями ТВ по которому сравниваемся

                $checkf['db_srav'] = $row['value'];
                if ($this->issetPrepare) {
                    $checkf = $this->makePrepare($checkf, 'srav', 'srav', 1, 0);
                }

                //собираем массив со всеми значениями поля по которому сравниваемся
                $this->currArr[$row['contentid']] = $checkf['db_srav'];
            }


        } elseif ($check[0] == 'nonetv') {

            $res = $this->modx->db->query("SELECT " . $check[1] . ",id FROM " . $this->modx->getFullTableName('site_content'));
            while ($row = $this->modx->db->getRow($res)) {
                //собираем массив со всеми значениями поля по которому сравниваемся
                $this->currArr[$row['id']] = $row[$check[1]];

            }
        } else return 'Error, check your file!';

        //print_r($this->currArr);
        return $this;
    }


    public function export()
    {

        $depth = $this->modx->db->escape($_POST['depth']);
        $parent = $this->modx->db->escape($_POST['stparent']);
        $filename = MODX_BASE_PATH . 'assets/modules/editdocs/uploads/export.csv';
        $filename_temp = MODX_BASE_PATH . 'assets/modules/editdocs/uploads/export_temp.csv';

        $this->checkPrepareSnip();//проверяем, есть ли обработчик prepare (сниппет)
        if (!empty($_POST['neopub'])) $neopubl = 1; else $neopubl = '';


        if (!empty($_POST['fieldz'])) {

            if (!empty($_POST['filters'])) $filters = $_POST['filters']; else $filters = '';
            if (!empty($_POST['addwhere'])) $addwhere = $_POST['addwhere']; else $addwhere = '';

            if (!isset($_SESSION['export_total'])) {

                //только начинаем процесс
                $json = $this->modx->runSnippet('DocLister', array(
                    'returnDLObject' => 1,
                    'idType' => 'parents',
                    'selectFields' => 'id',
                    'depth' => $depth,
                    'parents' => $parent,
                    'makeUrl' => 0,
                    'showParent' => -1,
                    'filters' => $filters,
                    'addWhereList' => $addwhere,
                    'showNoPublish' => $neopubl
                ));


                $total = $json->getChildrenCount();

                $_SESSION['export_total'] = $total;
                $_SESSION['export_start'] = 0;

                if (file_exists($filename)) {
                    unlink($filename);
                }
                if (file_exists($filename_temp)) {
                    unlink($filename_temp);
                }
            }
            $file = fopen($filename, 'a+');
            $file_temp = fopen($filename_temp, 'a+');

            $fields = $this->modx->db->escape($_POST['fieldz']);
            //$fields_custom = explode(';', $this->modx->db->escape($_POST['fieldz_custom']));
            //$fields = array_merge($fields, $fields_custom);

            array_unshift($fields, 'id');

            $url = '';
            $tvlist = '';
            $ph = '';
            $head = '';
            $header = [];

            foreach ($fields as $key => $val) {
                //if($val=='url') $url = '[+url+];';
                $tvlist .= $val . ',';
                $ph .= '[+' . $val . '+];';
                $head .= $val . ';';
                if (!empty($val)) $header[] = $val;

            }
            $tvlist = substr($tvlist, 0, strlen($tvlist) - 1);
            $ph = substr($ph, 0, strlen($ph) - 1);
            $head = substr($head, 0, strlen($head) - 1) . "\r\n";

            if (!empty($_POST['export_mc'])) $header[] = 'category'; //Добавляем в заголовок category от MultiCategories

            if (!empty($_POST['dm'])) $dm = $_POST['dm'];
            else $dm = ';'; //разделитель

            if ($_SESSION['export_start'] == 0) { //header только в начале ставим
                fputcsv($file, $header, $dm);
                fputcsv($file_temp, $header, $dm);
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
                'prepare' => function ($data) {
                    // foreach ($this->params['prevent_date'] as $v) {
                    //     $v = trim($v);
                    //     if (isset($data[$v])) {
                    //         $data[$v] = str_replace('.', ',', $data[$v]);
                    //     }
                    // }
                    if (!empty($_POST['export_mc'])) $data['category'] = $this->multicat($data['id']);


                    if ($this->issetPrepare) {
                        $data = $this->makePrepare($data, 'upd', 'export', 1, 0);
                    }
                    $data['url'] = MODX_SITE_URL . $this->modx->makeUrl($data['id']);
                    $data['url'] = str_replace('//', '/', $data['url']);
                    return $data;
                },
                'showNoPublish' => $neopubl,
                'urlScheme' => 'full'
            ));

            $DL = json_decode($DL, true);

            foreach ($DL as $string) {
                $import = array();
                $import_tmp = array();

                foreach ($header as $v) {
                    if (!empty($v)) {
                        $import[] = (isset($_POST['win']) && $_POST['win'] == 1) ? mb_convert_encoding($string[$v], 'WINDOWS-1251') : $string[$v];
                        $import_tmp[] = $string[$v];
                    }
                }
                //$this->modx->logEvent(1,1,print_r($header, true),'header');
                fputcsv($file, $import, $dm);
                fputcsv($file_temp, $import_tmp, $dm);
                $_SESSION['export_start']++;
            }
            fclose($file);
            fclose($file_temp);


            $out = $_SESSION['export_start'] . '|' . $_SESSION['export_total'];
            if ($_SESSION['export_start'] >= $_SESSION['export_total']) {
                unset($_SESSION['export_start']);
                unset($_SESSION['export_total']);

                ///convert to XLS
                $reader = new \PhpOffice\PhpSpreadsheet\Reader\Csv();
                $reader->setDelimiter(';');

                $csvFile = $reader->load($filename_temp);
                $writer = \PhpOffice\PhpSpreadsheet\IOFactory::createWriter($csvFile, "Xlsx");
                $writer->save(MODX_BASE_PATH . 'assets/modules/editdocs/uploads/export.xlsx');
            }
            //if (file_exists($filename)) return $out;
            return $out;
            //else return 'Файла не существует!';
        } else return ('<div class="alert alert-danger">' . $this->lang['error_empty_fields'] . '</div>|0');

    }

    public function clearCache($type = 'full')
    {
        if (!empty($_SESSION['data'])) unset($_SESSION['data']);
        $this->modx->clearCache($type);
        foreach (glob(MODX_BASE_PATH . 'assets/modules/editdocs/uploads/*') as $file) {
            unlink($file);
        }
        unset($_SESSION['export_start']);
        unset($_SESSION['export_total']);
    }


    public function massMove()
    {
        $res = $this->modx->db->query("UPDATE " . $this->modx->getFullTableName('site_content') . " SET parent = " . $_POST['parent2'] . " WHERE  parent = " . $_POST['parent1'] . "");

        if ($res) {
            $this->modx->db->query("UPDATE " . $this->modx->getFullTableName('site_content') . " SET isfolder = 1 WHERE  id = " . $_POST['parent2'] . "");
            $this->modx->db->query("UPDATE " . $this->modx->getFullTableName('site_content') . " SET isfolder = 0 WHERE  id = " . $_POST['parent1'] . "");
            $out = '<div class="alert alert-success">' . $this->lang['ok_move'] . '</b></div>';
        } else $out = '<div class="alert alert-danger">' . $this->lang['error_tree'] . '</div>';


        $this->clearCache();
        return $out;
    }

    public function makePrepare($data, $mode, $process, $doing, $iteration)
    {
        $data = $this->modx->runSnippet($this->snipPrepare, array('data' => $data, 'mode' => $mode, 'process' => $process, 'doing' => $doing, 'iteration' => $iteration));
        return $data;
    }

    public function checkPrepareSnip()
    {
        if (empty($_POST['prep_snip']) || $_POST['prep_snip'] == 'none') $this->issetPrepare = false;
        else {
            $this->issetPrepare = $this->modx->db->getValue("SELECT id FROM " . $this->modx->getFullTableName("site_snippets") . " WHERE `name`='" . $_POST['prep_snip'] . "' AND disabled = 0 LIMIT 0,1") ? $this->modx->db->escape($_POST['prep_snip']) : false;
        }
        return $this;
    }

    //проверяем есть ли у нас таблица для MultiCategories
    protected function checkTableMC()
    {

        $sql = '
        CREATE TABLE IF NOT EXISTS ' . $this->modx->getFullTableName('site_content_categories') . ' (
        `doc` int(10) NOT NULL,
        `category` int(10) NOT NULL,
        UNIQUE KEY `link` (`doc`,`category`) USING BTREE,
        KEY `doc` (`doc`),
        KEY `category` (`category`)
        ) ENGINE=MyISAM;';

        return $this->modx->db->query($sql);

    }

    protected function multicat($id)
    {

        $query = $this->modx->db->query("SELECT category FROM " . $this->modx->getFullTableName('site_content_categories') . " WHERE doc=" . $id);
        $out = [];
        while ($row = $this->modx->db->getRow($query)) {
            if (!empty($row['category'])) $out[] = $row['category'];
        }

        $outx = implode(',', $out);
        return $outx;
    }

    protected function smallPrepare($data)
    {

        //search & replace
        if (!empty($_POST['replace']) && !empty($_POST['needle'])) {
            $data[$_POST['replace']] = str_replace($_POST['needle'], $_POST['replacement'], $data[$_POST['replace']]);
        }

        return $data;
    }

    protected function multiTv($data)
    {

        $arr = []; //массив строки из экселя
        $retv = '';
        foreach ($data as $key => $val) {

            if (strpos($key, ':') !== false) {

                $exp = explode(':', $key);
                $retv = $exp[0];
                $arr[$exp[2]][$exp[1]] = $val;
                unset($data[$key]);

            }
        }

        if ($retv != '') {
            //получаем массив из настроек MultiTV
            include(MODX_BASE_PATH . 'assets/tvs/multitv/configs/' . $retv . '.config.inc.php');

            foreach ($arr as $kj => $vj) { //массив multiTV из экселя
                foreach ($vj as $index => $item) { //массив одной строки для MultiTV
                    foreach ((array)$settings['fields'] as $ko => $vo) { //массив из конфига MultiTV

                        if ($vo['caption'] == $index) {
                            //echo $ko;
                            $arr[$kj][$ko] = $item;
                            if ($vo['type'] == 'image') $arr[$kj]['thumb'] = $arr[$kj][$ko];
                            if ($index != $ko) unset($arr[$kj][$vo['caption']]);

                        }

                    }
                }
            }
            //echo '<pre>';
            //print_r($arr);
            //print_r($vj);
            //print_r($settings['fields']);
            //echo '</pre>';

            $newarr['fieldValue'] = $arr;
            $data[$retv] = json_encode($newarr, JSON_UNESCAPED_UNICODE);
        }

        return $data;
    }

    protected function reHeader($data)
    {

        $retv = '';
        foreach ($data as $key => $val) {

            if (!empty($val) && strpos($val, (string)':') !== false) {

                $exp = explode(':', $val);
                $retv = $exp[0];
                unset($data[$key]);

            }
        }
        if ($retv != '') $data[] = $retv;

        /*echo '<pre>';
       print_r($data);
       echo '</pre>';*/
        return $data;
    }


    public function unpublished()
    {
        $this->modx->db->query('UPDATE ' . $this->modx->getFullTableName("site_content") . ' SET published=0 WHERE template IN(' . $_POST['unpub'] . ') ');
    }

    public function saveConfig($params)
    {

        $data = "<?php //" . $params['save_config'] . " \r\n  return " . var_export($params, true) . " ?>";
        $newname = $this->modx->stripAlias($params['save_config']);
        //$newname = htmlspecialchars($newname);
        //$newname = preg_replace($pattern, $replacement, $newname);
        file_put_contents(MODX_BASE_PATH . "assets/modules/editdocs/config/" . $params['folder'] . "/" . $newname . ".php", $data);

        return json_encode($params, JSON_UNESCAPED_UNICODE);
    }

    public function loadListFiles($folder)
    {
        /*$files = scandir(MODX_BASE_PATH . "assets/modules/editdocs/config/".$floder);
        foreach ($files as $key=>$val) {
            if($val=='.' || $val=='..') unset($files[$key]);
            $files[$key] = str_replace('.php', '', $files[$key]);
        }
        sort($files);*/
        $arr = [];
        $i = 0;
        foreach (glob(MODX_BASE_PATH . "assets/modules/editdocs/config/" . $folder . "/*.php") as $filename) {
            $line = fgets(fopen($filename, 'r'));
            $arr[$i]['title'] = str_replace('<?php //', '', $line);
            $arr[$i]['title'] = str_replace(" \r\n", '', $arr[$i]['title']);
            $arr[$i]['filename'] = str_replace(MODX_BASE_PATH . "assets/modules/editdocs/config/" . $folder . "/", "", $filename);

            $i++;
        }
        sort($arr);
        return json_encode($arr, JSON_UNESCAPED_UNICODE);
    }

    public function loadCfgFile($name)
    {
        $arr = include_once(MODX_BASE_PATH . "assets/modules/editdocs/config/" . $name);
        return json_encode($arr, JSON_UNESCAPED_UNICODE);
    }

    protected function treeCategories($datas, $test)
    {
        //проверка есть ли ed_category
        $l=0;
        foreach ($datas as $kkk => $vvv) {
            if(strpos($kkk, 'ed_category')!==false) $l++;
        }
        if($l==0) return $datas;

        //$this->modx->logEvent(1,1,'<pre>'.print_r($datas, true).'</pre>','Заголовок лога 3');

        if($test) return $datas; //если тестовый режим то ничего не делаем!

        if (is_array($datas)) {
            $i = 0;
            $data = [];
            $tpl = [];
            //подсчитывает сколько у нас ed_category
            foreach ($datas as $k => $v) {
                if (strpos($k, 'ed_category') !== false) {
                    $i++;
                    $data['ed_category'.$i] = $v;
                    $tmp = explode('#', $k);
                    $tpl[$i] = $tmp[1];
                }
                else $data[$k] = $v;
                //создаем новый массив где нет # в столбцах
            }

            //перебираем все категории и вычисляем конечный parent нужного раздела

            for ($x = 1; $x <= $i; $x++) {
                //ниже пиздец там цикл, я там сам ничего не понял, но главное работает
                //первая итерация
                if ($x == 1) {
                    //если существует 1-й уровень в каталоге
                    if(isset($this->currArr2[$data['ed_category' . $x]]['id'])) {
                        $id = $this->currArr2[$data['ed_category' . $x]]['id'];
                        $prnt = $id;
                    }
                    else {
                        //если нет то создаем его
                        $this->doc->create(array(
                            'pagetitle' => $data['ed_category' . $x],
                            'template' => $tpl[$x],
                            'parent' => $_POST['parimp']
                        ));
                        $id = $this->doc->save($this->params['event_plugins'], false);

                        $prnt = $id;
                        $this->currArr2[$data['ed_category' . $x]]['id'] = $id;
                        $this->currArr2[$data['ed_category' . $x]]['parent'] = $_POST['parimp'];
                    }
                //последующие итерации ed_category
                } else {
                    if(isset($this->currArr2[$data['ed_category' . $x]]['id']) && $this->currArr2[$data['ed_category' . $x]]['parent']==$prnt) {

                        if ($this->currArr2[$data['ed_category' . $x]]['parent'] == $id) {
                            if ($data['ed_category' . $x]!="") {
                                $id = $this->currArr2[$data['ed_category' . $x]]['id'];
                            } else {
                                $id = $this->currArr2[$data['ed_category' . $x]]['parent'];
                            }
                            $prnt = $id;
                        }
                    }
                    else {

                        if($data['ed_category' . $x]!="") {
                            $this->doc->create(array(
                                'pagetitle' => $data['ed_category' . $x],
                                'template' => $tpl[$x],
                                'parent' => $prnt
                            ));
                            $id = $this->doc->save($this->params['event_plugins'], false);

                            $this->currArr2[$data['ed_category' . $x]]['id'] = $id;
                            $this->currArr2[$data['ed_category' . $x]]['parent'] = $prnt;
                            $prnt = $id;
                        }
                        else $prnt = $id;

                    }
                }

            } //end for



            if ($prnt > 0) {
                $datas['parent'] = $prnt;
            }
        }
       return $datas;
    }
}


?>
