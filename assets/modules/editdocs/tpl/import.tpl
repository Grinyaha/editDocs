<div id="tab-page1" class="tab-page" style="display:block;">

    <script>
        $(document).ready(function () {



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
                        $('.sending').show(0);

                        console.log(responseText[4]);

                        if(responseText[4] != undefined) columns = responseText[4].split('=='); else columns = false;
                        exp = responseText[3].split('||');

                        //console.log(columns[0]);

                        $('#sravxls').html('');
                        $('#sravxls').append('<option value=""></option>');

                        exp.forEach(function(entry) {
                            $('#sravxls').append('<option value="'+entry+'">'+entry+'</option>');
                        });


                        $('#sravxls').SumoSelect({
                            placeholder: 'select fields',
                            search: true,
                            searchText: '[+lang.fieldxls+]'
                        });

                        if(columns) {

                            $('#sravxls').val(columns[1]);
                            $('#checktv').val(columns[0]);
                        }

                        $('#sravxls')[0].sumo.reload();
                        $('#checktv')[0].sumo.reload();


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
                //console.log(dada);
                $.ajax({
                    type: "POST",
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: dada,
                    success: function (result) {
                        if(result.indexOf('#@') !== -1) { //если ответ не содержит |, а сообщение
                            resp = result.split("#@");
                            $('#result').html(resp[2]);
                            //console.log(result);
                            if (parseInt(resp[0], 10) < parseInt(resp[1], 10)) {
                                $("#result_progress").html("<b>[+lang.impord+] " + resp[0] + " [+lang.of+] " + resp[1] + "</b>");

                                dada = $('form#pro:not([name="unpub"])').serialize();
                                makeProgress(dada);
                            } else {
                                $("#result_progress").html("<b>[+lang.impord+] " + resp[0] + " [+lang.of+] " + resp[1] + ". [+lang.gotovo+]</b>");
                                //подчищаем сессии
                                $.ajax({
                                    type: "POST",
                                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                                    data: 'cls=1',//clear session_start
                                    success: function (res) {
                                        //console.log(res);
                                    }
                                });
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
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: "clear=1",
                    success: function (result) {

                        $('#warning').html(result);
                        top.mainMenu.reloadtree();


                    }

                }); //end ajax
            }); //end click


        });

        function loading() {
            $('#result').html('<div class="loading">[+lang.obrabotka+]...</div>');
        }

    </script>

    <div class="alert alert-success">
        <p> <b>[+lang.atention+]</b><br /> </p>

        [+lang.needtitle+] <b>pagetitle</b><br><br>

        [+lang.foradd+]<br><br>

        [+lang.impcsv+]<br><br>

        [+lang.idparent+]





    </div>

    <div id="fileuploader" class="dropzone"></div>
    <br /><br />
    <div class="sending">
        <form id="pro">
            <div class="parf">
                ID [+lang.parent+]<br />
                <input type="number" min="0" name="parimp" id="parent" class="inp" style="width: 70px" />
            </div>
            <div class="parf" style="width: 300px">
                [+lang.tpl+]<br />

                <select id="tpl" name="tpl">
                    <option selected="selected" value="file">[+lang.fromfile+]</option>
                    [+tpl+]
                    <option value="blank">(blank) [+lang.nontpl+]</option>
                </select>
            </div>
            <div class="parf">
                [+lang.checkfield+]<br />
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

            <div class="parf">
                [+lang.srav_field+] <br>

                <!--input type="text" name="checktv2" style="width: 200px" class="inp" placeholder=""-->
                <select name="checktv2" id="sravxls" class=""></select>

            </div>


            <div class="clear"></div>
            <br>

            <div class="parf" style="width: 200px">
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


            <div class="parf">
                [+lang.entry+]<br />
                <input type="text" name="needle" class="inp" style="width: 200px" />
            </div>
            <div class="parf">
                [+lang.replace+]<br />
                <input type="text" name="replacement" class="inp" style="width: 200px" />
            </div>


            <div class="clear"></div>
            <br>

            <div class="parf">
                [+lang.makeunpub+]<br>
                <select id="tpls" name="unpub" multiple>

                    [+tpl+]
                    <option value="blank">(blank) [+lang.nontpl+]</option>
                </select>
            </div>

            <div class="clear"></div>
            <br>

            <label class="form-check-label">
                &nbsp;&nbsp;<input type="checkbox" id="notadd" name="notadd" value="1" class="form-check-input" /> [+lang.noadd+]
            </label>
            <br>
            <label class="form-check-label">
                &nbsp;&nbsp;<input type="checkbox" id="test" name="test" value="1" class="form-check-input" /> [+lang.testmode+]
            </label>
            <br>
            <label class="form-check-label">
                &nbsp;&nbsp;<input type="checkbox" name="multi" value="1" class="form-check-input" /> [+lang.impformc+]
            </label>
            <br><br>

            <div class="">
                <button class="btn btn-success" id="process" type="button"><i class="fa fa-check"></i> [+lang.startimport+]</button>

            </div>

            <div class="mess">
                <div id="warning"></div>
                <br />
                <button id="clear" type="button" class="btn btn-info"><i class="fa fa-gavel"></i> [+lang.clearcache+]</button>
            </div>
            <input type="hidden" name="imp" value="1" />
            <br />
        </form>
        <div class="clear"></div>
    </div>

    <br /><br />
    <div id="result_progress"></div>
    <div id="result"></div>


</div>