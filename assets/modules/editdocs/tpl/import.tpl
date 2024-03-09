<div id="tab-page1" class="tab-page" style="display:block; max-width: 1600px">

    <script>
        $(document).ready(function () {

            $('#config').SumoSelect({
                placeholder: '[+lang.selconfig+]...',
            });

            $('#checktv, #replace').SumoSelect({
                placeholder: '[+lang.selfields+]...',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                search: true,
                searchText: '[+lang.fieldortv+]'
            });

            $('#tpl').SumoSelect({
                placeholder: '[+lang.seltpls+]...',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                search: true,
                searchText: '[+lang.tplname+]'
            });

            $('#tpls').SumoSelect({
                placeholder: '[+lang.seltpls+]...',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                outputAsCSV: true,
                search: true,
                searchText: '[+lang.tplname+]'
            });

            $('#prep_snip').SumoSelect({
                placeholder: '',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                search: true,
                searchText: '[+lang.name_snippet+]'
            });

            Dropzone.autoDiscover = false;
            $("div#fileuploader").dropzone({
                url: "[+base_url+]assets/modules/editdocs/ajax.php",
                paramName: "myfile",
                acceptedFiles: ".xls, .xlsx, .ods, .csv",
                dictDefaultMessage: "[+lang.drag+]",
                //maxFiles: 1,
                //dictMaxFilesExceeded: "Можно загрузить только один файл",
                addRemoveLinks: true,
                dictRemoveFile: "[+lang.delfile+]",
                init: function () {
                    this.on("success", function (file, responseText) {

                        //excelTable(responseText);
                        responseText = responseText.split("#@");
                        $('#result_progress').html('<b>' + responseText[1] + '</b>');
                        $('#result').html(responseText[2]);
                        $('.sending #pro').show(0);
                        $('.sending .example').hide(0);

                        //перематываем до начала параметров
                        UIkit.scroll('body').scrollTo('#pro');

                        //подгружаем список файлов для конфигов
                        loadOptionsCfg();

                        if (responseText[4] != undefined) columns = responseText[4].split('=='); else columns = false;
                        exp = responseText[3].split('||');

                        //console.log(columns[0]);

                        $('#sravxls').html('');
                        $('#sravxls').append('<option value=""></option>');

                        exp.forEach(function (entry) {
                            $('#sravxls').append('<option value="' + entry + '">' + entry + '</option>');
                        });


                        $('#sravxls').SumoSelect({
                            placeholder: '[+lang.selfields+]...',
                            search: true,
                            searchText: '[+lang.fieldxls+]'
                        });

                        if (columns) {

                            $('#sravxls').val(columns[1]);
                            $('#checktv').val(columns[0]);
                        }

                        $('#sravxls')[0].sumo.reload();
                        $('#checktv')[0].sumo.reload();


                    });
                }
            });

            //активируем кнопку для сохранения конфига
            $('body').on("change keyup", "#cfg_name", function () {
                var cfg_name = $("#cfg_name").val();
                if (cfg_name != "") $("#save_btn").removeAttr('disabled');
                else $("#save_btn").attr('disabled', 'disabled');
            }); //end click

            $('body').on('click', '#process', function () {
                $("#hidf").val($('.tabres tr:nth-child(1) td:nth-child(1)').html());
                var dada = $('form#pro').serialize();
                makeProgress(dada)
            }); //end click

            function makeProgress(dada) {
                loading();
                //console.log(dada);
                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: dada,
                    success: function (result) {
                        if (result.indexOf('#@') !== -1) { //если ответ не содержит |, а сообщение
                            resp = result.split("#@");
                            $('#result').html(resp[2]);
                            //console.log(result);
                            if (parseInt(resp[0], 10) < parseInt(resp[1], 10)) {
                                $("#result_progress").html("<b>[+lang.impord+] " + resp[0] + " [+lang.of+] " + resp[1] + "</b>");

                                dada2 = $('form#pro:not([name="unpub"])').serialize();
                                dada2 = dada2.replace("unpub", "unpub2");
                                //console.log(dada2);
                                makeProgress(dada2);
                            } else {
                                $("#result_progress").html("<b>[+lang.impord+] " + resp[0] + " [+lang.of+] " + resp[1] + ". [+lang.gotovo+]</b>");
                                //подчищаем сессии
                                $.ajax({
                                    type: "POST",
                                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                                    data: 'cls=1',//clear session_start
                                    success: function (res) {
                                        //console.log(res);
                                    },
                                    error:function(xhr,ajaxOptions,thrownError){
                                        $('#result').html(thrownError+'\r\n'+xhr.statusText+'\r\n'+xhr.responseText);
                                    }
                                });
                            }
                        } else {
                            $('#result').html(result);
                        }
                    },
                    error:function(xhr,ajaxOptions,thrownError){
                        $('#result').html(thrownError+'\r\n'+xhr.statusText+'\r\n'+xhr.responseText);
                    }
                }); //end ajax
            }

            //save config
            $('body').on('click', '#save_btn', function () {
                $(this).attr('disabled', 'disabled');
                dada = $('#pro').serialize().replace('imp=1', '');
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
                calert('[+lang.config_saved+]!')
            }); //end click

            //load config
            $('body').on('click', '#load_btn', function () {
                cfg = $("#config").val();
                if (cfg == '') return;
                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: 'cfg_file=import/' + cfg,
                    success: function (result) {
                        var json = JSON.parse(result);
                        console.log(json);
                        calert('[+lang.config_loaded+]!');
                        //ID родителя
                        $('#parent').val(json['parimp']);

                        //шаблон
                        $('#tpl').val(json['tpl']);
                        $('#tpl')[0].sumo.reload();

                        //поле по которому сверяемся
                        $('#checktv').val(json['checktv']);
                        $('#checktv')[0].sumo.reload();

                        //Поле соответствия из XLS-таблицы
                        $('#sravxls').val(json['checktv2']);
                        $('#sravxls')[0].sumo.reload();

                        //Поле/TV для замены данных
                        $('#replace').val(json['replace']);
                        $('#replace')[0].sumo.reload();

                        //Ищем вхождение
                        $('#needle').val(json['needle']);
                        //Заменяем на
                        $('#replacement').val(json['replacement']);

                        //Снять с публикации перед импортом документы с шаблонами
                        fils = json['unpub'].split(",");
                        fils.forEach(function (tpl) {
                            $("#tpls option[value='" + tpl + "']").prop("selected", true);
                        });
                        $('#tpls')[0].sumo.reload();


                        //Не добавлять ЕСЛИ НЕТ СОВПАДЕНИЙ!
                        if (json['notadd'] == "1") $('#notadd').prop('checked', true);
                        else $('#notadd').prop('checked', false);
                        //Тестовый режим (без обновления)
                        if (json['test'] == "1") $('#test').prop('checked', true);
                        else $('#test').prop('checked', false);
                        //Импорт + MultiCategories
                        if (json['multi'] == "1") $('#multi').prop('checked', true);
                        else $('#multi').prop('checked', false);
                        //Reset + MultiCategories
                        if (json['multi_reset'] == "1") $('#multi_reset').prop('checked', true);
                        else $('#multi_reset').prop('checked', false);
                        //prepare snippet
                        $('#prep_snip').val(json['prep_snip']);
                        $('#prep_snip')[0].sumo.reload();
                    }
                }); //end ajax
            }); //end click

            //clear cache
            $('body').on('click', '#clear', function () {

                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: "clear=1",
                    success: function (result) {

                        //$('#warning').html(result);
                        calert('[+lang.cache_cleared+]!');
                        top.mainMenu.reloadtree();


                    }

                }); //end ajax
            }); //end click


        });

        //подгружаем список файлов для конфигов
        function loadOptionsCfg() {
            $.ajax({
                type: "POST",
                url: "[+base_url+]assets/modules/editdocs/ajax.php",
                data: "getlist_files=import",
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

        function loading() {
            $('#result').html('<div class="loading">[+lang.obrabotka+]...</div>');
        }

        //Custom Alert
        function calert(text) {
            $('#warning').html('<div class="alert alert-success ahtung">' + text + '</div>');
            setTimeout(function () {
                $('.ahtung').fadeOut();
            }, 3000);
        }

    </script>

    <!-- HTML -->

    <a class="btn btn-info" href="#modal-readme" uk-toggle>[+lang.help+] <span uk-icon="icon: info; ratio: 1"></span> </a>
    <div id="modal-readme" class="uk-flex-top" uk-modal>
        <div class="uk-modal-dialog uk-modal-body uk-margin-auto-vertical" style="width: 1200px">

            <button class="uk-modal-close-default" type="button" uk-close></button>

            <div class="">
                <p><b>⚡[+lang.atention+]</b><br/></p>

                <div class="uk-child-width-1-2@m" uk-grid>

                    <div>
                        <ul class="uk-list uk-list-square uk-list-divider">
                            <li>[+lang.needtitle+] <b>pagetitle</b></li>
                            <li>[+lang.foradd+]</li>
                            <li>[+lang.impcsv+]</li>
                        </ul>
                    </div>

                    <div>
                        <ul class="uk-list uk-list-square uk-list-divider">

                            <li>[+lang.idparent+]</li>
                            <li>[+lang.multitv+]</li>
                    </div>

                </div>
            </div>

        </div>
    </div>


    <div id="fileuploader" class="dropzone uk-margin-small-top"></div>

    <div class="sending uk-margin-top">
        <div class="example">
            <img src="/assets/modules/editdocs/css/example.png">
        </div>
        <form id="pro">
            <input type="hidden" name="imp" value="1"/>
            <input type="hidden" name="folder" value="import">

            <div class="uk-grid-divider uk-child-width-1-3@m" uk-grid>
                <div column="1">

                    <div class=""><h3>[+lang.common_params+]</h3></div>

                    <div class="uk-margin-bottom">
                        <div >
                        ID [+lang.parent+] <sup><span uk-icon="icon: info"
                                                 uk-tooltip="[+lang.if_parent+]"></span></sup>
                        </div>
                        <input type="number" min="0" name="parimp" id="parent" class="uk-input" style="width: 100px"/>

                    </div>
                    <div class="uk-margin-bottom">
                        <div>
                        [+lang.tpl+] <sup><span class="uk-inline" uk-icon="icon: info"
                                                  uk-tooltip="[+lang.if_template+]"></span></sup>
                        </div>

                        <div class=" uk-width-medium uk-inline">
                            <select id="tpl" name="tpl">
                                <option selected="selected" value="file">[+lang.fromfile+]</option>
                                [+tpl+]
                                <option value="blank">(blank) [+lang.nontpl+]</option>
                            </select>
                        </div>

                    </div>
                    <hr>
                    <div class=""><h3 class="uk-margin-remove_">[+lang.data_replace+]</h3></div>

                    <div class="uk-margin-small-bottom">

                        <div class="uk-width-medium">
                            [+lang.replace_field+] <br>
                            <select id="replace" name="replace">
                                <option value="0" selected="selected">[+lang.nonreplace+]</option>
                                <optgroup label="[+lang.deffields+]">
                                    [+fields+]
                                </optgroup>
                                <optgroup label="[+lang.tvoptions+]">
                                    [+tvs+]
                                </optgroup>

                            </select>
                        </div>
                    </div>

                    <div class="uk-margin-small-bottom">
                        <div class="uk-width-medium">
                            [+lang.entry+]<br/>
                            <input type="text" name="needle" id="needle" class="inp"/>
                        </div>
                    </div>

                    <div class="uk-margin-bottom">
                        <div class="uk-width-medium">
                            [+lang.replace+]<br/>
                            <input type="text" name="replacement" id="replacement" class="inp"/>
                        </div>
                    </div>

                </div>
                <div column="2">

                    <div class=""><h3>[+lang.recon_zag+]</h3></div>

                    <div class="uk-margin-bottom uk-width-medium">
                        [+lang.checkfield+]<br/>
                        <select id="checktv" name="checktv">
                            <option value="0" selected="selected">[+lang.nonchecking+]</option>
                            <optgroup label="[+lang.deffields+]">
                                <option value="id">ID [+lang.idresurs+]</option>
                                [+fields+]
                            </optgroup>
                            <optgroup label="[+lang.tvoptions+]">
                                [+tvs+]
                            </optgroup>

                        </select>
                    </div>
                    <div class="uk-margin-bottom uk-width-medium">
                        [+lang.srav_field+] <br>

                        <!--input type="text" name="checktv2" style="width: 200px" class="inp" placeholder=""-->
                        <select name="checktv2" id="sravxls" class=""></select>

                    </div>


                    <div class="">
                        <label>
                            &nbsp;&nbsp;<input type="checkbox" id="notadd" name="notadd" value="1"  style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                            [+lang.noadd+]
                        </label>
                    </div>

                    <hr>
                    <div class=""><h3>[+lang.before_import+]</h3></div>

                    <div class="uk-margin-bottom ">
                        [+lang.makeunpub+]<br>
                        <div class="uk-width-medium">
                            <select id="tpls" name="unpub" multiple="multiple">

                                [+tpl+]
                                <option value="0">(blank) [+lang.nontpl+]</option>
                            </select>
                        </div>
                    </div>
                    <label style="color: #c00">
                        &nbsp;&nbsp;<input type="checkbox" id="test" name="test" value="1" style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.testmode+]
                    </label>
                    <hr>
                    <div class=""><h3>[+lang.mc_zag+]</h3></div>

                    <label>
                        &nbsp;<input type="checkbox" name="multi" id="multi" value="1" style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.impformc+]
                    </label>
                    <br>
                    <label>
                        &nbsp;<input type="checkbox" name="multi_reset" id="multi_reset" value="1" style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.multi_reset+]
                    </label>

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
                                   style="width: 250px">
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


            <div class="uk-text-center uk-margin-large-top uk-margin-bottom">
                <button class="btn btn-success btn-lg" id="process" type="button" style="padding-left: 50px; padding-right: 50px"><i class="fa fa-check"></i>
                    [+lang.startimport+]
                </button>
            </div>





        </form>

        <div class="clear"></div>
    </div>


    <div id="result_progress"></div>
    <div id="result"></div>


</div>
