//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 01/02/19, 16:17:00
// ----------------------------------------------------
// Method: GET_TABLE_TITLES
// Description
// Method created as threadsafe alternative to GET TABLE TITLES
// Requires SET_TABLE_TITLES to be called at startup or prior to use.
//
// Parameters
// ----------------------------------------------------

C_POINTER:C301($1; $2)
C_LONGINT:C283($cp)
ARRAY TEXT:C222($at_tableName; 0)
ARRAY LONGINT:C221($al_tableNum; 0)
$cp:=Count parameters:C259
COLLECTION TO ARRAY:C1562(Storage:C1525.tableTitles; $at_tableName; "tableName"\
; $al_tableNum; "tableNum")

COPY ARRAY:C226($at_tableName; $1->)
If ($cp>1)
	COPY ARRAY:C226($al_tableNum; $2->)
End if 
