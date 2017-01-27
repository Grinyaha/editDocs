<?php

define('MODX_API_MODE', true);
include_once '../../../manager/includes/config.inc.php';
include_once '../../../manager/includes/document.parser.class.inc.php';
$modx = new DocumentParser;
$modx->db->connect();
$modx->getSettings();
startCMSSession();
$modx->minParserPasses = 2;

include_once(MODX_BASE_PATH . "assets/lib/MODxAPI/modResource.php");

if ($_POST['clear']) {
    clearCache(MODX_BASE_PATH);
    echo 'Кэш очищен';
}


if ($_POST['bigparent'] != '' && !$_POST['tree']) {
    echo getAllList();
} elseif ($_POST['bigparent'] != '' && $_POST['tree']) {
    echo getAllListTree();
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
    $doc->save(false, false);

    if ($doc->save(false, false)) {
        return '<div class="alert-ok">Ресурс ' . $id . ' - отредактирован!';
    } else {
        return '<div class="alert-err">ERROR!</div>';
    }
    //print_r($_POST);
}


function getAllList()
{
    global $modx;

    $parent = $modx->db->escape($_POST['bigparent']);

    if ($_POST['fields']) {

        $fields = $modx->db->escape($_POST['fields']);
        $fields[99] = 'id';

        $result = $modx->getDocumentChildrenTVars($parent, $fields);

        //print_r($result);
        //формируем заголовки столбцов
        $th = '';

        foreach ($result[0] as $key => $val) {
            if ($result[0][$key]['name'] != '' && $result[0][$key]['name'] != 'id') {
                $th .= "<td>" . $result[0][$key]['name'] . "</td>";
            }


        }
        $th = "<td>id</td>" . $th;
        //echo $th;

        $out = '';
        $out .= allRow($parent,$fields);

        return htmlTH($th) . $out . htmlFooter();


    }


}


function getAllListTree()
{
    global $modx;

    $out = '';
    $parent = $modx->db->escape($_POST['bigparent']);
    $fields = $modx->db->escape($_POST['fields']);
    $fields[99] = 'id';


    $result = $modx->getDocumentChildrenTVars($parent, $fields);
    //формируем заголовки столбцов
    $th = '';

    foreach ($result[0] as $key => $val) {
        if ($result[0][$key]['name'] != '' && $result[0][$key]['name'] != 'id') {
            $th .= "<td>" . $result[0][$key]['name'] . "</td>";
        }


    }
    $th = "<td>id</td>" . $th;
    $out .= allRow($parent, $fields);


    $tree = $modx->getChildIds($parent);
    foreach ($tree as $vv) {

        $out .= allRow($vv, $fields);

    }

    return htmlTH($th) . $out . htmlFooter();


}

function allRow($vv, $fields) {

    global $modx;
    $out = '';
    $result = $modx->getDocumentChildrenTVars($vv, $fields);

//    print_r($result);



    if (is_array($result)) {

        foreach ($result as $key => $val) {
            $inp = '';

            foreach ($result[$key] as $k => $v) {

                if ($result[$key][$k]['name'] != 'id') {
                    $inp .= htmlInp($result[$key][$k]['name'], $result[$key][$k]['value']);
                } else $idd = $result[$key][$k]['value'];

            }

            $out .= '<tr class="row"><td class="idd">' . $idd . '</td>' . $inp . '</tr>';


        }


    }
    return $out;
}


function htmlTH($th)
{
    $header = '
<form id="dataf">
    <table class="tabres">
     <tr>
        ' . $th . '
    </tr>   
    ';

    return $header;

}


function htmlInp($name, $value)
{

    if ($name == 'id') {
        $type = 'hidden';
        $val = $value;

    } else {
        $type = 'text';
        $val = '';
    }
    //если данные от MultiTV то textarea
    if (strstr($value, '{')) $a = true; else $a = false;

    if ($a == true) {
        $input = '<td><textarea name="' . $name . '" style="width:99%;">' . $value . '</textarea></td>';
    } else {
        $input = '<td>' . $val . '<input type="' . $type . '" name="' . $name . '" value="' . $value . '"  ' . $dis . '/></td>';
    }


    return $input;

}


function htmlFooter()
{
    $footer = '
        </table></form>
        <br/>
        <!--<button id="save" type="button"> <b>SAVE</b></button>-->
    ';

    return $footer;

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