Class extends EntitySelection

Function get user_client->$es_client : cs:C1710.clientSelection
	$es_client:=ds:C1482.client.query("id in :1"; This:C1470.query("tableId = 1").fk_record)
	
	
Function get user_contact->$es_contact : cs:C1710.contactSelection
	$es_contact:=ds:C1482.contact.query("id in :1"; This:C1470.query("tableId = 11").fk_record)
	
	
	