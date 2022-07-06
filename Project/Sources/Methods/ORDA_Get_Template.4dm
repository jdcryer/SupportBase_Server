//%attributes = {}
C_COLLECTION:C1488($0)
C_TEXT:C284($1; $2; $vt_types; $vt_prop)
C_OBJECT:C1216($vo_property)
C_BOOLEAN:C305($vb_cancel)
C_LONGINT:C283($type; $len)
C_BOOLEAN:C305($indexed; $unique; $invisible)
If (Count parameters:C259>1)
	$vt_types:=$2
End if 
//TRACE
$0:=New collection:C1472
For each ($vt_prop; ds:C1482[$1])
	$vb_cancel:=False:C215
	$vo_property:=ds:C1482[$1][$vt_prop]
	If ($vt_types#"")
		$vb_continue:=(Position:C15($vo_property.kind; $vt_types)>0)
	Else 
		$vb_continue:=True:C214
	End if 
	If ($vb_continue)
		Case of 
			: ($vo_property.kind="storage")
				$vo_property.filterName:=$vt_prop
				
			: ($vo_property.kind="relatedEntity")
				$vo_property.filterName:=$vt_prop+".*"
				
			: ($vo_property.kind="relatedEntities")
				$vo_property.filterName:=$vt_prop+".*"
				
			Else 
				$vb_cancel:=True:C214
		End case 
		If (Not:C34($vb_cancel))
			$vo_property.fieldName:=$vo_property.name
			$0.push($vo_property)
		End if 
	End if 
End for each 


