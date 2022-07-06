//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 04/09/20, 15:11:34
// ----------------------------------------------------
// Method: ORDA_Get_Template_Rec
// Description
// 
//
// Parameters
// $0 - Collection - Collection of template elements
// $1 - String     - Target Data Class, e.g. 'variant'
// $2 - String     - Filter relation, e.g. 'stock_variant'
// ----------------------------------------------------

C_COLLECTION:C1488($0; $vc_template)
C_TEXT:C284($1; $vt_class; $2; $vt_relation; $vt_prop)
C_BOOLEAN:C305($3; $vb_allowMany)

$vc_template:=New collection:C1472
$vt_class:=$1
If (Count parameters:C259>1)
	$vt_relation:=$2
	If (Count parameters:C259>2)
		$vb_allowMany:=$3
	End if 
End if 

//TRACE

For each ($vt_prop; ds:C1482[$vt_class])
	$vo_prop:=ds:C1482[$vt_class][$vt_prop]
	
	Case of 
		: ($vo_prop.kind="storage")
			$vo_prop.relation:=$vt_relation
			If ($vt_relation#"")
				$vo_prop.filterName:=$vt_relation+"."+$vt_prop
			Else 
				$vo_prop.filterName:=$vt_prop
			End if 
			$vc_template.push(OB Copy:C1225($vo_prop))
			
		: ($vo_prop.kind="relatedEntity")
			$vo_prop.relation:=$vt_relation
			If ($vt_relation#"")
				$vt_tempRelation:=$vt_relation+"."+$vo_prop.name
			Else 
				$vt_tempRelation:=$vo_prop.name
			End if 
			$vc_template:=$vc_template.concat(ORDA_Get_Template_Rec($vo_prop.relatedDataClass; $vt_tempRelation))
			
		: ($vo_prop.kind="relatedEntities") & ($vb_allowMany)
			$vo_prop.relation:=$vt_relation
			If ($vt_relation#"")
				$vt_tempRelation:=$vt_relation+"."+$vo_prop.name
			Else 
				$vt_tempRelation:=$vo_prop.name
			End if 
			$vc_template:=$vc_template.concat(ORDA_Get_Template_Rec($vo_prop.relatedDataClass; $vt_tempRelation))
			
	End case 
End for each 

$0:=$vc_template