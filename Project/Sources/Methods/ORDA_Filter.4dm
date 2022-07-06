//%attributes = {}
C_LONGINT:C283($1; $vl_fieldType)
C_POINTER:C301($3; $4; $vp_TablePtr)
C_OBJECT:C1216($5; $vo_prop)
C_COLLECTION:C1488($2; $vc_Template)
$vp_TablePtr:=Table:C252($1)
$vc_Template:=$2
ARRAY TEXT:C222($at_Field; 0)
ARRAY TEXT:C222($at_Value; 0)
COPY ARRAY:C226($3->; $at_Field)
COPY ARRAY:C226($4->; $at_Value)

For each ($vo_prop; $vc_Template)
	$vl_FIA_Property:=Find in array:C230($at_Field; $vo_prop.filterName)
	If ($vl_FIA_Property>0)
		If ($vo_prop.filterName="email")
			$vt_queryString:=$vo_prop.filterName+" === :1"
		Else 
			$vt_queryString:=$vo_prop.filterName+" = :1"
		End if 
		$vl_fieldType:=$vo_prop.fieldType
		Case of 
			: ($vl_fieldType=Is text:K8:3) | ($vl_fieldType=Is alpha field:K8:1)
				$5:=$5.query($vt_queryString; $at_Value{$vl_FIA_Property})
			: ($vl_fieldType=Is longint:K8:6) | ($vl_fieldType=Is real:K8:4) | ($vl_fieldType=Is integer:K8:5)
				$5:=$5.query($vt_queryString; Num:C11($at_Value{$vl_FIA_Property}))
			: ($vl_fieldType=Is date:K8:7)
				$vt_date:=$at_Value{$vl_FIA_Property}
				$vd_date:=Date:C102(Substring:C12($vt_date; 9; 2)+"/"+Substring:C12($vt_date; 6; 2)+"/"+Substring:C12($vt_date; 1; 4))
				$5:=$5.query($vt_queryString; $vd_date)
			: ($vl_fieldType=Is boolean:K8:9)
				$5:=$5.query($vt_queryString; ($at_Value{$vl_FIA_Property}="true"))
		End case 
	End if 
End for each 
$0:=$5
