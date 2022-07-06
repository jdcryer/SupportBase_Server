//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 05/07/21, 16:38:53
// ----------------------------------------------------
// Method: ORDA_Relate
// Description
// Returns entity selection for target table using relation
// for source data
// Parameters
// $0 - Entity Sel
// $1 - Text       - Source Table Name
// $2 - Text       - Target Table Name
// $3 - Entity Sel - Source Data
// ----------------------------------------------------

C_OBJECT:C1216($0; $es_data; $3; $es_sourceData)
C_TEXT:C284($1; $vt_sourceTable; $2; $vt_targetTable)

$vt_sourceTable:=$1
$vt_targetTable:=$2
$es_sourceData:=$3


Case of 
	: ($vt_sourceTable="scanJob")
		Case of 
			: ($vt_targetTable="scanItem")
				$es_data:=$es_sourceData.scanJob_scanItem
				
			: ($vt_targetTable="product")
				$es_data:=$es_sourceData.scanJob_scanItem.scanItem_product
				
		End case 
		
		
	: ($vt_sourceTable="scanItem")
		
		
	: ($vt_sourceTable="device")
		Case of 
			: ($vt_targetTable="scanJob")
				$es_data:=$es_sourceData.device_scanJob
				
		End case 
		
		
	: ($vt_sourceTable="account")
		Case of 
			: ($vt_targetTable="scanJob")
				$es_data:=$es_sourceData.account_scanJob
				
			: ($vt_targetTable="file")
				$es_data:=$es_sourceData.account_file
				
			: ($vt_targetTable="product")
				$es_data:=$es_sourceData.account_product
				
			: ($vt_targetTable="device")
				$es_data:=$es_sourceData.account_device
				
		End case 
		
		
	: ($vt_sourceTable="file")
		
		
	: ($vt_sourceTable="product")
		Case of 
			: ($vt_targetTable="scanJob")
				$es_data:=$es_sourceData.product_scanItem.scanItem_scanJob
				
		End case 
		
End case 

$0:=$es_data
