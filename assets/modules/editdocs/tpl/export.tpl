<div id="tab-page1" class="tab-page" style="display:block; max-width: 1600px">
    <form id="export-form">

        <input type="hidden" name="export" value="1"/>
        <input type="hidden" name="folder" value="export">

        <div class="uk-grid-divider uk-child-width-1-3@m" uk-grid>
            <div column="1">

                <div class=""><h3>[+lang.req_params+]</h3></div>

                <div class="uk-margin-top">
                    ID [+lang.parent+]<br/>
                    <input type="number" min="0" name="stparent" class="inp" id="stparent" style="width: 100px"/>
                </div>

                <div class="uk-margin-top">
                    [+lang.fields+] <br/>
                    <div class="uk-width-medium">
                        <select id="selfil" name="fieldz[]" multiple="multiple">
                            <optgroup label="[+lang.deffields+]">
                                <option value="id" selected disabled>ID ([+lang.vkldef+])</option>
                                [+fields+]
                                <option value="url">URL</option>
                            </optgroup>

                            <optgroup label="[+lang.tvoptions+]">
                                [+tvs+]
                            </optgroup>

                        </select>
                    </div>
                </div>

                <div class="uk-margin-top">
                    [+lang.level+]<br/>
                    <div class="uk-width-medium">
                        <select id="ed-tree" name="depth">
                            <option value="0" selected="selected">1</option>
                            <option value="1">2</option>
                            <option value="2">3</option>
                            <option value="3">4</option>
                            <option value="4">5</option>
                            <option value="5">6</option>
                            <option value="6">7</option>
                            <option value="7">8</option>
                            <option value="100">100</option>
                        </select>
                    </div>
                </div>

                <div class="uk-margin-top">
                    [+lang.separ+]:<br>
                    <input type="text" name="dm" id="dm" class="inp" style="width: 40px" maxlength="1" value=";"/>
                </div>
                <hr>

                <div class="alert-ok">
                    <b>[+lang.atention+]</b><br/>
                    [+lang.iconv+]<br>
                    [+lang.url+]
                </div>

            </div>
            <div column="2">
                <div><h3>[+lang.extra_params+]</h3></div>
                <br>
                <div class="uk-margin-top_">
                    <label>
                        <input type="checkbox" name="win" id="win" value="1" [+checked+]
                               style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.kodirovka+]
                    </label>
                    <label>
                        <input type="checkbox" name="neopub" id="neopub" value="1"
                               style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.unpubl+]
                    </label>
                    <label>
                        <input type="checkbox" name="export_mc" id="export_mc" value="1"
                               style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.export_mc+]
                    </label>
                    <br>
                    <!--label>
                        [+lang.fieds_custom+] <br>
                        <input type="text" name="fieldz_custom" id="fieldz_custom" placeholder="field1;field2;field3">
                    </label-->

                </div>
                <hr>
                <div class=""><h3>[+lang.filtration_zag+]</h3></div>

                <div class="uk-margin-top">

                        [+lang.filtertv+] (DocLister) <sup><span class="uk-inline" uk-icon="icon: info"
                                                            uk-tooltip="[+lang.dltext+]"></span></sup>

                    <input type="text" name="filters" id="filters" class="inp" style="max-width: 300px"
                           placeholder="[+lang.example+] tv:ves:>:1"/>


                </div>

                <div class="uk-margin-top">

                        [+lang.filterdef+] <sup><span class="uk-inline" uk-icon="icon: info"
                                                 uk-tooltip="[+lang.sqltext+]"></span></sup>

                    <input type="text" name="addwhere" id="addwhere" class="inp" style="max-width: 300px"
                           placeholder="[+lang.example+] c.template=2"/>

                </div>
                <div class="parf">
                    <a href="https://github.com/0test/evo-newdocs/blob/main/v1/04_Компоненты/DocLister/04_Фильтры.md"
                       target="_blank"><br/>[+lang.docfilters+] DocLister</a>
                </div>


            </div>

            <div column="3">
                <div class=""><h3>[+lang.configs_zag+]</h3></div>

                <div class="uk-margin-bottom">
                    [+lang.load_config+]<br>
                    <div class="uk-inline" style="width: 250px">
                        <select id="config" name="load_config">
                        </select>
                    </div>
                    <div class="uk-inline">
                        <button type="button" id="load_btn">[+lang.load_btn+]</button>
                    </div>
                </div>

                <div class="uk-margin-bottom">
                    [+lang.save_config+]<br>
                    <div class="" style="margin: 0">

                        <input name="save_config" type="text" id="cfg_name" placeholder="[+lang.config_name+]"
                               style="max-width: 250px">
                        <button type="button" id="save_btn" disabled>[+lang.save_btn+]</button>
                    </div>
                </div>
                <hr>
                <div class=""><h3>Prepare - [+lang.snippet+]</h3></div>
                <div class="uk-width-medium uk-margin-bottom">
                    [+lang.need_snippet+]<br>
                    <div class="uk-inline" style="width: 250px">
                        <select id="prep_snip" name="prep_snip">
                            <option value="none">[+lang.without_snippet+]</option>
                            [+prepare_options+]
                        </select>
                    </div>
                </div>

                <hr>
                <div class=""><h3>[+lang.clearcache+]</h3></div>

                <div class="uk-margin-top">
                    <button id="clear" type="button" class="btn btn-info"><span uk-icon="icon: refresh"></span>
                        [+lang.clearcache+]
                    </button>
                </div>

                <div class="uk-margin-top uk-width-medium">
                    <div id="warning" class="warning2"></div>
                </div>
            </div>
        </div>

        <div class="uk-text-center uk-margin-large-top">
            <button class="btn btn-success btn-lg" id="brsub" type="button"
                    style="padding-left: 50px; padding-right: 50px"><i class="fa fa-check"></i>
                [+lang.start_export+]
            </button>
        </div>
    </form>

    <br/><br/>
    <div class="uk-text-center">
        <div id="result_progress"></div>
        <div id="result"></div>
    </div>


    <script type="text/javascript"
            src="[+base_url+]assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
    <script>
        $(document).ready(function () {

            // <!--sumo select-->
            $('#selfil').SumoSelect({
                placeholder: '[+lang.selfields+]...',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                search: true,
                searchText: '[+lang.fieldortv+]',
                selectAll: true,
                locale: ['OK', 'Cancel', '[+lang.select_all+]']
            });
            $('#ed-tree,#config').SumoSelect({
                placeholder: '[+lang.selconfig+]...',
            });

            $('#prep_snip').SumoSelect({
                placeholder: '',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                search: true,
                searchText: '[+lang.name_snippet+]'
            });

            loadOptionsCfg();


            $('body').on('click', '#brsub, .page', function () {
                var data = $('form#export-form').serialize();
                makeProgress(data);
            }); //end click

            function makeProgress(data) {
                loading();

                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: data,
                    success: function (result) {
                        console.log(result);
                        resp = result.split("|");
                        if (resp[1] == 0) {
                            $('#result').html(resp[0]);
                            return;
                        }

                        if (parseInt(resp[0], 10) < parseInt(resp[1], 10)) {
                            $("#result_progress").html("<b>[+lang.expord+] " + resp[0] + " [+lang.of+] " + resp[1] + "</b>");
                            makeProgress(data);
                        } else {
                            $("#result_progress").html("<b>[+lang.expord+] " + resp[0] + " [+lang.of+] " + resp[1] + ". [+lang.gotovo+]</b>");
                            //document.location.href="/assets/modules/editdocs/uploads/export.csv";
                            $('#result').html('<p><br><a href="/assets/modules/editdocs/uploads/export.csv" class="btn btn-success" download>[+lang.download+] .CSV</a> &nbsp; <a href="/assets/modules/editdocs/uploads/export.xlsx" class="btn btn-success" download>[+lang.download+] Excel (.xlsx)</a></p>');
                        }
                    },
                    error:function(xhr,ajaxOptions,thrownError){
                        $('#result').html(thrownError+'\r\n'+xhr.statusText+'\r\n'+xhr.responseText);
                    }
                }); //end ajax
            }


            //clear cache
            $('body').on('click', '#clear', function () {

                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: "clear=1",
                    success: function (result) {

                        calert('[+lang.cache_cleared+]!');
                        top.mainMenu.reloadtree();


                    }

                }); //end ajax
            }); //end click

            //save config
            $('body').on('click', '#save_btn', function () {
                $(this).attr('disabled', 'disabled');
                dada = $('#export-form').serialize().replace('export=1', '');
                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: dada,
                    success: function (result) {
                        console.log(result)
                        setTimeout(function () {
                            loadOptionsCfg();
                        }, 300);
                    }
                }); //end ajax

                $("#cfg_name").val('');
                calert('[+lang.config_saved+]!');
            }); //end click

            //активируем кнопку для сохранения конфига
            $('body').on("change keyup", "#cfg_name", function () {
                var cfg_name = $("#cfg_name").val();
                if (cfg_name != "") $("#save_btn").removeAttr('disabled');
                else $("#save_btn").attr('disabled', 'disabled');
            }); //end click


            //load config
            $('body').on('click', '#load_btn', function () {
                cfg = $("#config").val();
                if (cfg == '') return;
                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: 'cfg_file=export/' + cfg,
                    success: function (result) {
                        var json = JSON.parse(result);
                        console.log(json);
                        calert('[+lang.config_loaded+]!');
                        //ID родителя
                        $('#stparent').val(json['stparent']);

                        //fields
                        if (json['fieldz']) {
                            json['fieldz'].forEach(function (field) {
                                $("#selfil option[value='" + field + "']").prop("selected", true);
                            });
                            $('#selfil')[0].sumo.reload();
                        }
                        //custom fields
                        $('#fieldz_custom').val(json['fieldz_custom']);

                        //уровень вложенности
                        $('#ed-tree').val(json['depth']);
                        $('#ed-tree')[0].sumo.reload();

                        //tvpic
                        $('#dm').val(json['dm']);

                        //win1251
                        if (json['win'] == "1") $('#win').prop('checked', true);
                        else $('#win').prop('checked', false);
                        //Показать неопубликованные
                        if (json['neopub'] == "1") $('#neopub').prop('checked', true);
                        else $('#neopub').prop('checked', false);
                        //category для MultiCategories
                        if (json['export_mc'] == "1") $('#export_mc').prop('checked', true);
                        else $('#export_mc').prop('checked', false);

                        //Фильтрация по TV (DocLister)
                        $('#filters').val(json['filters']);

                        //Фильтрация по основным полям
                        $('#addwhere').val(json['addwhere']);

                        //prepare snippet
                        $('#prep_snip').val(json['prep_snip']);
                        $('#prep_snip')[0].sumo.reload();

                    }
                }); //end ajax
            });


        }); //end ready


        function loading() {
            $('#result').html('<div class="loading">[+lang.obrabotka+]...</div>');
        }

        //подгружаем список файлов для конфигов
        function loadOptionsCfg() {
            $.ajax({
                type: "POST",
                url: "[+base_url+]assets/modules/editdocs/ajax.php",
                data: "getlist_files=export",
                success: function (result) {
                    var json = JSON.parse(result);
                    option = '';
                    json.forEach(function (entry) {
                        option += "<option value='" + entry['filename'] + "'>" + entry['title'] + "</option>"
                    });
                    $("#config").removeAttr('disabled');
                    $("#config").html(option);
                    $('#config')[0].sumo.reload();
                    console.log(result);

                }
            }); //end ajax
        }

        //Custom Alert
        function calert(text) {
            $('#warning').html('<div class="alert alert-success ahtung">' + text + '</div>');
            setTimeout(function () {
                $('.ahtung').fadeOut();
            }, 3000);
        }



    </script>
</div>
