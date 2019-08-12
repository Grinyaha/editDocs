<div id="tab-page1" class="tab-page" style="display:block;">
    <form id="export-form">

        <input type="hidden" name="export" value="1" />

        <div>
            <div class="parf">
                <div class="parf">
                    ID родителя<br/>
                    <input type="text" name="stparent" id="stparent" class="inp" style="width: 70px"/>

                    <br/><br/>
                </div>
                <div class="parf">
                    Уровень вложенности<br/>

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

                <div class="parf">
                    Разделитель:<br>
                    <input type="text" name="dm" class="inp" style="width: 40px" maxlength="1" value=";"/>
                </div>

                <div class="parf">
                    <br/>
                    <input type="checkbox" name="win" value="1"/> кодировка WINDOWS-1251 (по дефолту UTF-8)<br/>
                    <input type="checkbox" name="neopub" value="1"/> Включить неопубликованные и помеченные на удаление
                </div>

                <div class="clear"></div>

                <div class="sumosize">
                    Поля или TV <br/>
                    <select id="selfil" name="fieldz[]" multiple="multiple">
                        <optgroup label="Стандартные поля">
                            [+fields+]
                            <option value="url">URL</option>
                        </optgroup>

                        <optgroup label="TV - параметры">
                            [+tvs+]
                        </optgroup>

                    </select>
                </div>
                <div class="subbat">
                    <button id="brsub" type="button" class="btn btn-success"><i class="fa fa-edit"></i>  ПОЕХАЛИ</button>

                </div>

                <div class="clear"></div>

                <div class="alert-ok">
                    ВНИМАНИЕ!<br/>
                    Перевод в кодировку WIN-1251 работает при условии, что ваш сайт корректно работает с кодировкой UTF-8.<br>
                    Поле URL выдает полный адрес текущего документа, включая домен.
                </div>

            </div>
            <div class="clear"></div>

        </div>

    </form>
    <br/><br/>
    <div id="result"></div>





    <script type="text/javascript" src="[+base_url+]assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
    <script>
        $(document).ready(function () {

           // <!--sumo select-->
            $('#selfil').SumoSelect({
                placeholder: 'Выберите поля...',
                captionFormat: '{0} Выбрано',
                csvDispCount: 2,
                search: true,
                searchText: 'Имя поля или TV'
            });
            $('#ed-tree').SumoSelect();


            $('body').on('click', '#brsub, .page', function () {
                var data = $('form#export-form').serialize();
                makeProgress(data);
            }); //end click

            function makeProgress(data) {
                loading();
                console.log(data);
                $.ajax({
                    type: "POST",
                    url: "/assets/modules/editdocs/ajax.php",
                    data: data,
                    success: function (result) {
                        resp = result.split("|");
                        if (parseInt(resp[0], 10) < parseInt(resp[1], 10)) {
                            $("#result_progress").html("<b>Экспорт: " + resp[0] + " из " + resp[1] + "</b>");
                            makeProgress(data);
                        } else {
                            $("#result_progress").html("<b>Экспорт: " + resp[0] + " из " + resp[1] + ". Готово!</b>");
                            document.location.href="/assets/modules/editdocs/uploads/export.csv";
                            $('#result').html('');
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


        }); //end ready

        //разрешаем только ввод цифр
        $(document).ready(function() {
            $("input#stparent").keydown(function(event) {
                // Разрешаем нажатие клавиш backspace, Del, Tab и Esc
                if ( event.keyCode == 46 || event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 27 ||
                    // Разрешаем выделение: Ctrl+A
                    (event.keyCode == 65 && event.ctrlKey === true) ||
                    // Разрешаем клавиши навигации: Home, End, Left, Right
                    (event.keyCode >= 35 && event.keyCode <= 39)) {
                    return;
                }
                else {
                    // Запрещаем всё, кроме клавиш цифр на основной клавиатуре, а также Num-клавиатуре
                    if ((event.keyCode < 48 || event.keyCode > 57) && (event.keyCode < 96 || event.keyCode > 105 )) {
                        event.preventDefault();
                    }
                }
            });
        });


        function loading() {
            $('#result').html('<div class="loading">Загружаюсь...</div>');
        }



    </script>
</div>