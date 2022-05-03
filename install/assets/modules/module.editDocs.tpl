/**
 * EditDocs
 * Ajax powered modules for edit fields DB & TV, update, import, export, mass movement of documents;
 *
 * necessary install DocLister & MODx API
 *
 * @category	 module
 * @version 	 1.3.7
 * @license     http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @author	   Alexander Grishin (special thanks Webber - web-ber12@yandex.ru)
 * @git        https://github.com/Grinyaha/editDocs
 * @internal    @properties {"include_fields":[{"label":"Include fields","type":"string","value":"id,pagetitle,longtitle,description,alias,published,parent,introtext,content,template,menuindex,deleted,menutitle,hidemenu,createdon","default":"id,pagetitle,longtitle,description,alias,published,parent,introtext,content,template,menuindex,deleted,menutitle,hidemenu,createdon","desc":"a list with a choice of main fields separated by a comma of the document for editing and export "}],"include_tvs":[{"label":"Include TV","type":"string","value":"","default":"","desc":"TV list separated by commas for editing or export (if empty = all TVs)"}],"include_tmpls":[{"label":"IDs of available templates","type":"string","value":"","default":"","desc":"list of id of available templates (if empty = all templates) "}],"step":[{"label":"Step","type":"string","value":"100","default":"100","desc":"The number of iterations per ajax request. Be careful with this parameter. Better not to change."}],"e":[{"label":"Quote Escaping Fields","type":"string","value":"pagetitle","default":"pagetitle","desc":"comma-separated list of fields to escape "}],"prepare_snippet":[{"label":"Prepare snippet","type":"string","value":"editDocsPrepare","default":"","desc":"Snippet name for preprocessing data (created automatically when installing this module) "}],"win1251": [{"label": "Enable Win-1251 encoding on export by default","type": "list","value":"true","options":"true,false","default":"true","desc":""}]}
 * @internal    @modx_category Manager and Admin
 * @internal    @installset base, sample

 */

include_once(MODX_BASE_PATH.'assets/modules/editdocs/editdocs.module.php');
