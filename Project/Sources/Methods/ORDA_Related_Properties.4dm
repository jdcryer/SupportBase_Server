//%attributes = {}
C_COLLECTION:C1488($0; $2; $vc_Template)
C_TEXT:C284($1)
$vc_Template:=$2.copy()
Case of 
	: ($1="scanJob")
		$vc_Template.push(New object:C1471("filterName"; "scanJob_scanItem.scanItem_product.*"))
		
	: ($1="scanItem")
		$vc_Template.push(New object:C1471("filterName"; "scanItem_product.*"))
		
	: ($1="device")
		//$vc_Template.push(New object("filterName";"device_account.*"))
		
End case 
$0:=$vc_Template.copy()
