//%attributes = {}
// ----------------------------------------------------
// User name (OS): Douglas Cryer
// Date and time: 02/07/17, 10:55:50
// ----------------------------------------------------
// Method: ORDA_Query
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $3; $vo_Request; $vo_Query; $es_data; $vo_Template; $es_queuedProds)
C_COLLECTION:C1488($2; $vc_Template)
C_TEXT:C284($vt_Field; $vt_Value; $vt_Operator; $vt_Conjunction; $vt_queryString; $vt_attribute; $vt_bracket)
C_LONGINT:C283($1; $vl_Table_Number; $vl_Field_Type; $vl_Query_Lines; $vl_FIA_Property; $vl_valueIndex)
C_DATE:C307($vd_Value)
$vl_Table_Number:=$1
$vc_Template:=$2
$vo_Request:=$3
$vl_Query_Lines:=0
ARRAY TEXT:C222($at_Properties; 0)
COLLECTION TO ARRAY:C1562($vc_Template; $at_Properties; "fieldName")
//TRACE
If (OB Is defined:C1231($vo_Request; "query"))
	$vt_queryString:=""
	C_OBJECT:C1216($vo_params)
	$vo_params:=New object:C1471
	$vo_params.parameters:=New collection:C1472
	ARRAY OBJECT:C1221($ao_Query; 0)
	OB GET ARRAY:C1229($vo_Request; "query"; $ao_Query)
	If (Size of array:C274($ao_Query)>0)
		For ($vl_Query_Index; 1; Size of array:C274($ao_Query))
			If (OB Is defined:C1231($ao_Query{$vl_Query_Index}; "conjunction"))
				$vt_Conjunction:=" "+OB Get:C1224($ao_Query{$vl_Query_Index}; "conjunction")+" "
			Else 
				$vt_Conjunction:=""
			End if 
			If (OB Is defined:C1231($ao_Query{$vl_Query_Index}; "bracket"))
				$vt_bracket:=OB Get:C1224($ao_Query{$vl_Query_Index}; "bracket")
			Else 
				$vt_bracket:="n"
			End if 
			If (OB Is defined:C1231($ao_Query{$vl_Query_Index}; "attribute"))
				$vt_attribute:=OB Get:C1224($ao_Query{$vl_Query_Index}; "attribute")
				If (Substring:C12($vt_attribute; 1; 1)#".")
					If ($vt_attribute#"")
						$vt_attribute:="."+$vt_attribute
					End if 
				End if 
			Else 
				$vt_attribute:=""
			End if 
			
			$vt_Field:=OB Get:C1224($ao_Query{$vl_Query_Index}; "field")
			$vt_Operator:=OB Get:C1224($ao_Query{$vl_Query_Index}; "operator")
			$vt_passedOperator:=$vt_Operator
			Case of 
				: ($vt_passedOperator="is in list")
					$vt_Operator:="in"
				: ($vt_passedOperator="contains")
					$vt_Operator:="="
			End case 
			
			$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "fieldName"; $vt_Field)
			If ($vl_index>-1)
				$vt_fieldName:=$vc_Template[$vl_index].fieldName
				$vl_Field_Type:=$vc_Template[$vl_index].fieldType
				Case of 
					: ($vt_bracket="l")
						$vt_queryString:=$vt_queryString+$vt_Conjunction+"("+$vt_fieldName+$vt_attribute+" "+$vt_Operator+" :"+String:C10($vl_Query_Index)
					: ($vt_bracket="r")
						$vt_queryString:=$vt_queryString+$vt_Conjunction+$vt_fieldName+$vt_attribute+" "+$vt_Operator+" :"+String:C10($vl_Query_Index)+")"
					Else   //No bracket
						$vt_queryString:=$vt_queryString+$vt_Conjunction+$vt_fieldName+$vt_attribute+" "+$vt_Operator+" :"+String:C10($vl_Query_Index)
				End case 
				//TRACE
				
				
				If ($vt_passedOperator="is in list")
					$vt_Value:=OB Get:C1224($ao_Query{$vl_Query_Index}; "value")
					
					ARRAY TEXT:C222($at_values; 0)
					CSV_PARSE_RECORD(->$at_values; $vt_Value)
					$vc_values:=New collection:C1472
					
					If ($vl_Field_Type=Is longint:K8:6) | ($vl_Field_Type=Is real:K8:4) | ($vl_Field_Type=Is integer:K8:5)
						For ($vl_valueIndex; 1; Size of array:C274($at_values))
							$vc_values.push(Num:C11($at_values{$vl_valueIndex}))
						End for 
					Else 
						ARRAY TO COLLECTION:C1563($vc_values; $at_values)
					End if 
					$vo_params.parameters.push($vc_values)
				Else 
					
					Case of 
						: ($vl_Field_Type=Is text:K8:3) | ($vl_Field_Type=Is alpha field:K8:1)
							$vt_Value:=OB Get:C1224($ao_Query{$vl_Query_Index}; "value")
							
							Case of 
								: ($vt_passedOperator="contains")
									$vt_Value:="@"+$vt_Value+"@"
									If ($vt_fieldName="SKUSize")  //Specific fix for i.LEVEL
										$vt_Value:=Replace string:C233($vt_Value; "_"; " ")
									End if 
									$vo_params.parameters.push($vt_Value)
									
								Else 
									If ($vt_fieldName="SKUSize")  //Specific fix for i.LEVEL
										$vt_Value:=Replace string:C233($vt_Value; "_"; " ")
									End if 
									$vo_params.parameters.push($vt_Value)
							End case 
							
						: ($vl_Field_Type=Is longint:K8:6) | ($vl_Field_Type=Is real:K8:4) | ($vl_Field_Type=Is integer:K8:5)
							$vt_Value:=String:C10(OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is real:K8:4))
							$vo_params.parameters.push(Num:C11($vt_Value))
							
						: ($vl_Field_Type=Is date:K8:7)
							If (Position:C15("/"; OB Get:C1224($ao_Query{$vl_Query_Index}; "value"))>0)
								$vd_Value:=Date:C102(OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is text:K8:3))
							Else 
								$vd_Value:=OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is date:K8:7)
							End if 
							$vo_params.parameters.push($vd_Value)
							
						: ($vl_Field_Type=Is boolean:K8:9)
							$vt_Value:=String:C10(OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is boolean:K8:9))
							$vo_params.parameters.push(($vt_Value="True"))
						Else   //This will currently only work for string type attributes
							
							$vt_Value:=OB Get:C1224($ao_Query{$vl_Query_Index}; "value")
							Case of 
								: ($vt_passedOperator="contains")
									$vt_Value:="@"+$vt_Value+"@"
									$vo_params.parameters.push($vt_Value)
									
								Else 
									//If (Num($vt_Value)>0) | ($vt_Value="0")  //Hack to allow queries on numeric properties
									//$vo_params.parameters.push(Num($vt_Value))
									//Else 
									$vo_params.parameters.push($vt_Value)
									//End if 
							End case 
					End case 
				End if 
			End if 
			
			$vl_Query_Lines:=$vl_Query_Lines+1
		End for 
	End if 
End if 
If ($vl_Query_Lines>0)
	$es_data:=ds:C1482[Table name:C256($vl_Table_Number)].query($vt_queryString; $vo_params)
Else 
	$es_data:=ds:C1482[Table name:C256($vl_Table_Number)].all()
End if 
//TRACE


If (OB Is defined:C1231($vo_Request; "querywitharray"))
	C_COLLECTION:C1488($vc_queryValues)
	$vc_queryValues:=New collection:C1472
	CLEAR VARIABLE:C89($vo_Query)
	$vo_Query:=OB Get:C1224($vo_Request; "querywitharray")
	If (OB Is defined:C1231($vo_Query; "field"))
		$vt_Field:=OB Get:C1224($vo_Query; "field")
		$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "fieldName"; $vt_Field)
		If ($vl_index>-1)
			$vt_fieldName:=$vc_Template[$vl_index].fieldName
			$vl_Field_Type:=$vc_Template[$vl_index].fieldType
			Case of 
				: ($vl_Field_Type=Is text:K8:3) | ($vl_Field_Type=Is alpha field:K8:1)
					ARRAY TEXT:C222($at_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $at_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $at_ValueArray)
					
				: ($vl_Field_Type=Is longint:K8:6) | ($vl_Field_Type=Is real:K8:4)
					ARRAY REAL:C219($ar_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ar_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ar_ValueArray)
					
				: ($vl_Field_Type=Is integer:K8:5)
					ARRAY INTEGER:C220($ai_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ai_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ai_ValueArray)
					
				: ($vl_Field_Type=Is date:K8:7)
					ARRAY DATE:C224($ad_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ad_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ad_ValueArray)
					
				: ($vl_Field_Type=Is boolean:K8:9)
					ARRAY BOOLEAN:C223($ab_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ab_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ab_ValueArray)
					
			End case 
			$es_data:=ds:C1482[Table name:C256($vl_Table_Number)].query($vt_Field+" in :1"; $vc_queryValues)
		End if 
	End if 
End if 

//REST_SPECIAL_QUERY ($vl_Table_Number;$vo_Request)

If (OB Is defined:C1231($vo_Request; "queryselection"))
	$vt_queryString:=""
	C_OBJECT:C1216($vo_params)
	$vo_params:=New object:C1471
	$vo_params.parameters:=New collection:C1472
	ARRAY OBJECT:C1221($ao_Query; 0)
	OB GET ARRAY:C1229($vo_Request; "queryselection"; $ao_Query)
	If (Size of array:C274($ao_Query)>0)
		For ($vl_Query_Index; 1; Size of array:C274($ao_Query))
			If (OB Is defined:C1231($ao_Query{$vl_Query_Index}; "conjunction"))
				$vt_Conjunction:=" "+OB Get:C1224($ao_Query{$vl_Query_Index}; "conjunction")+" "
			Else 
				$vt_Conjunction:=""
			End if 
			$vt_Field:=OB Get:C1224($ao_Query{$vl_Query_Index}; "field")
			$vt_Operator:=OB Get:C1224($ao_Query{$vl_Query_Index}; "operator")
			
			$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "fieldName"; $vt_Field)
			If ($vl_index>-1)
				$vt_fieldName:=$vc_Template[$vl_index].fieldName
				$vl_Field_Type:=$vc_Template[$vl_index].fieldType
				$vt_queryString:=$vt_queryString+$vt_fieldName+" "+$vt_Operator+" :"+String:C10($vl_Query_Index)+$vt_Conjunction
				Case of 
					: ($vl_Field_Type=Is text:K8:3) | ($vl_Field_Type=Is alpha field:K8:1)
						$vt_Value:=OB Get:C1224($ao_Query{$vl_Query_Index}; "value")
						If ($at_Properties{$vl_FIA_Property}="SKUSize")  //Specific fix for i.LEVEL
							$vt_Value:=Replace string:C233($vt_Value; "_"; " ")
						End if 
						$vo_params.parameters.push($vt_Value)
					: ($vl_Field_Type=Is longint:K8:6) | ($vl_Field_Type=Is real:K8:4) | ($vl_Field_Type=Is integer:K8:5)
						$vt_Value:=String:C10(OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is real:K8:4))
						$vo_params.parameters.push(Num:C11($vt_Value))
					: ($vl_Field_Type=Is date:K8:7)
						If (Position:C15("/"; OB Get:C1224($ao_Query{$vl_Query_Index}; "value"))>0)
							$vd_Value:=Date:C102(OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is text:K8:3))
						Else 
							$vd_Value:=OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is date:K8:7)
						End if 
						$vo_params.parameters.push($vd_Value)
					: ($vl_Field_Type=Is boolean:K8:9)
						$vt_Value:=String:C10(OB Get:C1224($ao_Query{$vl_Query_Index}; "value"; Is boolean:K8:9))
						$vo_params.parameters.push(($vt_Value="True"))
				End case 
				$vl_Query_Lines:=$vl_Query_Lines+1
			End if 
		End for 
	End if 
End if 
If ($vl_Query_Lines>0)
	$es_data:=$es_data.query($vt_queryString; $vo_params)
End if 


If (OB Is defined:C1231($vo_Request; "queryselectionwitharray"))
	C_COLLECTION:C1488($vc_queryValues)
	CLEAR VARIABLE:C89($vo_Query)
	$vo_Query:=OB Get:C1224($vo_Request; "queryselectionwitharray")
	If (OB Is defined:C1231($vo_Query; "field"))
		$vt_Field:=OB Get:C1224($vo_Query; "field")
		$vl_index:=$vc_Template.findIndex("UTIL_Find_Collection_String"; "fieldName"; $vt_Field)
		If ($vl_index>-1)
			$vt_fieldName:=$vc_Template[$vl_index].fieldName
			$vl_Field_Type:=$vc_Template[$vl_index].fieldType
			Case of 
				: ($vl_Field_Type=Is text:K8:3) | ($vl_Field_Type=Is alpha field:K8:1)
					ARRAY TEXT:C222($at_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $at_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $at_ValueArray)
					
				: ($vl_Field_Type=Is longint:K8:6) | ($vl_Field_Type=Is real:K8:4)
					ARRAY REAL:C219($ar_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ar_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ar_ValueArray)
					
				: ($vl_Field_Type=Is integer:K8:5)
					ARRAY INTEGER:C220($ai_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ai_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ai_ValueArray)
					
				: ($vl_Field_Type=Is date:K8:7)
					ARRAY DATE:C224($ad_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ad_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ad_ValueArray)
					
				: ($vl_Field_Type=Is boolean:K8:9)
					ARRAY BOOLEAN:C223($ab_ValueArray; 0)
					OB GET ARRAY:C1229($vo_Query; "values"; $ab_ValueArray)
					ARRAY TO COLLECTION:C1563($vc_queryValues; $ab_ValueArray)
					
			End case 
			$es_data:=$es_data.query($vt_Field+" in :1"; $vc_queryValues)
		End if 
	End if 
End if 

$0:=$es_data
