//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 13/07/20, 10:14:23
// ----------------------------------------------------
// Method: REST_Put_Generic
// Description
// Modelled off of REST_Put_Brand
// 
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $1; $vo_data; $es_records; $e_record; $vo_prop; $vo_status; $vo_detail)
C_LONGINT:C283($2; $vl_table; $vl_variantCount)
C_COLLECTION:C1488($vc_template; $vc_variants)
C_LONGINT:C283($i; $vl_FIA; $vl_Type)
C_TEXT:C284($vt_Variable; $vt_tableName; $vt_field; $vt_password)
C_BOOLEAN:C305($vb_Continue)
ARRAY TEXT:C222($at_Fields; 0)
ARRAY TEXT:C222($at_Template_Fields; 0)

$vo_data:=OB Copy:C1225($1)
$vl_table:=$2
$vt_tableName:=Table name:C256($vl_table)
If (OB Is defined:C1231($vo_data; "id"))
	$es_records:=ds:C1482[$vt_tableName].query("id == :1"; $vo_data.id)
	$vl_Type:=Num:C11($es_records.length=1)
	$e_record:=$es_records.first()
Else 
	$e_record:=ds:C1482[$vt_tableName].new()
	$vl_Type:=2
End if 
If ($vl_Type=2)
	$e_record.id:=Generate UUID:C1066
End if 
If ($vl_Type>0)
	$vc_template:=ORDA_Get_Template($vt_tableName)
	OB GET PROPERTY NAMES:C1232($vo_data; $at_Fields)
	For ($i; 1; Size of array:C274($at_Fields))
		Case of 
			: ($vt_tableName="user") & ($at_Fields{$i}="detail")
				$vo_detail:=$vo_data.detail
				If (OB Is defined:C1231($vo_detail; "newpassword"))
					$vt_password:=NTK HMAC Text(Storage:C1525.namak.prefix+$vo_detail.newpassword; "SHA512"; Storage:C1525.namak.key)
					$vo_detail.password:=$vt_password
					$e_record.password:=$vt_password  //Put password in the password field
					OB REMOVE:C1226($vo_detail; "newpassword")  //remove new password from the detail
				End if 
				$e_record.detail:=OB Copy:C1225($vo_detail)  //Update the detail as there may be other properties in there.
				
			Else 
				$vl_index:=$vc_template.findIndex("UTIL_Find_Collection_String"; "fieldName"; $at_Fields{$i})
				If ($vl_index>-1)
					$vt_Field:=$vc_template[$vl_index].fieldName  //OB Get($vo_Template;$at_Template_Fields{$vl_FIA})
					$e_record[$vt_Field]:=$vo_data[$at_Fields{$i}]
				End if 
		End case 
	End for 
	$vo_status:=$e_record.save()
	Case of 
		: ($vo_status.success)  //Record saved
			$vo_data:=$e_record.toObject()
			
		Else   //: ($vo_status.status=dk status locked)
			$vo_data:=New object:C1471
			$vo_data.error:=$vo_status.statusText
	End case 
	
Else 
	$vo_data:=New object:C1471
	$vo_data.error:="Update failed.  Record not found."
End if 

$0:=OB Copy:C1225($vo_data)