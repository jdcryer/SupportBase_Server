//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 18/06/21, 15:21:10
// ----------------------------------------------------
// Method: ORDA_Simple_Filter
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_LONGINT:C283($1; $vl_tableNum)
C_TEXT:C284($2; $vt_value)
C_OBJECT:C1216($0; $3; $es_data)

$vl_tableNum:=$1
$vt_value:=$2
$es_data:=$3
$0:=$es_data

Case of 
		//: ($vl_tableNum=Table(->[scanJob]))
		////$0:=$es_data.query("";$vt_value)
		
		//: ($vl_tableNum=Table(->[scanItem]))
		
		
		//: ($vl_tableNum=Table(->[account]))
		
		
		//: ($vl_tableNum=Table(->[device]))
		
		
		//: ($vl_tableNum=Table(->[file]))
		
		
		//: ($vl_tableNum=Table(->[product]))
		//$0:=$es_data.query("title == :1 || sku == :1 || barcode == :1"; "@"+$vt_value+"@")
		
End case 



