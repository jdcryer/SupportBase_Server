//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 13/07/20, 12:09:48
// ----------------------------------------------------
// Method: MISC_Get_Default_Grid_Def
// Description
// Returns default columns and datafields settings for the given 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)
C_TEXT:C284($1)
$vo_response:=New object:C1471
$vo_response.viewData:=New object:C1471
$vo_response.viewData.id:=""
$vo_response.viewData.name:=""
$vo_response.viewData.fk_user:=""
$vo_response.viewData.handle:=$1
$vo_response.viewData.type:=1
$vo_response.viewData.default:=True:C214
$vo_response.viewData.detail:=New object:C1471
$vo_response.viewData.detail.datafields:=New collection:C1472
$vo_response.viewData.detail.columns:=New collection:C1472
$vo_response.viewData.detail.editColumns:=New collection:C1472


Case of 
	: ($1="brand")
		
		
		$vo_response.columns:=New collection:C1472
		$vo_response.columns.push(New object:C1471("text"; "Brand ID"; "datafield"; "id"; "width"; "10%"))
		$vo_response.columns.push(New object:C1471("text"; "Brand Name"; "datafield"; "name"; "width"; "30%"))
		$vo_response.columns.push(New object:C1471("text"; "Company"; "datafield"; "companyName"; "width"; "60%"))
		
		$vo_response.datafields:=New collection:C1472
		$vo_response.datafields.push(New object:C1471("name"; "id"; "type"; "string"))
		$vo_response.datafields.push(New object:C1471("name"; "name"; "type"; "string"))
		$vo_response.datafields.push(New object:C1471("name"; "detail"; "type"; "object"))
		$vo_response.datafields.push(New object:C1471("name"; "companyName"; "type"; "string"; "map"; "brand_company>name"))
		
End case 

$0:=$vo_response