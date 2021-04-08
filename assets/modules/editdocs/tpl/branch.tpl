<div id="tab-page1" class="tab-page" style="display:block;">
    <form id="branch">


        <div>
            <div class="parf">
                <div class="parf">
                    ID родителя<br/>
                    <input type="text" name="bigparent" id="ed-parent" class="inp" style="width: 70px"/>
                    <input type="hidden" name="edit" value="1" />

                    <br/><br/>
                </div>
                <div class="parf">
                    Уровень вложенности<br/>

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
                <div class="parf">
                    имя TV-image (если есть)<br/>

                    <input type="text" name="tvpic" id="" class="inp" style="width: 120px"/>
                </div>

                <div class="parf">
                    
                        Сортировка (поля или TV) <br/>
                         <select id="order" name="order">
                            <optgroup label="Стандартные поля">
                                <option value="id">id</option>
                                [+fields+]
                            </optgroup>
    
                            <optgroup label="TV - параметры">
                                [+tvs+]
                            </optgroup>
    
                        </select>
                    
                </div>

                <div class="parf">
                    Сортировка (направление) <br>
                    <select id="orderas" name="orderas">
                        <option value="desc" selected="selected"> По убыванию (DESC)</option>
                        <option value="asc">По возрастанию (ASC)</option>
                    </select>
                </div>

                 <div class="clear"></div>

                <div class="parf">
                <div class="sumosize">
                    Поля или TV <br/>
                     <select id="selfil" name="fields[]" multiple="multiple">
                        <optgroup label="Стандартные поля">
                            [+fields+]
                            <!-- 
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
                            -->
                        </optgroup>

                        <optgroup label="TV - параметры">
                            [+tvs+]
                        </optgroup>

                    </select>
                </div>
                </div>
                <div class="parf">
                    Фильтрация по ТВ (DocLister)</br>
                    <input type="text" name="filters" id="filters" class="inp" style="width: 200px"  placeholder="ПРИМЕР: tv:ves:>:1"/>
                    <i class="fa fa-question-circle fa-lg" title="Фильтрация по ТВ-параметрам согласно правилам компонента DocLister, например tv:ves:>:1"></i>
                </div>

                <div class="parf">
                    Фильтрация по основным полям</br>
                    <input type="text" name="addwhere" id="addwhere" class="inp" style="width: 200px"  placeholder="ПРИМЕР: c.template=2"/>
                    <i class="fa fa-question-circle fa-lg" title="Фильтрация согласно правилам SQL запросов, например c.template=2"></i>
                </div>
                <div class="parf">
                    <a href="https://docs.evo.im/04_extras/doclister/04_filters.html" target="_blank"><br/>Документация по фильтрам DocLister</a>
                </div>

                <div class="clear"></div>

                <div class="parf">
                    <br/>
                    <label class="form-check-label">
                     &nbsp; &nbsp; &nbsp; <input class="form-check-input" type="checkbox" name="paginat" value="1"/> Пагинация <br/>
                    </label>
                        <div class="clear"></div>
                    <label class="form-check-label">
                     &nbsp; &nbsp; &nbsp; <input class="form-check-input" type="checkbox" name="neopub" value="1"/> Включить неопубликованные и помеченные на удаление
                    </label>
                        <div class="clear"></div>
                    <label class="form-check-label">
                        &nbsp; &nbsp; &nbsp; <input type="checkbox" name="multed" value="1" class="form-check-input" /> <b>category</b> для MultiCategories
                    </label>
                </div>
                <div class="clear"></div>
                <br>


                <div class="subbat">
                    <button id="brsub" type="button" class="btn btn-success" work="edit"><i class="fa fa-check"></i> ВЫПОЛНИТЬ</button>
                </div>

                <div class="clear"></div>

            </div>
            <div class="mess">
                <br/>
                <button id="clear" type="button" class="btn btn-info"  style="min-width: 170px" ><i class="fa fa-gavel"></i> Сбросить кэш</button>
            </div>
            <div id="warning" class="warning"></div>
            <div class="clear"></div>

        </div>

    </form>
    <br/><br/>
    <div id="result"></div>





    <script type="text/javascript" src="[+base_url+]assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
    <script>
        $(document).ready(function () {

            //<!--sumo select-->
            $('#selfil').SumoSelect({
                placeholder: 'Выберите поля...',
                captionFormat: '{0} Выбрано',
                csvDispCount: 2,
                search: true,
                searchText: 'Имя поля или TV'
            });
            $('#ed-tree').SumoSelect();
            
            $('#order,#orderas').SumoSelect();


            $('body').on('click', '#brsub, .page', function () {

                var data = $('form#branch').serialize();
                var page = $(this).attr('work');
                if(page=='edit' || page==1) var lpage = ''; else  var lpage = '?list_page='+page;
                loading();
                //console.log(lpage);

                $.ajax({
                    type: "POST",
                    url: "/assets/modules/editdocs/ajax.php"+lpage,
                    data: data,
                    success: function (result) {

                        //console.log(result);
                        $('#result').html(result);


                    },
                    error: function(xhr, ajaxOptions, thrownError) {
                        //alert('1'+thrownError + '\r\n' + '2'+xhr.statusText + '\r\n' + '3'+xhr.responseText);
                        $('#warning').html('<div class="alert alert-danger">ОШИБКА! Проверьте фильтрацию!</div>');
                        $('#result').html('');

                    }

                }); //end ajax
            }); //end click


            $('body').on('blur', '.ed-row td input, .ed-row td textarea', function () {

                //var data2 = $('form#dataf').serialize();
                var id = $(this).parent().parent().find('td.idd').html();
                var pole= $(this).attr('name');
                var dat = $(this).val();

                //console.log(pole);

                $.ajax({
                    type: "POST",
                    async: false,
                    url: "/assets/modules/editdocs/ajax.php",
                    data: "pole="+pole+"&id="+id+"&dat="+dat,
                    success: function (result) {

                        $('#warning').html('<div class="alert alert-success">'+result+'</div>');
                        setTimeout(function(){
                            $('.alert').fadeOut();
                        }, 3000);


                    },
                    error: function(xhr, ajaxOptions, thrownError) {

                        $('#warning').html('<div class="alert alert-danger">ОШИБКА!</div>');

                        setTimeout(function(){
                            $('.alert').fadeOut();
                        }, 3000);

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
                        top.mainMenu.reloadtree();


                    }

                }); //end ajax
            }); //end click


        }); //end ready

        //разрешаем только ввод цифр
        $(document).ready(function() {
            $("input#ed-parent").keydown(function(event) {
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
            $('#result').html('<div class="loading">Обработка данных...</div>');
        }



    </script>
</div>