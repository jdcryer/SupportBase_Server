//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 23/01/17, 17:36:02
// ----------------------------------------------------
// Method: API_REST
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($1; $2; $vt_Record_Data; $vt_List_Name; $vt_Send_Data)
C_BLOB:C604($vx_HTML)
C_LONGINT:C283($vl_RIS; $vl_Compression; $vl_Table_Num)
C_LONGINT:C283($vl_Page; $vl_Page_Count; $vl_Total_Records; $vl_ResponseType)
C_OBJECT:C1216($vo_Data_Object)
C_POINTER:C301($vp_Table)
C_LONGINT:C283(vl_Error)
C_OBJECT:C1216($vo_Request; $vo_Response)
C_BLOB:C604($vx_Request)
C_TEXT:C284($vt_Request; $vt_Error)

$cp:=Count parameters:C259
If ($cp>0)
	$vt_List_Name:=Replace string:C233($1; "api/"; "")
End if 

$vl_Pos:=Position:C15("/"; $vt_List_Name)
If ($vl_Pos>0)
	vl_Error:=0
	WEB GET HTTP BODY:C814($vx_Request)
	$vt_Request:=BLOB to text:C555($vx_Request; UTF8 text without length:K22:17)
	ON ERR CALL:C155("JSON_ERROR")
	$vo_Request:=JSON Parse:C1218($vt_Request)
	If (vl_Error=0)
		Case of 
				//: ($vt_List_Name="ScanJob@")
				//OB SET($vo_Request; "id"; Substring($vt_List_Name; ($vl_Pos+1)))
				//$vo_Response:=REST_Put_ScanJob($vo_Request)
				
				//: ($vt_List_Name="ScanItem@")
				//OB SET($vo_Request; "id"; Substring($vt_List_Name; ($vl_Pos+1)))
				//$vo_Response:=REST_Put_ScanItem($vo_Request)
				
			Else 
				OB SET:C1220($vo_Response; "Error"; "Update not actioned.  Endpoint not found: "+$vt_List_Name)
		End case 
		
	Else 
		OB SET:C1220($vo_Response; "Error"; "Malformed request, bad json data!")
	End if 
Else 
	OB SET:C1220($vo_Response; "Error"; "Update failed.  Badly formed request.")
End if 
$vt_Response:=JSON Stringify:C1217($vo_Response; *)
TEXT TO BLOB:C554($vt_Response; $vx_Response)
WEB SEND BLOB:C654($vx_Response; ".JSON")
ON ERR CALL:C155("")
