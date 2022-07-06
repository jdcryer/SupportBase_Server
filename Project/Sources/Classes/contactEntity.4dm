Class extends Entity

Function get contact_user->$e_user : cs:C1710.userEntity
	$e_user:=ds:C1482.user.query("fk_record == :1"; This:C1470.id).first()
	