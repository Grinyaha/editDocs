<?php

class editDocs
{
	protected $modx = null;
	protected $doc = null;

	public function __construct(DocumentParser $modx)
	{
		$this->modx = $modx;
		$this->doc = new modResource($this->modx);
	}

	public function editDoc()
	{
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

	public function getAllList()
	{
	    $this->parent = $this->modx->db->escape($_POST['bigparent']);

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

	        return $this->tab . $this->out . $this->endtab ;
	    }
	    else return 'Выберите поля/TV для редактирования!';
	}

	public function uploadFile() 
	{
	    $this->output_dir = dirname(__DIR__) . '/uploads/';
	    $this->ret = array();

	    $this->error =$_FILES["myfile"]["error"];

	    if(!is_array($_FILES["myfile"]["name"]))
	    {
	        $this->fileName = $_FILES["myfile"]["name"];
	        move_uploaded_file($_FILES["myfile"]["tmp_name"],$this->output_dir.$this->fileName);
	        $this->ret[]= $this->fileName;
	    }
	    
	    include_once MODX_BASE_PATH."assets/modules/editdocs/libs/PHPExcel/IOFactory.php";
	    $this->objPHPExcel = PHPExcel_IOFactory::load($this->output_dir.$this->fileName);

	    $this->sheetData = $this->objPHPExcel->getActiveSheet()->toArray(null,true,true,true);
	    $_SESSION['data'] = $this->sheetData;
	    echo $this->table($this->sheetData);
	}

	public function updateExcel() {
	    if($_SESSION['data']) {
	        return $this->updateReady($this->newMassif($_SESSION['data'])).$this->table($_SESSION['data']);
	    }
	    else return 'Сессия устарела, загрузите файл заново!';
	}

	public function updateReady($data) 
	{
	    $this->data = $data;
	    $this->field = $this->modx->db->escape($_POST['field']);
	    $this->log = '';

	    foreach ($this->data as $k => $val) {
	        foreach ($val as $key => $value) {

	            if($key == $this->field) {
	                $this->check = $this->checkField($this->field,$this->modx);
	                array_push($this->check, $value);
	                $this->id = $this->getID($this->check,$modx);
	            }

	            if($this->id > 0) {
	                if(!isset($_POST['test'])) {
	                    $this->doc->edit($this->id);
	                    $this->doc->set($key, $value);
	                    $this->doc->save(false, false);
	                    $this->log .= 'id-' . $this->id . ';' . $key . '=>' . $value . '<br/>';
	                }
	                else $this->log .= 'id-' . $this->id . ';' . $key . '=>' . $value . ' - Тестовый режим! <br/>';
	            }
	            else $this->log .= 'Не найдено совпадений по параметру - '.$this->field.'! <br/>';
	        }
	        $this->log .= '<hr/>';
	    }
	    return $this->log;
	}

	public function importExcel() {
	    if(!$_POST['parimp']) {
	        return '<div class="alert-ok ">Введите ID родителя!</div>'.$this->table($_SESSION['data']);
	    }
	    if($_SESSION['data']) {
	        return $this->importReady($this->newMassif($_SESSION['data'])).$this->table($_SESSION['data']);
	    }
	    else return 'Сессия устарела, загрузите файл заново!';
	}

	protected function importReady($data) {
	    $this->data = $data;
	    $this->log = '';

	    foreach ($this->data as $k => $val) {
	        foreach ($val as $key => $value) {

	            $this->create['parent'] = $this->modx->db->escape($_POST['parimp']);
	            $this->create[$key] = $value;
	            if($_POST['tpl']) $this->tpl = $this->modx->db->escape($_POST['tpl']);
	            if($this->tpl != 'file') $this->create['template'] = $this->tpl;
	        }

	        if(!isset($_POST['test'])) {
	            $this->doc->create($this->create);
	            $this->doc->save(false, false);

	            foreach ($this->create as $key => $val) {
	            $this->log .= $key.' - '.$val.' -> [ok!]<br/>';
	            }
	        }
	        else {
	            foreach ($this->create as $key => $val) {
	                $this->log .= $key.' - '.$val.' - Тестовый режим! <br/>';;
	            }
	        }
	        $this->log .= '<hr/>';
	    }
	    return $this->log;
	}

	protected function newMassif($data) 
	{
	    $j=0;
	    $this->data = $data;
	    $this->sheetDataNew = array();

	    foreach ($this->data[1] as $zna) {
	        $this->newkeys[$j] = $zna;
	        $j++;
	    }

	    foreach ($this->data as $k => $val) {
	        if($k>1) {
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
	    return $this->sheetDataNew;
	}

	protected function table($data) 
	{
	    $this->header = '<table class="tabres">';
	    $this->footer = '</table>';
	    $this->zag = $data[1];
	    foreach ($data as $k => $val) {
	        foreach ($val as $key => $value) {
	            $this->out .= '<td>'.$value.'</td>';
	        }
	        $this->out .= '<tr>'.$out.'</tr>';
	    }
	    return $this->header.$this->out.$this->footer;
	}

	protected function checkField($field) 
	{
	    $this->field = $field;
	    $this->param = array();
	    $this->res = $this->modx->db->query("SELECT name FROM ".$this->modx->getFullTableName('site_tmplvars'));
	    $this->temp = 0;
	    while( $this->row = $modx->db->getRow($this->res) ) {
	        if($this->row['name'] == $this->field) { $this->temp=1; $this->param[0]='tv'; $this->param[1]=$this->field;}
	    }
	    if($this->temp==0) {
	        $this->res = $this->modx->db->query("SHOW columns FROM ".$this->modx->getFullTableName('site_content')." where Field = '".$field."'");
	        if($this->modx->db->getRecordCount($this->res)>0 ) {
	            $this->param[0]='nonetv';
	            $this->param[1]=$this->field;
	        }

	        else {
	            $this->param[0]='notfound';
	            $this->param[1]=$this->field;
	        }
	    }
	    return $this->param;
	}

	public function getID($mode) 
	{
	    $this->mode = $mode;
	    if($this->mode[0]=='tv') {
	        $this->res = $this->modx->db->query("SELECT contentid FROM ".$this->modx->getFullTableName('site_tmplvar_contentvalues')." WHERE value='".$this->mode[2]."'" );
	        if( $this->modx->db->getRecordCount($this->res) >0 ) {
	            $this->row = $this->modx->db->getRow($this->res);
	            return $this->row['contentid'];
	        }
	    }
	    elseif($this->mode[0]=='nonetv') {
	        $this->res = $this->modx->db->query("SELECT id FROM ".$this->modx->getFullTableName('site_content')." WHERE ".$this->mode[1]."='".$this->mode[2]."'" );
	        if( $this->modx->db->getRecordCount($this->res) >0 ) {
	            $this->row = $modx->db->getRow($this->res);
	            return $this->row['id'];
	        }
	    }
	    else return 'NO';

	}

	public function clearCache()
	{
	    $this->modx->clearCache('full');
	    
	    foreach (glob(dirname(__DIR__) .'/uploads/*') as $file) {
	        unlink($file);
	    }
	}

}
