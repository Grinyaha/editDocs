<div id="tab-page1" class="tab-page" style="display:block; max-width: 1600px">
    <form id="mass-form">
        <input type="hidden" name="mass" value="1"/>


        <div class="uk-grid-divider uk-child-width-1-2@m" uk-grid>
            <div column="1">
                <div class=""><h3>[+lang.req_params+]</h3></div>

                <div class="">
                    [+lang.movefrom+] <br>
                    <input type="number" min="0" name="parent1" class="inp" style="width: 120px;margin-bottom:2px"/>

                </div>
                <div class="uk-margin-small-top">
                    [+lang.moveto+] <br>
                    <input type="number" min="0" name="parent2" class="inp" style="width: 120px"/>
                </div>
                <br>

            </div>
            <div column="2">
                <div class=""><h3>[+lang.clearcache+]</h3></div>
                <div class="uk-margin-top">
                    <button id="clear" type="button" class="btn btn-info"><span uk-icon="icon: refresh"></span> [+lang.clearcache+]
                    </button>
                </div>
                <div class="uk-margin-top uk-width-medium">
                    <div id="warning" class="warning2"></div>
                </div>
            </div>


        </div>


        <div class="subbat">
            <button id="brsub" type="button" class="btn btn-success btn-lg"><i class="fa fa-check"></i> [+lang.massmove+]
            </button>

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
            var data = 'parent1=' + parent1 + '&parent2=' + parent2;
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

                    calert('[+lang.cache_cleared+]!');
                    top.mainMenu.reloadtree();
                }

            }); //end ajax
        }); //end click

        //Custom Alert
        function calert(text) {
            $('#warning').html('<div class="alert alert-success ahtung">' + text + '</div>');
            setTimeout(function () {
                $('.ahtung').fadeOut();
            }, 3000);
        }

    });

</script>
