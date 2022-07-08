//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 23/01/17, 17:36:02
// ----------------------------------------------------
// Method: API_POST
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($1; $2; $vt_Record_Data; $vt_List_Name; $vt_Send_Data; $vt_htmlResponseCode)
C_BLOB:C604($vx_HTML)
C_LONGINT:C283($vl_RIS; $vl_Compression; $vl_Table_Num)
C_LONGINT:C283($vl_Page; $vl_Page_Count; $vl_Total_Records; $vl_ResponseType)
C_OBJECT:C1216($vo_Data_Object)
C_POINTER:C301($vp_Table)
C_LONGINT:C283(vl_Error)
C_OBJECT:C1216($vo_Request; $vo_Response)
C_BLOB:C604($vx_Request; $vx_Response)
C_TEXT:C284($vt_Request; $vt_Error)
$cp:=Count parameters:C259
If ($cp>0)
	$vt_List_Name:=Replace string:C233($1; "api/"; "")
	$vt_List_Name:=Replace string:C233($vt_List_Name; "app/"; "")
	$vt_List_Name:=Replace string:C233($vt_List_Name; "print/"; "")
End if 
vl_Error:=0
WEB GET HTTP BODY:C814($vx_Request)
$vt_Request:=BLOB to text:C555($vx_Request; UTF8 text without length:K22:17)
ON ERR CALL:C155("JSON_ERROR")
//TRACE
$vo_Request:=JSON Parse:C1218($vt_Request)
If (vl_Error=0)
	Case of 
		: ($vt_List_Name="GitPull@") | ($vt_List_Name="/GitPull@")
			GIT_PULL
			
		: ($vt_List_Name="resetRequest@")
			$vo_Response:=REST_Put_Reset_Request($vo_Request)
			
		: ($vt_List_Name="passwordUpdate@")
			$vo_Response:=REST_Put_PasswordUpdate($vo_Request)
			
		: ($vt_List_Name="interface@")
			$vo_Response:=REST_Put_Generic($vo_Request; Table:C252(->[interface:8]))
			$vt_htmlResponseCode:="200 OK"
			
		: ($vt_List_Name="lookupList@")
			$vo_Response:=REST_Put_Generic($vo_Request; Table:C252(->[lookupList:12]))
			$vt_htmlResponseCode:="200 OK"
			
		: ($vt_List_Name="changeMessage@")
			$vo_Response:=REST_Put_Generic($vo_Request; Table:C252(->[changeMessage:6]))
			$vt_htmlResponseCode:="200 OK"
			
		: ($vt_List_Name="change@")
			$vo_Response:=REST_Put_Generic($vo_Request; Table:C252(->[change:5]))
			$vt_htmlResponseCode:="200 OK"
			
		: ($vt_List_Name="ticketMessage@")
			$vo_Response:=REST_Put_Generic($vo_Request; Table:C252(->[ticketMessage:3]))
			$vt_htmlResponseCode:="200 OK"
			
		: ($vt_List_Name="ticket@")
			$vo_Response:=REST_Put_Generic($vo_Request; Table:C252(->[ticket:2]))
			$vt_htmlResponseCode:="200 OK"
			
		: ($vt_List_Name="lookupMapping@")
			$vo_Response:=REST_Put_Generic($vo_Request; Table:C252(->[lookupMapping:17]))
			$vt_htmlResponseCode:="200 OK"
			
		Else 
			OB SET:C1220($vo_Response; "Error"; "Insert not actioned.  Endpoint not found: "+$vt_List_Name)
	End case 
Else 
	OB SET:C1220($vo_Response; "Error"; "Malformed request, bad json data!")
End if 
$vt_Response:=JSON Stringify:C1217($vo_Response; *)
TEXT TO BLOB:C554($vt_Response; $vx_Response; UTF8 text without length:K22:17)
WEB_SET_RESPONSE_HEADER($vt_htmlResponseCode)
WEB SEND BLOB:C654($vx_Response; ".JSON")
ON ERR CALL:C155("")
