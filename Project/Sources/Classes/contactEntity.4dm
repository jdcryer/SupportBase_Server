Class extends Entity

Function get contact_user->$es_user : cs:C1710.userEntity
	$es_user:=ds:C1482.user.query("fk_record == :1"; This:C1470.id)
	