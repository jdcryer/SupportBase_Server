//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 05/07/21, 14:53:38
// ----------------------------------------------------
// Method: ORDA_Relate_Count
// Description
// Returns an collection containing a record count of related  
// records for the given table / entity selection
// Used by Web listing to populate Relate dropdown menu
// Parameters
// $0 - Collection - Relate Counts
// $1 - Text       - Table Name
// $2 - Entity Sel - Records
// ----------------------------------------------------

C_COLLECTION:C1488($0; $vc_relateCount)
C_TEXT:C284($1; $vt_table)
C_OBJECT:C1216($2; $es_data)

$vc_relateCount:=New collection:C1472
$vt_table:=$1
$es_data:=$2

Case of 
	: ($vt_table="scanJob")
		$vc_relateCount.push(New object:C1471("table"; "scanItem"; "label"; "Scan Items"; "listing"; "scan-item"; "count"; $es_data.scanJob_scanItem.length))
		$vc_relateCount.push(New object:C1471("table"; "product"; "label"; "Products"; "listing"; "product"; "count"; $es_data.scanJob_scanItem.scanItem_product.length))
		
	: ($vt_table="scanItem")
		
		
	: ($vt_table="device")
		$vc_relateCount.push(New object:C1471("table"; "scanJob"; "label"; "Scan Queues"; "listing"; "scan-job"; "count"; $es_data.device_scanJob.length))
		
	: ($vt_table="account")
		$vc_relateCount.push(New object:C1471("table"; "scanJob"; "label"; "Scan Jobs"; "listing"; "scan-job"; "count"; $es_data.account_scanJob.length))
		$vc_relateCount.push(New object:C1471("table"; "product"; "label"; "Products"; "listing"; "product"; "count"; $es_data.account_product.length))
		$vc_relateCount.push(New object:C1471("table"; "device"; "label"; "Devices"; "listing"; "device"; "count"; $es_data.account_device.length))
		
	: ($vt_table="file")
		
		
	: ($vt_table="product")
		$vc_relateCount.push(New object:C1471("table"; "scanJob"; "label"; "Scan Jobs"; "listing"; "scan-job"; "count"; $es_data.product_scanItem.scanItem_scanJob.length))
		$vc_relateCount.push(New object:C1471("table"; "account"; "label"; "Account"; "listing"; "account"; "count"; $es_data.product_account.length))
		
End case 

$0:=$vc_relateCount
