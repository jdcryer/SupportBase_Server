//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 25/11/20, 14:07:25
// ----------------------------------------------------
// Method: REST_Get_UserQueries
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)
C_OBJECT:C1216($es_publicQueries; $es_queries; $es_userQueries)
C_TEXT:C284($vt_table)
C_LONGINT:C283($vl_fia)

ARRAY TEXT:C222($at_name; 0)
ARRAY TEXT:C222($at_value; 0)

$vo_response:=New object:C1471

WEB GET VARIABLES:C683($at_name; $at_value)
$vl_fia:=Find in array:C230($at_name; "table")
If ($vl_fia>0)
	
	$vt_table:=$at_value{$vl_fia}
	
	$es_userQueries:=ds:C1482.interface.query("type == 2 && handle == :1 && fk_user == :2"; $vt_table; vo_currentUser.id)
	
	//Case of 
	//: (vt_userType="company")
	//$es_publicQueries:=ds.interface.query("type == 2 && detail.public == true && handle == :1 && interface_user.fk_company == :2"; $vt_table; vo_currentUser.fk_company)
	
	//Else 
	//$es_publicQueries:=ds.interface.newSelection()
	//End case 
	$es_publicQueries:=ds:C1482.interface.newSelection()
	
	$es_queries:=$es_publicQueries.or($es_userQueries)
	$es_queries:=$es_queries.orderBy("name asc")
	
	$vo_response.response:=$es_queries.toCollection("id, fk_user, name, handle, type, default, detail")
	
Else 
	$vo_response.error:="Table parameter is missing!"
End if 

$0:=$vo_response