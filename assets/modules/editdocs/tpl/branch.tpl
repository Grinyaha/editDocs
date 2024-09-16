<div id="tab-page1" class="tab-page" style="display:block; max-width: 1600px">
    <form id="branch">
        <input type="hidden" name="folder" value="edit">
        <input type="hidden" name="edit" value="1"/>

        <div class="uk-grid-divider uk-child-width-1-3@m" uk-grid>
            <div column="1">
                <div class=""><h3>[+lang.req_params+]</h3></div>

                <div class="uk-margin-top">
                    ID [+lang.parent+]<br/>
                    <input type="text" min="0" name="bigparent" class="inp" id="bigparent" style="max-width: 300px" placeholder="только числа через запятую!"/>

                </div>

                <div class="uk-margin-top">
                    <div class="uk-width-medium">
                        [+lang.fields+] <br/>
                        <select id="selfil" name="fields[]" multiple="multiple">
                            <optgroup label="[+lang.deffields+]">
                                [+fields+]
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
                        <select id="ed-tree" name="tree">
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
                <hr>
                <div class=""><h3>[+lang.extra_params+]</h3></div>

                <div class="uk-margin-top">
                    [+lang.tvimage+]<br/>

                    <input type="text" name="tvpic" id="tvpic" class="inp" style="width: 200px"/>
                </div>

                <div class="uk-margin-top">
                    <label>
                        <input type="checkbox" name="rendertv" id="rendertv" value="1"
                               style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.rendertv+]
                    </label>

                </div>
                <div class="uk-margin-small-top">
                    <label>
                        <input type="checkbox" name="paginat" id="paginat" value="1"
                               style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.pagination+]
                    </label>
                </div>
                <div class="uk-margin-small-top">
                    <label>
                        <input type="checkbox" name="neopub" id="neopub" value="1"
                               style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        [+lang.unpubl+]
                    </label>
                </div>
                <div class="uk-margin-small-top">
                    <label>
                        <input type="checkbox" name="multed" id="multed" value="1"
                               style="width: 1.5rem !important; height: 1.5rem !important; vertical-align: -0.45em !important"/>
                        <b>category</b> [+lang.for+] MultiCategories
                    </label>
                </div>


            </div>
            <div column="2">

                <div class=""><h3>[+lang.sorting_zag+]</h3></div>

                <div class="uk-margin-top">

                    [+lang.sorting+] <br/>
                    <div class="uk-width-medium">
                        <select id="order" name="order">
                            <optgroup label="[+lang.deffields+]">
                                <option value="id">id</option>
                                [+fields+]
                            </optgroup>

                            <optgroup label="[+lang.tvoptions+]">
                                [+tvs+]
                            </optgroup>

                        </select>
                    </div>
                </div>

                <div class="uk-margin-top">
                    [+lang.direction+] <br>
                    <div class="uk-width-medium">
                        <select id="orderas" name="orderas">
                            <option value="desc" selected="selected"> [+lang.desc+] (DESC)</option>
                            <option value="asc">[+lang.asc+] (ASC)</option>
                        </select>
                    </div>
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
                               style="width: 250px">
                        <button type="button" id="save_btn" disabled>[+lang.save_btn+]</button>
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
            <button class="btn btn-success btn-lg" id="brsub" type="button" work="edit"
                    style="padding-left: 50px; padding-right: 50px"><i class="fa fa-check"></i>
                [+lang.submit+]
            </button>
        </div>

    </form>

    <!-- alert edit -->
    <div id="warning1" class="warning"></div>

    <div id="result"></div>


    <script type="text/javascript"
            src="[+base_url+]assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
    <script>
        $(document).ready(function () {
            //подгружаем список файлов для конфигов


            //<!--sumo select-->
            $('#selfil').SumoSelect({
                placeholder: '[+lang.selfields+]...',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                search: true,
                searchText: '[+lang.fieldortv+]',
                selectAll: true,
                locale: ['OK', 'Cancel', '[+lang.select_all+]']
            });

            $('#order,#orderas').SumoSelect({
                placeholder: '[+lang.selconfig+]...',
                search: true,
                searchText: '[+lang.fieldortv+]'
            });
            $('#ed-tree,#config').SumoSelect({
                placeholder: '[+lang.selconfig+]...'
            });
            loadOptionsCfg();


            $('body').on('click', '#brsub, .page', function () {

                var data = $('form#branch').serialize();
                var page = $(this).attr('work');
                if (page == 'edit' || page == 1) var lpage = ''; else var lpage = '?list_page=' + page;
                loading();
                //console.log(lpage);

                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php" + lpage,
                    data: data,
                    success: function (result) {

                        //console.log(result);
                        $('#result').html(result);

                        $('select.sumochb, select.sumosel').SumoSelect({
                            placeholder: '[+lang.nothing+]...',
                            captionFormat: '{0} [+lang.selected+]',
                            csvDispCount: 2
                        });

                        //перематываем до начала параметров
                        UIkit.scroll('body').scrollTo('#brsub');


                    },
                    error: function (xhr, ajaxOptions, thrownError) {
                        //alert('1'+thrownError + '\r\n' + '2'+xhr.statusText + '\r\n' + '3'+xhr.responseText);
                        $('#warning').html('<div class="alert alert-danger">[+lang.errorf+]</div>');
                        $('#result').html('');

                    }

                }); //end ajax
            }); //end click


            $('body').on('change', '.ed-row td input, .ed-row td textarea, .ed-row td select', function () {

                //var data2 = $('form#dataf').serialize();
                var id = $(this).parents('tr.ed-row').find('td.idd').attr('idd');
                var pole = $(this).attr('name');
                var dat = $(this).val();

                let check = Array.isArray(dat);
                if (check) dat = dat.join('||');
                //console.log(dat);

                $.ajax({
                    type: "POST",
                    async: false,
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: "pole=" + pole + "&id=" + id + "&dat=" + dat,
                    success: function (result) {

                        $('#warning1').html('<div class="alert alert-success">' + result + '</div>');
                        setTimeout(function () {
                            $('.alert').fadeOut();
                        }, 3000);

                    },
                    error: function (xhr, ajaxOptions, thrownError) {

                        $('#warning1').html('<div class="alert alert-danger">[+lang.error+]</div>');

                        setTimeout(function () {
                            $('.alert').fadeOut();
                        }, 3000);

                    }

                }); //end ajax
            }); //end blur


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
                dada = $('#branch').serialize().replace('edit=1', '');
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
                    data: 'cfg_file=edit/' + cfg,
                    success: function (result) {
                        var json = JSON.parse(result);
                        console.log(json);
                        calert('[+lang.config_loaded+]!');
                        //ID родителя
                        $('#bigparent').val(json['bigparent']);

                        //fields
                        if (json['fields']) {
                            json['fields'].forEach(function (field) {
                                $("#selfil option[value='" + field + "']").prop("selected", true);
                            });
                            $('#selfil')[0].sumo.reload();
                        }

                        //уровень вложенности
                        $('#ed-tree').val(json['tree']);
                        $('#ed-tree')[0].sumo.reload();

                        //tvpic
                        $('#tvpic').val(json['tvpic']);

                        //Рендерить ТВ-поля
                        if (json['rendertv'] == "1") $('#rendertv').prop('checked', true);
                        else $('#rendertv').prop('checked', false);
                        //Пагинация
                        if (json['paginat'] == "1") $('#paginat').prop('checked', true);
                        else $('#paginat').prop('checked', false);
                        //Показать неопубликованные
                        if (json['neopub'] == "1") $('#neopub').prop('checked', true);
                        else $('#neopub').prop('checked', false);
                        //category для MultiCategories
                        if (json['multed'] == "1") $('#multed').prop('checked', true);
                        else $('#multed').prop('checked', false);

                        //Сортировка (поля или TV)
                        $('#order').val(json['order']);
                        $('#order')[0].sumo.reload();

                        //Сортировка (направление)
                        $('#orderas').val(json['orderas']);
                        $('#orderas')[0].sumo.reload();

                        //Фильтрация по TV (DocLister)
                        $('#filters').val(json['filters']);

                        //Фильтрация по основным полям
                        $('#addwhere').val(json['addwhere']);

                    }
                }); //end ajax
            }); //end click

        }); //end ready

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

        //подгружаем список файлов для конфигов
        function loadOptionsCfg() {
            $.ajax({
                type: "POST",
                url: "[+base_url+]assets/modules/editdocs/ajax.php",
                data: "getlist_files=edit",
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


    </script>
</div>
