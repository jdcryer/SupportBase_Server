//%attributes = {}
//WEB_REDIRECT

C_TEXT:C284($1)
C_TEXT:C284($vt_Request; $vt_Page)

If (Count parameters:C259>0)
	$vt_Request:=$1
Else 
	$vt_Request:="Logout"
End if 
//TRACE
Case of 
	: ($vt_Request="@GetRedirect")
		WEB SEND TEXT:C677("dist/index.html")
		
	: ($vt_Request="@Logout")
		//TRACE
		//$vt_Page:="/login.html?logout=true"
		WEB LEGACY CLOSE SESSION:C1208(WEB Get current session ID:C1162)
		$vt_Page:="/logout.html?logout=true"
		WEB SEND HTTP REDIRECT:C659($vt_Page)
		
		//WEB_LOGOUT 
		
	: ($vt_Request="@Login")
		$vt_Page:="/login.html"  //?logout=false"
		//  WEB_LOGOUT 
		WEB SEND HTTP REDIRECT:C659($vt_Page)
		
		
End case 