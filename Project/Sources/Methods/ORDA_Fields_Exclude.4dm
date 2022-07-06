//%attributes = {}

// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 31/08/17, 16:27:39
// ----------------------------------------------------
// Method: ORDA_Fields_Exclude(->$vo_Template;->$at_Field;->$at_Value;"SKUSize") -> ItemsBoolean
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($vo_template; $vo_fullTemplate)
C_COLLECTION:C1488($0; $1; $vc_Template; $2; $vc_fullTemplate)
C_COLLECTION:C1488($vc_restricted; $vc_newTemplate; $vc_relateTemplate)
C_POINTER:C301($3; $4)
C_TEXT:C284($5; $vt_restricted)
C_LONGINT:C283($vl_index)
ARRAY TEXT:C222($at_Properties; 0)
ARRAY TEXT:C222($at_Field_List; 0)
ARRAY TEXT:C222($at_Value_List; 0)
$vc_Template:=$1
$vc_fullTemplate:=$2
COPY ARRAY:C226($3->; $at_Field_List)
COPY ARRAY:C226($4->; $at_Value_List)
COLLECTION TO ARRAY:C1562($vc_Template; $at_Properties; "filterName")
ARRAY TEXT:C222($at_Required; 0)
CSV_PARSE_RECORD(->$at_Required; $5)
//TRACE
$vc_restricted:=New collection:C1472("@_user.password"; "password")

//******* FIELDS TO INCLUDE *******
$vl_FIA:=Find in array:C230($at_Field_List; "fields")
If ($vl_FIA>0)
	ARRAY TEXT:C222($at_Field; 0)
	CSV_PARSE_RECORD(->$at_Field; $at_Value_List{$vl_FIA})
	
	$vl_FIA_Ast:=Find in array:C230($at_Field; "*")
	If ($vl_FIA_Ast=-1)
		//Loop through properties and remove any non mandatory fields not in list.
		For ($i; 1; Size of array:C274($at_Properties))
			If (Find in array:C230($at_Required; $at_Properties{$i})=-1) & (Find in array:C230($at_Field; $at_Properties{$i})=-1)  //& ($at_Properties{$i}#"SKUSize")
				$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "filterName"; $at_Properties{$i})
				$vc_Template.remove($vl_index)
			End if 
		End for 
	End if 
	
	For ($i; 1; Size of array:C274($at_Field))
		If ($at_Field{$i}="@*")
			$vc_Template.push(New object:C1471("filterName"; $at_Field{$i}))
		Else 
			$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "filterName"; $at_Field{$i})
			If ($vl_index=-1)
				$vl_index:=$vc_fullTemplate.findIndex("UTIL_Find_Collection_String"; "filterName"; $at_Field{$i})
				If ($vl_index>=0)
					$vc_Template.push($vc_fullTemplate[$vl_index])
				End if 
			End if 
		End if 
	End for 
	
End if 
//******* END FIELDS TO INCLUDE *******

//Extract individual template elements for related tables
$vc_newTemplate:=New collection:C1472
For each ($vo_template; $vc_Template)
	If ($vo_template.filterName="@*")
		$vt_relation:=Substring:C12($vo_template.filterName; 1; Length:C16($vo_template.filterName)-2)
		$vc_relateTemplate:=$vc_fullTemplate.query("relation == :1"; $vt_relation)
		For each ($vo_fullTemplate; $vc_relateTemplate)
			$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "filterName"; $vo_fullTemplate.filterName)
			If ($vl_index=-1)
				$vc_newTemplate.push($vo_fullTemplate)
			End if 
		End for each 
	Else 
		$vc_newTemplate.push($vo_template)
	End if 
End for each 
$vc_Template:=$vc_newTemplate

//Remove retricted properties
For each ($vt_restricted; $vc_restricted)
	Repeat 
		$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "filterName"; $vt_restricted)
		If ($vl_index>=0)
			$vc_Template.remove($vl_index)
		End if 
	Until ($vl_index=-1)
End for each 

//******* EXCLUDE ATTRIBUTES *******
$vl_FIA:=Find in array:C230($at_Field_List; "exclude")
ARRAY TEXT:C222($at_Exclude; 0)
If ($vl_FIA>0)
	
	CSV_PARSE_RECORD(->$at_Exclude; $at_Value_List{$vl_FIA})
	For ($i; 1; Size of array:C274($at_Exclude))
		$vl_FIA_Exclude:=0
		$vl_Pos:=1
		Repeat 
			$vl_FIA_Exclude:=Find in array:C230($at_Properties; $at_Exclude{$i}; ($vl_Pos))
			If ($vl_FIA_Exclude>0)
				If (Find in array:C230($at_Required; $at_Properties{$vl_FIA_Exclude})=-1)
					$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "filterName"; $at_Properties{$vl_FIA_Exclude})
					$vc_Template.remove($vl_index)
				End if 
			End if 
			$vl_Pos:=$vl_FIA_Exclude+1
		Until ($vl_FIA_Exclude<0) | ($vl_FIA_Exclude=Size of array:C274($at_Properties))
	End for 
End if 
//******* END EXCLUDE ATTRIBUTES *******
$0:=$vc_Template