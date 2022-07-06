//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 10/09/20, 15:46:47
// ----------------------------------------------------
// Method: ORDA_Get_View_Template
// Description
// Generates Template for the given View
//
// Parameters
// $0 - Collection - Template
// $1 - String     - Resource Name
// $2 - String     - View UUID
// ----------------------------------------------------

C_COLLECTION:C1488($0; $vc_template)
C_TEXT:C284($1; $vt_resource; $2; $vt_viewId; $vt_prop)

C_OBJECT:C1216($e_view; $vo_property)

$vc_template:=New collection:C1472
$vt_resource:=$1
$vt_viewId:=$2

$e_view:=ds:C1482.interface.get($vt_viewId)
If ($e_view#Null:C1517)
	//Include all top level properties.
	//Values may be required by actions / prints, but not in view
	
	For each ($vt_prop; ds:C1482[$vt_resource])
		$vo_property:=ds:C1482[$vt_resource][$vt_prop]
		If ($vo_property.kind="storage")
			$vo_property.filterName:=$vt_prop
			$vc_template.push($vo_property)
		End if 
	End for each 
	
	//Loop view datafields and add any mapped values
	For each ($vo_datafield; $e_view.detail.datafields)
		If (OB Is defined:C1231($vo_datafield; "map"))
			$vc_template.push(New object:C1471("filterName"; $vo_datafield.map))
		End if 
	End for each 
End if 
$0:=$vc_template