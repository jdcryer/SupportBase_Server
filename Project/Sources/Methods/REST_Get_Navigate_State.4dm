//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 24/06/22, 15:35:01
// ----------------------------------------------------
// Method: REST_Get_Navigate_State
// Description
// 
//
// Parameters
// ----------------------------------------------------

var $0; $vo_response : Object
var $vt_selectToken; $vt_currentId; $vt_action; $vt_resource : Text
var $vl_table; $vl_fia : Integer
var $vp_table : Pointer
var $es_data : 4D:C1709.EntitySelection
var $e_currentRecord; $e_data; $e_result : 4D:C1709.Entity

ARRAY TEXT:C222($at_TableName; 0)
ARRAY LONGINT:C221($al_TableNum; 0)
GET_TABLE_TITLES(->$at_TableName; ->$al_TableNum)

ARRAY TEXT:C222($at_Field; 0)
ARRAY TEXT:C222($at_Value; 0)
WEB GET VARIABLES:C683($at_Field; $at_Value)

$vl_fia:=Find in array:C230($at_Field; "selectToken")
If ($vl_fia>0)
	$vt_selectToken:=$at_Value{$vl_fia}
End if 

$vl_fia:=Find in array:C230($at_Field; "currentId")
If ($vl_fia>0)
	$vt_currentId:=$at_Value{$vl_fia}
End if 

$vl_fia:=Find in array:C230($at_Field; "resource")
If ($vl_fia>0)
	$vt_resource:=$at_Value{$vl_fia}
End if 

ARRAY TEXT:C222($at_headerField; 0)
ARRAY TEXT:C222($at_headerValue; 0)
WEB GET HTTP HEADER:C697($at_headerField; $at_headerValue)
$vl_FIA:=Find in array:C230($at_headerField; "Origin")
If ($vl_FIA>0)  //|Used for localhost Angular development
	$vb_localHost:=($at_headerValue{$vl_FIA}="http://localhost:4200@")
End if 

$vo_response:=New object:C1471

If ($vt_resource#"") & ($vt_currentId#"") & ($vt_selectToken#"")
	$vl_fia:=Find in array:C230($at_TableName; $vt_resource)
	If ($vl_fia>0)
		
		$vl_table:=$al_TableNum{$vl_fia}
		$vp_table:=Table:C252($vl_table)
		
		If ($vb_localHost)  //Section for local Angular development
			ARRAY LONGINT:C221($al_recordNumbers; 0)
			$vt_Doc_Path:=Get 4D folder:C485(Database folder:K5:14)+"webSelections"+Folder separator:K24:12
			$vt_Doc_Path:=$vt_Doc_Path+$vt_selectToken+".json"
			$vt_selectData:=Document to text:C1236($vt_Doc_Path)
			$vo_selectObject:=JSON Parse:C1218($vt_selectData; Is object:K8:27)
			OB GET ARRAY:C1229($vo_selectObject; "recordNumbers"; $al_recordNumbers)
			CREATE SELECTION FROM ARRAY:C640($vp_table->; $al_recordNumbers; $vt_selectToken)
		End if 
		USE NAMED SELECTION:C332($vt_selectToken)
		$es_data:=Create entity selection:C1512($vp_table->)
		
		$e_currentRecord:=$es_data.query("id == :1"; $vt_currentId).first()
		$vl_index:=$e_currentRecord.indexOf($es_data)
		
		$vo_response.hasNext:=True:C214
		$vo_response.hasPrev:=True:C214
		
		If ($vl_index=0)
			$vo_response.hasPrev:=False:C215
		End if 
		If ($vl_index=($es_data.length-1))
			$vo_response.hasNext:=False:C215
		End if 
		
	Else 
		$vo_response.error:="Table not found"
	End if 
Else 
	$vo_response.error:="Missing mandatory parameters"
End if 

$0:=$vo_response