C_TEXT:C284($1; $2; $3; $4; $5; $6; $vt_Data_In; $vt_Params)
C_LONGINT:C283(vl_scanJobs; $vl_Pos)
C_OBJECT:C1216($vo_Response)
//Compiler_web 

If (vt_webSessionID#WEB Get current session ID:C1162) & (vt_webSessionID#"DEV")
	vt_webSessionID:=WEB Get current session ID:C1162
	ARRAY TEXT:C222(at_selectToken; 0)
End if 

$vt_Data_In:=Substring:C12($1; 2)
$vt_RequestType:=$2

Case of 
	: ($vt_Data_In="app/login@") | ($vt_Data_In="print/login")
		//TRACE
		WEB_SET_RESPONSE_HEADER
		$vo_Response:=New object:C1471
		$vo_Response.response:="OK"
		WEB SEND TEXT:C677(JSON Stringify:C1217($vo_Response))
		
	: ($vt_Data_In="API@") | ($vt_Data_In="APP@") | ($vt_Data_In="print@")
		$vl_Pos:=Position:C15("/"; $vt_Data_In)
		If ($vl_Pos>0)
			If ($vt_RequestType="POST@")
				If ($1="@/query@") | ($1="@/subset@") | ($1="@/omitset@") | ($1="@/labelPreview@")
					$vt_RequestType:=Replace string:C233($vt_RequestType; "POST"; "GET"; 1)
					$vb_postGet:=True:C214
				End if 
			End if 
			
			$vt_Params:=Substring:C12($vt_Data_In; ($vl_Pos+1))
			//If (API_Check_Access ($1;$2)=1)
			Case of 
				: ($vt_RequestType="OPTION@")
					$vt_docText:=""
					TEXT TO BLOB:C554($vt_docText; $vx_HTML; UTF8 text without length:K22:17)
					WEB_SET_RESPONSE_HEADER("204 No Content")
					WEB SEND BLOB:C654($vx_HTML; "")
					
				: ($vt_RequestType="GET@")
					If ($vt_Data_In="app/exportView@")
						API_GET_NTS($vt_Data_In; $vb_postGet)  //Not threadsafe methods.
					Else 
						API_GET($vt_Data_In; $vb_postGet)
					End if 
				: ($vt_RequestType="POST@")
					API_POST($vt_Data_In)
					
				: ($vt_RequestType="PUT@")
					API_PUT($vt_Data_In)
					
				: ($vt_RequestType="DELETE@")
					API_DELETE($vt_Data_In)
					
			End case 
			//End if   //End check access
			
			
		Else 
			OB SET:C1220($vo_Response; "Error"; "Check URL.  Badly formed request.")
			$vt_Response:=JSON Stringify:C1217($vo_Response; *)
			TEXT TO BLOB:C554($vt_Response; $vx_Response)
			WEB SEND BLOB:C654($vx_Response; ".JSON")
		End if 
		
		//: ($vt_Data_In="@4DCGI/uploadFile@")  //uploadFile check
		//CGI_UPLOAD_FILE
		
		//: ($vt_Data_In="@4DCGI/uploadPrintImage@")
		//CGI_UPLOAD_PRINT_IMAGE
		
	: ($vt_Data_In="@dist/@")  //redirect back to index
		WEB SEND HTTP REDIRECT:C659("/dist/index.html")
		
	: ($vt_Data_In="@WEB_REDIRECT@")
		//TRACE
		$vt_Data_In:=Replace string:C233($vt_Data_In; "4DCGI/"; "")
		$vl_Pos:=Position:C15("/"; $vt_Data_In)
		If ($vl_Pos>0)
			$vt_Params:=Substring:C12($vt_Data_In; ($vl_Pos+1))
			WEB_REDIRECT($vt_Params)
		Else 
			WEB_REDIRECT
		End if 
		
	Else 
		//OB SET($vo_Response;"Error";"Resource not found.")
		//$vt_Response:=JSON Stringify($vo_Response;*)
		//TEXT TO BLOB($vt_Response;$vx_Response)
		//WEB SEND BLOB($vx_Response;".JSON")
End case 
