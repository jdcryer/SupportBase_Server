//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 01/02/19, 16:18:54
// ----------------------------------------------------
// Method: SET_TABLE_TITLES
// Description
// Created to set the table titles at start up for use by GET_TABLE_TITLES
//
// Parameters
// ----------------------------------------------------

C_COLLECTION:C1488($oc_tableTitles)
ARRAY TEXT:C222($at_tableName; 0)
ARRAY LONGINT:C221($al_tableNum; 0)
GET TABLE TITLES:C803($at_tableName; $al_tableNum)  //Not threadsafe
Use (Storage:C1525)
	$oc_tableTitles:=New shared collection:C1527
	Use ($oc_tableTitles)
		ARRAY TO COLLECTION:C1563($oc_tableTitles; $at_tableName; "tableName"\
			; $al_tableNum; "tableNum")
	End use 
	Storage:C1525.tableTitles:=$oc_tableTitles
End use 


