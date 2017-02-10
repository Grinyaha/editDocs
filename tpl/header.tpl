<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="[+manager_path+]/media/style/[+manager_theme+]/style.css" />
		<link type="text/css" rel="stylesheet" href="[+base_url+]assets/modules/editdocs/css/style.css" />
		<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>


		<script type="text/javascript" src="[+base_url+]assets/modules/editdocs/libs/sumoselect/jquery.sumoselect.min.js"></script>
		<link type="text/css" rel="stylesheet" href="[+base_url+]assets/modules/editdocs/libs/sumoselect/sumoselect.css" />

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
					<!--<h2 class="tab [+selected.promocode+]"><a href="[+moduleurl+]action=promocode"><span>Дерево</span></a></h2>
					<h2 class="tab [+selected.random+]"><a href="[+moduleurl+]action=random"><span>Генерация кодов</span></a></h2>
					-->
				</div>
