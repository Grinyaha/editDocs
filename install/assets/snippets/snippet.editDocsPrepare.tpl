//
<?php
/**
 * editDocsPrepareExample
 * 
 * Пример-заготовка Prepare-сниппета для модуля editDocs
 *
 * @author      webber (web-ber12@yandex.ru)
 * @category    snippet
 * @version     0.1
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @modx_category editDocs
 * @internal    @installset base, sample
 */

//Не используйте данный сниппет как боевой, скопируйте как новый и пропишите его в настройках, иначе при обновление данный сниппет перезапишется на дефолтный example! 

$process = isset($process) ? $process : '';
$mode = isset($mode) ? $mode : '';
$total = $_SESSION['import_total']-2; //последняя итерация

switch ($process) {
    case 'import':
        //обработчик импорта

        //первая итерация
		//if ($iteration == 1) { }

		//последняя итерация
		//if ($iteration == $total) { }

        switch ($mode) {
            case 'upd':
                //обновляем ресурс
                //$data['pagetitle'] = 'import upd ' .  $data['pagetitle'];
                break;
            case 'new':
                //добавляем новый ресурс
                //$data['pagetitle'] = 'import new ' .  $data['pagetitle'];
                break;
            default:
                break;
        }
        break;
    case 'export':
        //обработчик экспорта
        //$data['pagetitle'] = 'export ' .  $data['pagetitle'];
        break;
    default:
        break;
}
return $data;