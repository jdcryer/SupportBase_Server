//%attributes = {}
// ----------------------------------------------------
// User name (OS): Douglas Cryer
// Date and time: 02/07/17, 11:04:03
// ----------------------------------------------------
// Method: ORDA_Sort(table(->[Stock]);$vo_Template;$at_Value{$vl_FIA})
// Description
// 
//rest_get_stock
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($4)
C_TEXT:C284($3; $vt_Order_Data; $vt_SortDir)
C_LONGINT:C283($1; $vl_Table_Number; $vl_fia; $vl_OrderBy; $vl_Sort_Lines; vl_sortError)
C_BOOLEAN:C305($vb_desc)
C_COLLECTION:C1488($2; $vc_orderData; $vc_Template)
vl_sortError:=0
$vl_Table_Number:=$1
$vc_Template:=$2
$vt_Order_Data:=$3
ARRAY POINTER:C280($ap_Sort_Field; 0)
ARRAY TEXT:C222($at_Sort_Dir; 0)
//ARRAY TEXT($at_Properties;0)
//COLLECTION TO ARRAY($vc_Template;$at_Properties;"fieldName")

ARRAY TEXT:C222($at_OrderValues; 0)
CSV_PARSE_RECORD(->$at_OrderValues; $vt_Order_Data; Character code:C91(";"))
APPEND TO ARRAY:C911($at_OrderValues; "")
$vl_OrderBy:=0

$vc_orderData:=New collection:C1472
For ($i; 1; Size of array:C274($at_OrderValues))
	$vt_SortDir:=">"
	If ($at_OrderValues{$i}=">") | ($at_OrderValues{$i}="<")
		$vt_SortDir:=$at_OrderValues{$i}
		$vl_OrderBy:=2
	Else 
		If ($vl_OrderBy>=0)
			$vl_OrderBy:=$vl_OrderBy+1
		End if 
	End if 
	If ($vl_OrderBy=2)
		$vb_desc:=$vt_SortDir="<"
		//$vl_fia:=Find in array($at_Properties;$at_OrderValues{$i-1})
		//If ($vl_fia>0)
		$vc_orderData.push(New object:C1471("propertyPath"; $at_OrderValues{$i-1}; "descending"; $vb_desc))
		//End if 
	End if 
End for 
If ($vc_orderData.length>0)
	ON ERR CALL:C155("SORT_ERROR")
	$0:=$4.orderBy($vc_orderData)
	ON ERR CALL:C155("SORT_ERROR")
	If (vl_sortError#0)
		$0:=$4
	End if 
Else 
	$0:=$4
End if 
