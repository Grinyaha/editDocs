/**
 * EditDocs
 * Ajax powered modules for edit fields DB & TV, update, import, export.
 *
 * necessary install DocLister & MODx API
 *
 * @category	 module
 * @version 	 0.4.0
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @author	   Alexander Grishin (spexial thanks Webber - web-ber12@yandex.ru)	  
 * @git        https://github.com/Grinyaha/editDocs
 * @internal    @properties &include_fields=Включить поля ресурса;string;id,pagetitle,longtitle,description,alias,published,parent,introtext,content,template,menuindex,deleted,menutitle,hidemenu,template;;Перечисляем через запятую. Для редактирования id выключается.&include_tvs=Включить TV;string;;;Перечисляем через запятую. Если пусто, то показываем все TV.&include_tmpls=ID доступных шаблонов;string;;;Если пусто, то показываем все шаблоны.&step=Шаг;string;100;;Сколько строк обрабатывать за 1 запрос&e=Поля для экранирования кавычек;string;pagetitle;;Используется при экспорте в CSV

 * @internal    @modx_category Manager and Admin
 * @internal    @installset base, sample

 */

include_once(MODX_BASE_PATH.'assets/modules/editdocs/editdocs.module.php');

