<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="[+manager_path+]/media/style/[+manager_theme+]/style.css" />
		<link type="text/css" rel="stylesheet" href="[+base_url+]assets/modules/editdocs/css/style.css" />
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>


		<script type="text/javascript" src="../assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
		<link type="text/css" rel="stylesheet" href="../assets/modules/editdocs/libs/sumoselect/sumoselect.css" />

		<script type="text/javascript" src="../assets/modules/editdocs/libs/dropzone/dropzone.min.js"></script>
		<link href="../assets/modules/editdocs/libs/dropzone/dropzone.css" rel="stylesheet">



		<script>
            $.ajaxSetup({ cache: false });
		</script>
	</head>
	<body>
      <h1>[+session.itemname+]</h1>


		<div class="sectionBody">
			<div id="modulePane" class="dynamic-tab-pane-control tab-pane">
				<div class="tab-row">
					<h2 class="tab [+selected.branch+]"><a href="[+moduleurl+]action=branch"><span>Редактирование</span></a></h2>
					<h2 class="tab [+selected.excel+]"><a href="[+moduleurl+]action=excel"><span>Апдейт из Excel(Calc)</span></a></h2>
					<h2 class="tab [+selected.import+]"><a href="[+moduleurl+]action=import"><span>Импорт из Excel(Calc)</span></a></h2>

				</div>
