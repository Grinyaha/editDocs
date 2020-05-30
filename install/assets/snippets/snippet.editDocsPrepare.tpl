//<?php
/**
 * editDocsPrepare
 * 
 * Prepare-сниппет для модуля editDocs
 *
 * @author      webber (web-ber12@yandex.ru)
 * @category    snippet
 * @version     0.1
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base, sample
 */

//ВАЖНО! для отслеживания тестового режима при импорте в сниппет передается переменная $doing, 1 - боевой режим, 0-тестовый режим.

$process = isset($process) ? $process : '';
$mode = isset($mode) ? $mode : '';
switch ($process) {
    case 'import':
        //обработчик импорта
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
