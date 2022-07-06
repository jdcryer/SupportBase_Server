//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 07/09/20, 16:49:25
// ----------------------------------------------------
// Method: MISC_Parse_Entity_Datafield
// Description
// Returns given datafields value from given entity
// Parses a "relationship string" e.g. hostProduct_product.product_variant.code so that each part is evaluated separatly
//
// Parameters
// $0 - Variant - Entity Value
// $1 - Object  - Entity
// $2 - Text    - Datafield string
// ----------------------------------------------------

C_VARIANT:C1683($0)
C_OBJECT:C1216($1; $e_record)
C_TEXT:C284($2)

ARRAY TEXT:C222($at_data; 0)

$e_record:=$1
CSV_PARSE_RECORD(->$at_data; $2; Character code:C91("."))
$vl_size:=Size of array:C274($at_data)

Case of 
	: ($vl_size=1)
		$0:=$e_record[$at_data{1}]
	: ($vl_size=2)
		$0:=$e_record[$at_data{1}][$at_data{2}]
	: ($vl_size=3)
		$0:=$e_record[$at_data{1}][$at_data{2}][$at_data{3}]
	: ($vl_size=4)
		$0:=$e_record[$at_data{1}][$at_data{2}][$at_data{3}][$at_data{4}]
	: ($vl_size=5)
		$0:=$e_record[$at_data{1}][$at_data{2}][$at_data{3}][$at_data{4}][$at_data{5}]
	: ($vl_size=6)
		$0:=$e_record[$at_data{1}][$at_data{2}][$at_data{3}][$at_data{4}][$at_data{5}][$at_data{6}]
	: ($vl_size=7)
		$0:=$e_record[$at_data{1}][$at_data{2}][$at_data{3}][$at_data{4}][$at_data{5}][$at_data{6}][$at_data{7}]
	Else 
		$0:=""
End case 
