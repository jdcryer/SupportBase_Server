//%attributes = {}
C_TEXT:C284($1; $vt_Record_Data; $vt_List_Name; $vt_Send_Data; $vt_Type; $vt_htmlResponseCode)
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
//TRACE
Case of 
		//: ($vt_List_Name="fileoutput@")
		//$vo_response:=REST_Get_Report(True)
		//$vt_docText:=JSON Stringify($vo_response; *)
		
		//: ($vt_List_Name="report@")
		//$vo_response:=REST_Get_Report
		//$vt_docText:=JSON Stringify($vo_response; *)
		
	: ($vt_List_Name="exportView@")
		$vo_dataObject:=REST_Get_Export_View
		$vt_docText:=JSON Stringify:C1217($vo_dataObject; *)
		
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
		//OB SET($vo_response;"Error";"Update not actioned.  Endpoint not found: "+$vt_List_Name)
		//$vt_docText:=JSON Stringify($vo_response;*)
End case 
If (OB Is defined:C1231($vo_response; "htmlResponseCode"))
	$vt_htmlResponseCode:=$vo_response.htmlResponseCode
Else 
	$vt_htmlResponseCode:="200 OK"
End if 

TEXT TO BLOB:C554($vt_docText; $vx_HTML; UTF8 text without length:K22:17)
//If ($vl_Compression#0)
//COMPRESS BLOB($vx_HTML;$vl_Compression)//Removed as not threadsafe
//End if 
//TRACE
WEB_SET_RESPONSE_HEADER($vt_htmlResponseCode)
WEB SEND BLOB:C654($vx_HTML; $vt_Type)
