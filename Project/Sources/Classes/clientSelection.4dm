Class extends EntitySelection

Function get client_user->$es_user : cs:C1710.userSelection
	$es_user:=ds:C1482.user.query("fk_record in :1"; This:C1470.id)
	