//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 13/07/20, 12:17:10
// ----------------------------------------------------
// Method: MISC_Get_Grid_Actions
// Description
// Adds actionList, printList and queryList according to table 
// to given object which is then returned
// Parameters
// $0 - Object - $1 with properties added
// $1 - Object - Object to add data to
// $2 - String - Table to get lists for
// ----------------------------------------------------


C_OBJECT:C1216($0; $1; $vo_response)
C_COLLECTION:C1488($vc_items)
C_TEXT:C284($2)

$vo_response:=$1
$vo_response.actionList:=New collection:C1472
$vo_response.printList:=New collection:C1472
//If queryList is empty, query button will still open `Advanced Query` 
//But the button will not display a dropdown list
$vo_response.queryList:=New collection:C1472

Case of 
	: ($2="scanJob")
		
		$vo_response.actionList.push(New object:C1471("label"; "Example Action"; "value"; "exampleAction"; "separator"; True:C214))
		$vo_response.actionList.push(New object:C1471("label"; "Example Action2"; "value"; "exampleAction2"))
		
		$vo_response.queryList.push(New object:C1471("label"; "General Search"; "value"; "search"))
		$vo_response.queryList.push(New object:C1471("label"; "Advanced Search"; "value"; "query"))
		
		$vo_response.printList.push(New object:C1471("label"; "Barcodes"; "value"; "barcodes"))
		
End case 

$0:=$vo_response
