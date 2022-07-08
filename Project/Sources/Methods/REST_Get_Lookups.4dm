//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 08/07/22, 15:35:35
// ----------------------------------------------------
// Method: REST_Get_Lookups
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)

C_TEXT:C284($vt_clientId; $vt_list)
C_LONGINT:C283($vl_fia; $vl_fieldNum; $vl_index; $vl_tableNum)
C_COLLECTION:C1488($vc_breakdown; $vc_lists; $vc_template)

ARRAY TEXT:C222($at_name; 0)
ARRAY TEXT:C222($at_value; 0)

WEB GET VARIABLES:C683($at_name; $at_value)

ARRAY TEXT:C222($at_tableName; 0)
ARRAY LONGINT:C221($al_tableNum; 0)
GET_TABLE_TITLES(->$at_tableName; ->$al_tableNum)

$vo_response:=New object:C1471

$vl_fia:=Find in array:C230($at_name; "list")
If ($vl_fia>0)
	
	$e_user:=ds:C1482.user.get(vo_currentUser.id)
	If ($e_user.tableId=1)
		$vt_clientId:=$e_user.fk_record
	Else 
		$vt_clientId:=$e_user.user_contact.contact_company.fk_client
	End if 
	
	$vc_lists:=CSV_PARSE_RECORD_COL($at_value{$vl_fia})
	
	For each ($vt_list; $vc_lists)
		
		$vc_breakdown:=CSV_PARSE_RECORD_COL($vt_list; Character code:C91(";"))
		
		If ($vc_breakdown.length=2)
			$vl_tableNum:=0
			$vl_fieldNum:=0
			
			$vl_fia:=Find in array:C230($at_tableName; $vc_breakdown[0])
			If ($vl_fia>=0)
				$vl_tableNum:=$al_tableNum{$vl_fia}
			End if 
			
			$vc_template:=ORDA_Get_Template($vc_breakdown[0]; "storage")
			
			$vl_index:=$vc_template.findIndex("UTIL_Find_Collection"; "name"; $vc_breakdown[1])
			If ($vl_index>=0)
				$vl_fieldNum:=$vc_template[$vl_index].fieldNumber
			End if 
			
			$e_lookupMapping:=ds:C1482.lookupMapping.query("lookupMapping_lookupList.fk_client == :1 && tableNum == :2 && fieldNum == :3"; $vt_clientId; $vl_tableNum; $vl_fieldNum).first()
			
			If ($e_lookupMapping#Null:C1517)
				
				$vo_response[$vc_breakdown[0]+"_"+$vc_breakdown[1]]:=$e_lookupMapping.lookupMapping_lookupList.detail.values
				
			Else 
				$vo_response[$vc_breakdown[0]+"_"+$vc_breakdown[1]]:=New collection:C1472
			End if 
			
		End if 
		
	End for each 
	
End if 

$0:=$vo_response
