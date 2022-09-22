<div id="tab-page1" class="tab-page" style="display:block;">
    <form id="export-form">

        <input type="hidden" name="export" value="1" />

        <div>
            <div class="parf">
                <div class="parf">
                    ID [+lang.parent+]<br/>
                    <input type="number" min="0" name="stparent" id="stparent" class="inp" style="width: 70px"/>

                    <br/><br/>
                </div>
                <div class="parf">
                    [+lang.level+]<br/>

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
                    [+lang.delimiter+]:<br>
                    <input type="text" name="dm" class="inp" style="width: 40px" maxlength="1" value=";"/>
                </div>

                <div class="parf">
                    [+lang.filtertv+] (DocLister)</br>
                    <input type="text" name="filters" id="filters" class="inp" style="width: 200px" placeholder="[+lang.example+] tv:ves:>:1"/>
                    <i class="fa fa-question-circle fa-lg" data-toggle="tooltip" data-placement="right" title="[+lang.dltext+] tv:ves:>:1"></i>
                </div>

                <div class="parf">
                    [+lang.filterdef+]</br>
                    <input type="text" name="addwhere" id="addwhere" class="inp" style="width: 200px" placeholder="[+lang.example+] c.template=2"/>
                    <i class="fa fa-question-circle fa-lg" data-toggle="tooltip" data-placement="right" title="[+lang.sqltext+] c.template=2" ></i>
                </div>
                <div class="parf">
                    <a href="https://docs.evo.im/04_extras/doclister/04_filters.html" target="_blank"><br/>[+lang.docfilters+] DocLister</a>
                </div>

                <div class="clear"></div>

                <div class="parf">

                    <input type="checkbox" name="win" value="1" [+checked+]/> [+lang.kodirovka+]<br/>
                    <input type="checkbox" name="neopub" value="1"/> [+lang.unpubl+] <br>
                    <input type="checkbox" name="export_mc" value="1"/> [+lang.export_mc+]
                </div>

                <div class="clear"></div>
                <br>

                <div class="sumosize">
                    [+lang.fields+] <br/>
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

                <div class="subbat">
                    <button id="brsub" type="button" class="btn btn-success"><i class="fa fa-check"></i>  [+lang.start_export+]</button>

                </div>

                <div class="clear"></div>

                <div class="alert-ok">
                    <b>[+lang.atention+]</b><br/>
                    [+lang.iconv+]<br>
                    [+lang.url+]
                </div>

            </div>

            <div class="mess">
                <div id="warning"></div>
                <br />
                <button id="clear" type="button" class="btn btn-info"><i class="fa fa-gavel"></i> [+lang.clearcache+]</button>
            </div>

            <br />

            <div class="clear"></div>

        </div>

    </form>
    <br /><br />
    <div id="result_progress"></div>
    <div id="result"></div>





    <script type="text/javascript" src="[+base_url+]assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
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
                locale :  ['OK', 'Cancel', '[+lang.select_all+]']
            });
            $('#ed-tree').SumoSelect();


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
                        if(resp[1]==0) {
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
                    }
                }); //end ajax
            }





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


        }); //end ready


        function loading() {
            $('#result').html('<div class="loading">[+lang.obrabotka+]...</div>');
        }



    </script>
</div>
