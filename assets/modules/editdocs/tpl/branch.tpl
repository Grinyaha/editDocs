<div id="tab-page1" class="tab-page" style="display:block;">
    <form id="branch">


        <div>
            <div class="parf">
                <div class="parf">
                    ID [+lang.parent+]<br/>
                    <input type="number" min="0" name="bigparent" class="inp" style="width: 70px"/>
                    <input type="hidden" name="edit" value="1" />

                    <br/><br/>
                </div>
                <div class="parf">
                    [+lang.level+]<br/>

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
                    [+lang.tvimage+]<br/>

                    <input type="text" name="tvpic" id="" class="inp" style="width: 120px"/>
                </div>

                <div class="parf">

                        [+lang.sorting+] <br/>
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

                <div class="parf">
                    [+lang.direction+] <br>
                    <select id="orderas" name="orderas">
                        <option value="desc" selected="selected"> [+lang.desc+] (DESC)</option>
                        <option value="asc">[+lang.asc+] (ASC)</option>
                    </select>
                </div>

                 <div class="clear"></div>

                <div class="parf">
                <div class="sumosize">
                    [+lang.fields+] <br/>
                     <select id="selfil" name="fields[]" multiple="multiple">
                        <optgroup label="[+lang.deffields+]">
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

                        <optgroup label="[+lang.tvoptions+]">
                            [+tvs+]
                        </optgroup>

                    </select>
                </div>
                </div>
                <div class="parf">
                    [+lang.filtertv+] (DocLister)</br>
                    <input type="text" name="filters" id="filters" class="inp" style="width: 200px"  placeholder="[+lang.example+] tv:ves:>:1"/>
                    <i class="fa fa-question-circle fa-lg" title="[+lang.dltext+] tv:ves:>:1"></i>
                </div>

                <div class="parf">
                    [+lang.filterdef+]</br>
                    <input type="text" name="addwhere" id="addwhere" class="inp" style="width: 200px"  placeholder="[+lang.example+] c.template=2"/>
                    <i class="fa fa-question-circle fa-lg" title="[+lang.sqltext+] c.template=2"></i>
                </div>
                <div class="parf">
                    <a href="https://docs.evo.im/04_extras/doclister/04_filters.html" target="_blank"><br/>[+lang.docfilters+] DocLister</a>
                </div>

                <div class="clear"></div>

                <br/>

                <div class="">

                    <div class="row">
                        <div class="col-md-2">
                            <label class="form-check-label">
                                &nbsp; &nbsp; &nbsp; <input class="form-check-input" type="checkbox" name="rendertv" value="1"/> [+lang.rendertv+] <br/>
                            </label>
                            <div class="clear"></div>
                            <label class="form-check-label">
                                &nbsp; &nbsp; &nbsp; <input class="form-check-input" type="checkbox" name="paginat" value="1"/> [+lang.pagination+] <br/>
                            </label>
                        </div>
                        <div class="col-md-10">
                            <label class="form-check-label">
                                &nbsp; &nbsp; &nbsp; <input class="form-check-input" type="checkbox" name="neopub" value="1"/> [+lang.unpubl+]
                            </label>
                            <div class="clear"></div>
                            <label class="form-check-label">
                                &nbsp; &nbsp; &nbsp; <input type="checkbox" name="multed" value="1" class="form-check-input" /> <b>category</b> [+lang.for+] MultiCategories
                            </label>
                        </div>

                    </div>




                </div>

                <br/>

                <div class="subbat">
                    <button id="brsub" type="button" class="btn btn-success" work="edit"><i class="fa fa-check"></i> [+lang.submit+]</button>
                </div>

                <div class="clear"></div>

            </div>
            <div class="mess">
                <br/>
                <button id="clear" type="button" class="btn btn-info"  style="min-width: 170px" ><i class="fa fa-gavel"></i> [+lang.clearcache+]</button>
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
                placeholder: '[+lang.selfields+]...',
                captionFormat: '{0} [+lang.selected+]',
                csvDispCount: 2,
                search: true,
                searchText: '[+lang.fieldortv+]',
                selectAll: true,
                locale :  ['OK', 'Cancel', '[+lang.select_all+]']
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
                    url: "[+base_url+]assets/modules/editdocs/ajax.php"+lpage,
                    data: data,
                    success: function (result) {

                        //console.log(result);
                        $('#result').html(result);

                        $('select.sumochb, select.sumosel').SumoSelect({
                            placeholder: '[+lang.nothing+]...',
                            captionFormat: '{0} [+lang.selected+]',
                            csvDispCount: 2
                        });


                    },
                    error: function(xhr, ajaxOptions, thrownError) {
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
                if(check) dat = dat.join('||');
                //console.log(dat);

                $.ajax({
                    type: "POST",
                    async: false,
                    url: "[+base_url+]assets/modules/editdocs/ajax.php",
                    data: "pole="+pole+"&id="+id+"&dat="+dat,
                    success: function (result) {

                        $('#warning').html('<div class="alert alert-success">'+result+'</div>');
                        setTimeout(function(){
                            $('.alert').fadeOut();
                        }, 3000);

                    },
                    error: function(xhr, ajaxOptions, thrownError) {

                        $('#warning').html('<div class="alert alert-danger">[+lang.error+]</div>');

                        setTimeout(function(){
                            $('.alert').fadeOut();
                        }, 3000);

                    }

                }); //end ajax
            }); //end blur


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
