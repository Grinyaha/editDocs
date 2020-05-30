<div id="tab-page1" class="tab-page" style="display:block;">

    <script>
        $(document).ready(function () {
            $('#tpl,#checktv').SumoSelect({          
                placeholder: 'Выберите поля...',
                captionFormat: '{0} Выбрано',
                csvDispCount: 2,
                search: true,
                searchText: 'Имя поля или TV'
                });

            Dropzone.autoDiscover = false;
            $("div#fileuploader").dropzone({
                url: "/assets/modules/editdocs/ajax.php",
                paramName: "myfile",
                acceptedFiles: ".xls, .xlsx, .ods, .csv",
                dictDefaultMessage: "Перетащите сюда нужный EXCEL/CSV-файл или выберите по клику",
                //maxFiles: 1,
                //dictMaxFilesExceeded: "Можно загрузить только один файл",
                addRemoveLinks: true,
                dictRemoveFile: "Удалить файл",
                init: function () {
                    this.on("success", function (file, responseText) {
                        //console.log(responseText);
                        //excelTable(responseText);
                        responseText = responseText.split("#@");
                        $('#result_progress').html('<b>' + responseText[1] + '</b>');
                        $('#result').html(responseText[2]);
                        $('.sending').show(0);
                    });
                }
            });



            $('body').on('click', '#process', function () {
                $("#hidf").val($('.tabres tr:nth-child(1) td:nth-child(1)').html());
                var dada = $('form#pro').serialize();
                makeProgress(dada)
            }); //end click

            function makeProgress(dada) {
                loading();
                console.log(dada);
                $.ajax({
                    type: "POST",
                    url: "/assets/modules/editdocs/ajax.php",
                    data: dada,
                    success: function (result) {
                        if(result.indexOf('#@') !== -1) { //если ответ не содержит |, а сообщение
                        resp = result.split("#@");
                        $('#result').html(resp[2]);
                        //console.log(result);
                        if (parseInt(resp[0], 10) < parseInt(resp[1], 10)) {
                            $("#result_progress").html("<b>Импорт: " + resp[0] + " из " + resp[1] + "</b>");
                            makeProgress(dada);
                        } else {
                            $("#result_progress").html("<b>Импорт: " + resp[0] + " из " + resp[1] + ". Готово!</b>");
                            
                            //подчищаем сессии
                            $.ajax({
                                type: "POST",
                                url: "/assets/modules/editdocs/ajax.php",
                                data: 'cls=1',//clear session_start
                                success: function (res) {
                                    console.log(res);
                                }
                            });

                    }
                        }
                    }
                    else {
                        $('#result').html(result);
                    }
                    }
                }); //end ajax
            }


            $('body').on('click', '#clear', function () {

                $.ajax({
                    type: "POST",
                    url: "/assets/modules/editdocs/ajax.php",
                    data: "clear=1",
                    success: function (result) {

                        $('#warning').html(result);
                        top.mainMenu.reloadtree();


                    }

                }); //end ajax
            }); //end click


        });

        function loading() {
            $('#result').html('<div class="loading">Загружаюсь...</div>');
        }

    </script>

    <div class="alert-ok">
        ВНИМАНИЕ!<br />       
            Для работы импорта в файле Excel должен обязательно быть столбец(поле) с названием <b>pagetitle</b><br>
            Для добавления/редактирования данных связанных с плагином <b>MultiCategories</b> в файле-таблице необходим столбец с названием <b>category</b> <u>(необходимые категории указываются через запятую).</u> Также не забудьте включить нужный чекбокс!<br>
            При импорте CSV, файл должен быть в кодировке UTF-8.<br>
            ID родителя указываем в случае, если нет поля <b>parent</b> в таблице. Приоритет значения из файла-таблицы Excel.
        
    </div>

    <div id="fileuploader" class="dropzone"></div>
    <br /><br />
    <div class="sending">
        <form id="pro">
            <div class="parf">
                ID родителя<br />
                <input type="text" name="parimp" id="parent" class="inp" style="width: 70px" />
            </div>
            <div class="parf" style="width: 300px">
                Шаблон<br />

                <select id="tpl" name="tpl">
                    <option selected="selected" value="file">Из файла</option>
                    [+tpl+]
                    <option value="blank">(blank) без шаблона</option>
                </select>
            </div>
            <div class="parf">
                Поле по которому сверяемся<br />
                <select id="checktv" name="checktv">
                    <option value="0" selected="selected">без проверки</option>
                    <optgroup label="Основные поля">
                        <option value="id">id ресурса</option>
                        [+fields+]
                    </optgroup>
                    <optgroup label="TV - параметры">
                        [+tvs+]
                    </optgroup>

                </select>
            </div>
            <div class="subbat">
                <button class="btn btn-success" id="process" type="button"><i class="fa fa-edit"></i> ПОЕХАЛИ!</button>   
                
            </div>
            <div class="clear"></div>
            <br>
            <label class="form-check-label">
                &nbsp; &nbsp; &nbsp; <input type="checkbox" id="notadd" name="notadd" value="1" class="form-check-input" /> Не добавлять ЕСЛИ НЕТ СОВПАДЕНИЙ!
            </label>
            <br>
            <label class="form-check-label">
                &nbsp; &nbsp; &nbsp;  <input type="checkbox" id="test" name="test" value="1" class="form-check-input" /> Тестовый режим
                (без обновления)
            </label>
            <br>
            <label class="form-check-label">
                &nbsp; &nbsp; &nbsp; <input type="checkbox" name="multi" value="1" class="form-check-input" /> Импорт для MultiCategories
            </label>
            <br>

            <div class="mess">
                <div id="warning"></div>
                <br />
                <button id="clear" type="button" class="btn btn-info"><i class="fa fa-gavel"></i> Сбросить кэш</button>
            </div>
            <input type="hidden" name="imp" value="1" />
            <br />
        </form>
        <div class="clear"></div>
    </div>

    <br /><br />
    <div id="result_progress"></div>
    <div id="result" class="result"></div>

</div>