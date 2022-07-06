//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 28/02/18, 15:08:13
// ----------------------------------------------------
// Method: ORDA_Get_Property_List
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($vt_case; $vt_varName; $vt_types)
C_OBJECT:C1216($0; $vo_response; $vo_template)
C_COLLECTION:C1488($vc_template)
C_LONGINT:C283($vl_tableNum; $vl_fieldNum; $vl_type; $vl_length; $vl_fiaTypes)
C_BOOLEAN:C305($vb_notFound; $vb_indexed; $vb_unique; $vb_invisible)
C_POINTER:C301($vp_Field)
ARRAY TEXT:C222($at_properties; 0)
ARRAY TEXT:C222($at_name; 0)
ARRAY TEXT:C222($at_value; 0)
$vo_response:=New object:C1471

WEB GET VARIABLES:C683($at_name; $at_value)
$vl_FIA:=Find in array:C230($at_name; "table")
If ($vl_FIA>0)
	$vl_fiaTypes:=Find in array:C230($at_name; "types")
	If ($vl_fiaTypes>0)
		$vt_types:=$at_value{$vl_fiaTypes}
	End if 
	$vt_case:=$at_value{$vl_FIA}
	$vc_template:=ORDA_Get_Template($vt_case; $vt_types)
Else 
	$vb_notFound:=True:C214
End if 
//TRACE
If (Not:C34($vb_notFound))
	$vo_response.fields:=New collection:C1472
	$vo_response.fields:=$vc_template
Else 
	$vo_response.Error:="Table not found"
	$vo_response.htmlResponseCode:="404 Not Found"
End if 
$0:=$vo_response
