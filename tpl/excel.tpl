<div id="tab-page1" class="tab-page" style="display:block;">

    <script>
        $(document).ready(function()
        {
            Dropzone.autoDiscover = false;

            $("div#fileuploader").dropzone({
                url: "/assets/modules/editdocs/ajax.php",
                paramName: "myfile",
                acceptedFiles: ".xls,.xlsx, .ods",
                dictDefaultMessage: "Перетащите сюда нужный EXCEL-файл или выберите по клику",
                init: function() {
                    this.on("success", function(file, responseText) {
                        console.log(responseText);
                        //excelTable(responseText);
                        $('#result').html(responseText);
                        $('.sending').show(0);
                    });
                }
            });



        $('body').on('click', '#process', function () {


            $("#hidf").val($('.tabres tr:nth-child(1) td:nth-child(1)').html());
            var dada = $('form#pro').serialize();

            loading();
            console.log(dada);
            $.ajax({
                type: "POST",
                url: "/assets/modules/editdocs/ajax.php",
                data: dada,
                success: function (result) {

                    $('#result').html(result);


                }

            }); //end ajax
        }); //end click

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



    <div id="fileuploader"  class="dropzone"></div>
    <br/><br/>
    <div class="sending">
        <form id="pro">
         <div class="subbat">
         <button class="btn" id="process" type="button">ПОЕХАЛИ!</button> <input type="checkbox" id="test" name="test" value="1" /> Тестовый режим (без обновления)
            <input type="hidden" name="field" value="" id="hidf" />
            <input type="hidden" name="upd" value="1" />
             <br/>
         </div>

            <div class="mess">
                <div id="warning"></div>
                <br/>
                <button id="clear" type="button" class="btn"  style="min-width: 170px" > Сбросить кэш</button>
            </div>
        </form>
        <div class="clear"></div>
        <div class="alert-ok ">Совпадения ищутся по значениям первого столбца!</div>
    </div>

    <br/><br/>
    <div id="result"></div>

</div>