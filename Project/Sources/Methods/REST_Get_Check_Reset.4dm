//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 18/08/20, 15:55:14
// ----------------------------------------------------
// Method: REST_Get_Check_Reset
// Description
// Checks if a given resetUUID is still valid
//
// Parameters
// $0 - Object - Response
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)
C_OBJECT:C1216($e_user)
C_TEXT:C284($vt_id)
C_LONGINT:C283($vl_fia)

ARRAY TEXT:C222($at_field; 0)
ARRAY TEXT:C222($at_value; 0)

$vo_response:=New object:C1471

WEB GET VARIABLES:C683($at_field; $at_value)

$vl_fia:=Find in array:C230($at_field; "v")
If ($vl_fia>0)
	$vt_id:=$at_value{$vl_fia}
	
	$e_user:=ds:C1482.user.query("detail.reset.uuid == :1"; $vt_id).first()
	If ($e_user#Null:C1517)
		If (String:C10(Current date:C33; ISO date:K1:8; Current time:C178)<$e_user.detail.reset.timeout)
			$vo_response.success:=True:C214
		Else 
			$vo_response.error:="No longer valid"
		End if 
	Else 
		$vo_response.error:="No longer valid"
	End if 
Else 
	$vo_response.error:="Reset ID not passed"
End if 
$0:=$vo_response
