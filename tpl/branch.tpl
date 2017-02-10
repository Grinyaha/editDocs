<div id="tab-page1" class="tab-page" style="display:block;">
    <form id="branch">


        <div>
            <div class="parf">
                <div class="parf">
                    ID родителя<br/>
                    <input type="text" name="bigparent" id="parent" class="inp" style="width: 70px"/>

                    <br/><br/>
                </div>
                <div class="parf">
                    Уровень вложенности<br/>

                    <select id="tree" name="tree">
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
                    Пагинация  <br/><input type="checkbox" name="paginat" value="1"/>
                </div>
                <div class="clear"></div>

                <div class="sumosize">
                    Поля или TV <br/>
                     <select id="selfil" name="fields[]" multiple="multiple">
                        <optgroup label="Стандартные поля">
                            <option value="pagetitle">pagetitle</option>
                            <option value="longtitle">longtitle</option>
                            <option value="description">description</option>
                            <option value="alias">alias</option>
                            <option value="published">published</option>
                            <option value="pub_date">pub_date</option>
                            <option value="unpub_date">unpub_date</option>
                            <option value="parent">parent</option>
                            <option value="isfolder">isfolder</option>
                            <option value="introtext">introtext</option>
                            <option value="content">content</option>
                            <option value="richtext">richtext</option>
                            <option value="template">template</option>
                            <option value="menuindex">menuindex</option>
                            <option value="searchable">searchable</option>
                            <option value="cacheable">cacheable</option>
                            <option value="createdby">createdby</option>
                            <option value="createdon">createdon</option>
                            <option value="editedby">editedby</option>
                            <option value="editedon">editedon</option>
                            <option value="deleted">deleted</option>
                            <option value="deletedon">deletedon</option>
                            <option value="deletedby">deletedby</option>
                            <option value="publishedon">publishedon</option>
                            <option value="publishedby">publishedby</option>
                            <option value="menutitle">menutitle</option>
                            <option value="donthit">donthit</option>
                            <option value="haskeywords">haskeywords</option>
                            <option value="hasmetatags">hasmetatags</option>
                            <option value="privateweb">privateweb</option>
                            <option value="privatemgr">privatemgr</option>
                            <option value="content_dispo">content_dispo</option>
                            <option value="hidemenu">hidemenu</option>
                        </optgroup>

                        <optgroup label="TV - параметры">
                            [+tvs+]
                        </optgroup>

                    </select>
                </div>
                <div class="subbat">
                    <button id="brsub" type="button" class="btn"> ПОЕХАЛИ</button>
                </div>

                <div class="clear"></div>

            </div>
            <div class="mess">
                <div id="warning"></div>
                <br/>
                <button id="clear" type="button" style="min-width: 170px" class="btn"> Сбросить кэш</button>
            </div>
            <div class="clear"></div>

        </div>

    </form>
    <br/><br/>
    <div id="result"></div>





    <script type="text/javascript" src="[+base_url+]assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
    <script>
        $(document).ready(function () {

            <!--sumo select-->
            $('#selfil').SumoSelect({
                placeholder: 'Выберите поля...',
                captionFormat: '{0} Выбрано',
                csvDispCount: 2,
                search: true,
                searchText: 'Имя поля или TV'
            });
            $('#tree').SumoSelect();


            $('body').on('click', '#brsub, .page', function () {

                var data = $('form#branch').serialize();
                var page = $(this).html();
                loading();
                console.log(data);

                $.ajax({
                    type: "POST",
                    url: "/assets/modules/editdocs/ajax.php?list_page="+page,
                    data: data,
                    success: function (result) {

                        //alert(result);

                        //var result = JSON.parse (result);
                        //console.log(result);
                        $('#result').html(result);


                    }

                }); //end ajax
            }); //end click


            $('body').on('blur', '.row td input, .row td textarea', function () {

                //var data2 = $('form#dataf').serialize();
                var id = $(this).parent().parent().find('td.idd').html();
                var pole= $(this).attr('name');
                var dat = $(this).val();

                //console.log(pole);

                $.ajax({
                    type: "POST",
                    url: "/assets/modules/editdocs/ajax.php",
                    data: "pole="+pole+"&id="+id+"&dat="+dat,
                    success: function (result) {

                        $('#warning').html(result);


                    }

                }); //end ajax
            }); //end blur


            $('body').on('click', '#clear', function () {

                $.ajax({
                    type: "POST",
                    url: "/assets/modules/editdocs/ajax.php",
                    data: "clear=1",
                    success: function (result) {

                        $('#warning').html(result);


                    }

                }); //end ajax
            }); //end click


        }); //end ready

        //разрешаем только ввод цифр
        $(document).ready(function() {
            $("input#parent").keydown(function(event) {
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