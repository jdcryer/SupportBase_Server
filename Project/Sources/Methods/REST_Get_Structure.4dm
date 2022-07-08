//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 08/07/22, 11:27:46
// ----------------------------------------------------
// Method: REST_Get_Structure
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)
C_OBJECT:C1216($vo_table)
C_LONGINT:C283($vl_fia; $i)
C_BOOLEAN:C305($vb_continue)
C_TEXT:C284($vt_tables)
C_COLLECTION:C1488($vc_tables)

ARRAY TEXT:C222($at_name; 0)
ARRAY TEXT:C222($at_value; 0)
WEB GET VARIABLES:C683($at_name; $at_value)

$vc_tables:=New collection:C1472

$vl_fia:=Find in array:C230($at_name; "tables")
If ($vl_fia>=0)
	$vt_tables:=$at_value{$vl_fia}
	$vc_tables:=CSV_PARSE_RECORD_COL($vt_tables)
End if 


$vo_response:=New object:C1471
$vo_response.tables:=New collection:C1472

ARRAY TEXT:C222($at_tableName; 0)
ARRAY LONGINT:C221($al_tableNum; 0)

GET_TABLE_TITLES(->$at_tableName; ->$al_tableNum)

For ($i; 1; Size of array:C274($at_tableName))
	$vb_continue:=True:C214
	If ($vc_tables.length>0)
		$vb_continue:=($vc_tables.indexOf($at_tableName{$i})>=0)
	End if 
	If ($vb_continue)
		
		$vo_table:=New object:C1471
		$vo_table.tableName:=$at_tableName{$i}
		$vo_table.tableNum:=$al_tableNum{$i}
		
		$vo_table.fields:=ORDA_Get_Template($at_tableName{$i}; "storage")
		
		$vo_response.tables.push(OB Copy:C1225($vo_table))
	End if 
End for 

$0:=$vo_response
