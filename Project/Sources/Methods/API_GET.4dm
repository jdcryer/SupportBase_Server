//%attributes = {}
C_TEXT:C284($1; $vt_Record_Data; $vt_List_Name; $vt_Send_Data; $vt_Type)
C_BLOB:C604($vx_HTML)
C_LONGINT:C283($vl_RIS; $vl_Compression; $vl_Table_Num)
C_LONGINT:C283($vl_Page; $vl_Page_Count; $vl_Total_Records; $vl_ResponseType)
C_OBJECT:C1216($vo_response)
C_POINTER:C301($vp_Table)
C_LONGINT:C283(vl_Error)
C_OBJECT:C1216($vo_Request; $vo_Response)
C_BLOB:C604($vx_Request)
C_TEXT:C284($vt_Request; $vt_Error)
C_TEXT:C284($vt_docText; $vt_Type)
C_BOOLEAN:C305($2)
$vt_Type:=".json"

$cp:=Count parameters:C259
If ($cp>0)
	$vt_List_Name:=Replace string:C233($1; "api/"; "")
	$vt_List_Name:=Replace string:C233($vt_List_Name; "app/"; "")
	$vt_List_Name:=Replace string:C233($vt_List_Name; "print/"; "")
End if 

WEB GET HTTP BODY:C814($vx_request)
If (BLOB size:C605($vx_request)=0)
	$vl_queryPos:=Position:C15("?query="; $1)
	If ($vl_queryPos>0)
		$vl_queryPos:=$vl_queryPos+7
		$vl_qPos:=Position:C15("?"; $1; $vl_queryPos)
		If ($vl_qPos>0)
			$vo_request:=JSON Parse:C1218(Substring:C12($1; $vl_queryPos; ($vl_qPos-$vl_queryPos)))
		Else 
			$vo_request:=JSON Parse:C1218(Substring:C12($1; $vl_queryPos))
		End if 
	End if 
Else 
	$vt_request:=BLOB to text:C555($vx_request; UTF8 text without length:K22:17)
	If ($vt_request#"")
		$vo_request:=JSON Parse:C1218($vt_request)
	End if 
End if 

Case of 
	: ($vt_List_Name="currentUser@")
		$vo_dataObject:=REST_Get_Current_User(vo_currentUser.id)
		$vt_docText:=JSON Stringify:C1217($vo_dataObject; *)
		
	: ($vt_List_Name="propertyList@") | ($vt_List_Name="/propertyList@")
		$vo_dataObject:=ORDA_Get_Property_List  //Used by the query editor
		$vt_docText:=JSON Stringify:C1217($vo_dataObject; *)
		
	: ($vt_List_Name="structure@")
		$vo_dataObject:=REST_Get_Structure
		$vt_docText:=JSON Stringify:C1217($vo_dataObject; *)
		
		
		//: ($vt_List_Name="dashboard/stats") | ($vt_List_Name="/dashboard/stats@")
		//$vo_dataObject:=REST_Get_Dashboard_Stats
		//$vt_docText:=JSON Stringify($vo_dataObject; *)
		
	: ($vt_List_Name="gridDef@")
		$vo_dataObject:=REST_Get_Grid_Def
		$vt_docText:=JSON Stringify:C1217($vo_dataObject; *)
		
	: ($vt_List_Name="userQueries@")
		$vo_dataObject:=REST_Get_UserQueries
		$vt_docText:=JSON Stringify:C1217($vo_dataObject; *)
		
	: ($vt_List_Name="checkreset@")
		$vo_response:=REST_Get_Check_Reset
		$vt_docText:=JSON Stringify:C1217($vo_response; *)
		
	: ($vt_List_Name="reloadServer@")
		GIT_PULL_SERVER
		
	: ($vt_List_Name="navigateRecords@")
		$vo_response:=REST_Get_Navigate_Records
		$vt_docText:=JSON Stringify:C1217($vo_response; *)
		
	: ($vt_List_Name="navigateState@")
		$vo_response:=REST_Get_Navigate_State
		$vt_docText:=JSON Stringify:C1217($vo_response; *)
		
	: ($vt_List_Name="lookups@")
		$vo_response:=REST_Get_Lookups
		$vt_docText:=JSON Stringify:C1217($vo_response; *)
		
	Else 
		$vl_Pos:=Position:C15("/"; $vt_List_Name; 2)
		If ($vl_Pos>0)
			$vt_TableName:=Replace string:C233(Substring:C12($vt_List_Name; 1; $vl_Pos); "/"; "")
		Else 
			$vl_Pos:=Position:C15("?"; $vt_List_Name)
			If ($vl_Pos>0)
				$vt_TableName:=Replace string:C233(Substring:C12($vt_List_Name; 1; ($vl_Pos-1)); "/"; "")
			Else 
				$vt_TableName:=Replace string:C233($vt_List_Name; "/"; "")
			End if 
		End if 
		
		$vo_response:=ORDA_Get_Table($vt_List_Name; $vo_request; $2; $vt_TableName)
		$vt_docText:=JSON Stringify:C1217($vo_response; *)
		
End case 
If (OB Is defined:C1231($vo_response; "htmlResponseCode"))
	$vt_htmlResponseCode:=$vo_response.htmlResponseCode
Else 
	$vt_htmlResponseCode:="200 OK"
End if 

TEXT TO BLOB:C554($vt_docText; $vx_HTML; UTF8 text without length:K22:17)
If ($vl_Compression#0)
	COMPRESS BLOB:C534($vx_HTML; $vl_Compression)
End if 
WEB_SET_RESPONSE_HEADER($vt_htmlResponseCode)
WEB SEND BLOB:C654($vx_HTML; $vt_Type)
