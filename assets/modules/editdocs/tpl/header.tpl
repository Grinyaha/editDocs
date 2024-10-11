<!DOCTYPE html>
<html>

<head>
    <link rel="stylesheet" type="text/css" href="[+manager_path+]/media/style/[+manager_theme+]/style.css" />
    <link type="text/css" rel="stylesheet" href="[+base_url+]assets/modules/editdocs/css/style.css?ass4" />
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <!--script type="text/javascript" src="[+manager_path+]/media/script/bootstrap/js/bootstrap.min.js"></script-->
    <script type="text/javascript" src="../assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
    <link type="text/css" rel="stylesheet" href="../assets/modules/editdocs/libs/sumoselect/sumoselect.css?v=1" />

    <script type="text/javascript" src="../assets/modules/editdocs/libs/uikit/js/uikit.min.js"></script>
    <script type="text/javascript" src="../assets/modules/editdocs/libs/uikit/js/uikit-icons.min.js"></script>
    <link type="text/css" rel="stylesheet" href="../assets/modules/editdocs/libs/uikit/css/uikit.min.css" />

    <script type="text/javascript" src="../assets/modules/editdocs/libs/dropzone/dropzone.min.js"></script>
    <link href="../assets/modules/editdocs/libs/dropzone/dropzone.css" rel="stylesheet">

    <script>
        $.ajaxSetup({
            cache: false
        });
    </script>

</head>

<body>
<div class="uk-margin-left uk-margin-top">
    <h3>[+session.itemname+] v2.2.6</h3>
</div>


    <div class="sectionBody">
        <div id="modulePane" class="dynamic-tab-pane-control tab-pane">
            <div class="tab-row">
                <h2 class="tab [+selected.branch+]"><a href="[+moduleurl+]action=branch"><span>[+lang.editing+]</span></a></h2>
                <h2 class="tab [+selected.import+]"><a href="[+moduleurl+]action=import"><span>[+lang.import+] (Excel/Calc/CSV)</span></a></h2>
                <h2 class="tab [+selected.export+]"><a href="[+moduleurl+]action=export"><span>[+lang.export+] (XLS/CSV)</span></a></h2>
                <h2 class="tab [+selected.mass+]"><a href="[+moduleurl+]action=mass"><span>[+lang.mass+]</span></a></h2>
            </div>
