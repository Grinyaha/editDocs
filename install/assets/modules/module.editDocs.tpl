/**
 * EditDocs
 * Ajax powered modules for edit fields DB & TV, update, import, export, mass movement of documents;
 *
 * necessary install DocLister & MODx API
 *
 * @category	 module
 * @version 	 1.0.2
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @author	   Alexander Grishin (special thanks Webber - web-ber12@yandex.ru)
 * @git        https://github.com/Grinyaha/editDocs
 * @internal    @properties {"include_fields":[{"label":"Включить поля ресурса","type":"string","value":"id,pagetitle,longtitle,description,alias,published,parent,introtext,content,template,menuindex,deleted,menutitle,hidemenu,createdon","default":"id,pagetitle,longtitle,description,alias,published,parent,introtext,content,template,menuindex,deleted,menutitle,hidemenu,createdon","desc":"список с выбором основных полей через запятую документа для редактирования и экспорта"}],"include_tvs":[{"label":"Включить TV","type":"string","value":"","default":"","desc":"список TV через запятую для редактирования или экспорта (если не заполнено = все TV)"}],"include_tmpls":[{"label":"ID доступных шаблонов","type":"string","value":"","default":"","desc":"список id доступных шаблонов (если не заполнено = все шаблоны)"}],"step":[{"label":"Шаг","type":"string","value":"100","default":"100","desc":"Количество итераций при одном ajax-запросе. Осторожнее с этим параметром. Лучше не менять."}],"e":[{"label":"Поля для экранирования кавычек","type":"string","value":"pagetitle","default":"pagetitle","desc":"список полей для экранирования через запятую"}],"prepare_snippet":[{"label":"Сниппет prepare","type":"string","value":"editDocsPrepare","default":"","desc":"Имя сниппета для предварительной обработка данных (создается автоматом при инсталляции данного модуля)"}],"win1251": [{"label": "Включить кодировку Win-1251 при экспорте по-умолчанию","type": "list","value":"true","options":"true,false","default":"true","desc":""}]}
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base, sample

 */

include_once(MODX_BASE_PATH.'assets/modules/editdocs/editdocs.module.php');
