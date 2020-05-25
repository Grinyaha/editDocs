/**
 * EditDocs
 * Ajax powered modules for edit fields DB & TV, update, import, export, mass movement of documents;
 *
 * necessary install DocLister & MODx API
 *
 * @category	 module
 * @version 	 0.4.6
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @author	   Alexander Grishin (special thanks Webber - web-ber12@yandex.ru)	  
 * @git        https://github.com/Grinyaha/editDocs
 * @internal    @properties {"prepare_snippet":[{"label":"Сниппет prepare","type":"string","value":"editDocsPrepare","default":"","desc":"Предварительная обработка данных"}],"include_fields":[{"label":"Включить поля ресурса","type":"string","value":"id,pagetitle,longtitle,description,alias,published,parent,introtext,content,template,menuindex,deleted,menutitle,hidemenu,createdon","default":"id,pagetitle,longtitle,description,alias,published,parent,introtext,content,template,menuindex,deleted,menutitle,hidemenu","desc":""}],"include_tvs":[{"label":"Включить TV","type":"string","value":"","default":"","desc":""}],"include_tmpls":[{"label":"ID доступных шаблонов","type":"string","value":"","default":"","desc":""}],"step":[{"label":"Шаг","type":"string","value":"100","default":"100","desc":""}],"e":[{"label":"Поля для экранирования кавычек","type":"string","value":"pagetitle","default":"pagetitle","desc":""}]}
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base, sample

 */

include_once(MODX_BASE_PATH.'assets/modules/editdocs/editdocs.module.php');

