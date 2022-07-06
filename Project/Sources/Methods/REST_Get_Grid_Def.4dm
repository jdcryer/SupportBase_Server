//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 08/07/20, 14:51:42
// ----------------------------------------------------
// Method: REST_Get_Grid_Def
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)
C_OBJECT:C1216($e_view; $es_view; $e_viewList; $es_viewList)
ARRAY TEXT:C222($at_name; 0)
ARRAY TEXT:C222($at_value; 0)

$vo_response:=New object:C1471

WEB GET VARIABLES:C683($at_name; $at_value)
$vl_FIA:=Find in array:C230($at_name; "table")
If ($vl_FIA>0)
	$vt_table:=$at_value{$vl_FIA}
	
	//
	// Get View Settings
	//
	$vl_FIA:=Find in array:C230($at_name; "viewId")
	If ($vl_FIA>0)
		$vt_viewId:=$at_value{$vl_FIA}
		$es_view:=ds:C1482.interface.query("id == :1 && type == 1 && handle == :2 && fk_user == :3"; $vt_viewId; $vt_table; vt_userID)
	Else 
		$es_view:=ds:C1482.interface.query("type == 1 && handle == :1 && default == true && fk_user == :2"; $vt_table; vt_userID)
	End if 
	
	If ($es_view.length>0)
		$e_view:=$es_view.first()
		$vo_response.viewData:=$e_view.toObject()
		
	Else 
		$es_view:=ds:C1482.interface.query("type == 1 && handle == :1 && fk_user == :2"; $vt_table; "20202020202020202020202020202020")
		If ($es_view.length>0)
			$vo_response.viewData:=$es_view.first().toObject()
		Else 
			$vo_response:=MISC_Get_Default_Grid_Def($vt_table)  //Change to get a default record instead of hardcoding?
		End if 
	End if 
	
	//
	// Get List of Views for menu
	//
	$vo_response.viewList:=New collection:C1472
	$es_viewList:=ds:C1482.interface.query("type == 1 && handle == :1 && fk_user == :2"; $vt_table; vt_userID)
	
	For each ($e_viewList; $es_viewList)
		$vo_response.viewList.push(New object:C1471("label"; $e_viewList.name; "value"; $e_viewList.id; "name"; $e_viewList.name))
	End for each 
	
	//If we have any existing views, add separator to last element
	If ($vo_response.viewList.length>0)
		$vo_response.viewList[$vo_response.viewList.length-1].separator:=True:C214
	End if 
	
	//$vo_response.viewList.push(New object("id"; "menuSeparator"))
	//$vo_response.viewList.push(New object("label"; "New View<i style=\"float: right\" class=\"far fa-plus\"></i>"; "value"; "newview"))
	//$vo_response.viewList.push(New object("label"; "Edit Current View<i style=\"float: right\" class=\"far fa-edit\"></i>"; "value"; "editview"))
	//$vo_response.viewList.push(New object("label"; "Duplicate Current View<i style=\"float: right\" class=\"far fa-copy\"></i>"; "value"; "dupeview"))
	//$vo_response.viewList.push(New object("label"; "Delete Current View<i style=\"float: right\" class=\"far fa-trash\"></i>"; "value"; "deleteview"))
	
	
	$vo_response.viewList.push(New object:C1471("label"; "<i class=\"far fa-plus\"></i>New View"; "value"; "newview"))
	$vo_response.viewList.push(New object:C1471("label"; "<i class=\"far fa-edit\"></i>Edit Current View"; "value"; "editview"))
	$vo_response.viewList.push(New object:C1471("label"; "<i class=\"far fa-copy\"></i>Duplicate Current View"; "value"; "dupeview"))
	$vo_response.viewList.push(New object:C1471("label"; "<i class=\"far fa-trash\"></i>Delete Current View"; "value"; "deleteview"))
	
	
	$vc_exportItems:=New collection:C1472
	$vc_exportItems.push(New object:C1471("label"; "<i class=\"far fa-file-excel\"></i>To Excel"; "value"; "excel"))
	$vc_exportItems.push(New object:C1471("label"; "<i class=\"far fa-file-csv\"></i>To CSV"; "value"; "csv"))
	$vo_response.viewList.push(New object:C1471("label"; "<i class=\"far fa-file-export\"></i> Export data using View"; "value"; "exportview"; "items"; $vc_exportItems))
	
	//
	// Get Action / Print menu options
	//
	$vo_response:=MISC_Get_Grid_Actions($vo_response; $vt_table)
	
Else 
	$vo_response.error:="Table parameter is missing!"
End if 

$0:=$vo_response