Class extends Entity

Function get user_client->$e_client : cs:C1710.clientEntity
	$e_client:=(This:C1470.fk_record=Null:C1517) ? Null:C1517 : ds:C1482.client.get(This:C1470.fk_record)
	
	
Function get user_contact->$e_contact : cs:C1710.contactEntity
	$e_contact:=(This:C1470.fk_record=Null:C1517) ? Null:C1517 : ds:C1482.contact.get(This:C1470.fk_record)
	
	
	