<div id="tab-page1" class="tab-page" style="display:block;">
    <form  id="mass-form">
        <input type="hidden" name="mass" value="1" />
        <input type="text" name="parent1" class="inp" style="width: 70px;margin-bottom:2px"/> ID родителя ОТКУДА все переносим<br/>
        <input type="text" name="parent2" class="inp" style="width: 70px"/> ID родителя КУДА все переносим
        <div class="clear"></div>
        <div class="subbat">
            <button id="brsub" type="button" class="btn btn-success"><i class="fa fa-check"></i>  ПЕРЕНЕСТИ</button>

        </div>
        <div class="mess">
            <br/>
            <button id="clear" type="button" class="btn btn-info"  style="min-width: 170px" ><i class="fa fa-gavel"></i> Сбросить кэш</button>
        </div>
    </form>
    <div class="clear"></div>
    <br/>
    <div id="result"></div>
</div>

<script>
    $(document).ready(function () {
        $('body').on('click', '#brsub, .page', function () {

            var parent1 = $('#mass-form input[name=parent1]').val();
            var parent2 = $('#mass-form input[name=parent2]').val();
            var data = 'parent1='+parent1+'&parent2='+parent2;
            $.ajax({
                type: "POST",
                url: "[+base_url+]assets/modules/editdocs/ajax.php",
                data: data,
                success: function (result) {

                   $('#result').html(result);

                }
        }); //end ajax
    }); //end click

        $('body').on('click', '#clear', function () {

            $.ajax({
                type: "POST",
                url: "[+base_url+]assets/modules/editdocs/ajax.php",
                data: "clear=1",
                success: function (result) {

                    $('#warning').html(result);
                    top.mainMenu.reloadtree();
                }

            }); //end ajax
        }); //end click

    });

    //разрешаем только ввод цифр
    $(document).ready(function() {
        $(".inp").keydown(function(event) {
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
</script>