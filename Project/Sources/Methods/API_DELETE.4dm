//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 23/01/17, 17:36:02
// ----------------------------------------------------
// Method: API_DELETE
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($1; $2; $vt_Record_Data; $vt_List_Name; $vt_Send_Data; $vt_ID)
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
	$vt_List_Name:=Replace string:C233($vt_List_Name; "app/"; "")
	$vt_List_Name:=Replace string:C233($vt_List_Name; "print/"; "")
End if 

C_POINTER:C301($vp_Field; $vp_Value)
$vl_Pos:=Position:C15("/"; $vt_List_Name)
If ($vl_Pos>0)
	$vt_ID:=Substring:C12($vt_List_Name; ($vl_Pos+1))
	Case of 
		: ($vt_List_Name="interface@")
			$vp_Field:=->[interface:8]id:1
			$vp_Value:=->$vt_ID
			
		Else 
			OB SET:C1220($vo_Response; "Error"; "Delete request not actioned.  Endpoint not found: "+$vt_List_Name)
	End case 
	
	$vl_Table_Num:=Table:C252($vp_Field)
	READ WRITE:C146(Table:C252($vl_Table_Num)->)
	QUERY:C277(Table:C252($vl_Table_Num)->; $vp_Field->=$vp_Value->)
	If (Records in selection:C76(Table:C252($vl_Table_Num)->)=1)
		DELETE RECORD:C58(Table:C252($vl_Table_Num)->)
		If (OK=1)
			OB SET:C1220($vo_Response; "Response"; "OK")
			$vt_htmlResponseCode:="200 OK"
		Else 
			OB SET:C1220($vo_Response; "Error"; "Delete failed.  Unknown.")
			$vt_htmlResponseCode:="401 Bad Request"
		End if 
	Else 
		OB SET:C1220($vo_Response; "Error"; "Delete failed.  Record not found.")
		$vt_htmlResponseCode:="404 Not Found"
	End if 
	READ ONLY:C145(Table:C252($vl_Table_Num)->)
Else 
	OB SET:C1220($vo_Response; "Error"; "Delete failed.  Badly formed request.")
	$vt_htmlResponseCode:="401 Bad Request"
End if 

$vt_Response:=JSON Stringify:C1217($vo_Response; *)
WEB_SET_RESPONSE_HEADER($vt_htmlResponseCode)
TEXT TO BLOB:C554($vt_Response; $vx_Response; UTF8 text without length:K22:17)
WEB SEND BLOB:C654($vx_Response; ".JSON")
