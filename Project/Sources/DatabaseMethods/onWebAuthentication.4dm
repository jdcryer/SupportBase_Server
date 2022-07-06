//ON WEB AUTHENTICATION
//compiler_web
C_TEXT:C284($1; $2; $3; $4; $5; $6)
C_TEXT:C284(vt_accountID; vt_webSessionID; $username; $password; $vt_Page)
C_TEXT:C284($vt_HTTP_Header; $vt_HTTP_Body; $vt_Function)
C_BOOLEAN:C305($0; $state; $vb_postQuery; $vb_apiRequest; $vb_appRequest; $vb_printRequest)
C_LONGINT:C283($vl_FIA)
//Compiler_Web
$username:=$5  //Wildcard_Remove ($5)
$password:=$6

Case of 
	: ($2="OPTIONS@") | ($1="/images/@") | ($1="/help/@") | ($1="/WEB_REDIRECT/LOGOUT") | ($1="/WEB_REDIRECT/GetRedirect")
		$state:=True:C214
		
	: ($2="@Origin: http://localhost:@") | ($2="@Host: 192.168.1.35:8085@")  //Development hack
		C_TEXT:C284($passwordHash)
		
		//Telekinetix
		//vt_userID:="6A5CEA3BC08FF2429C193E86B88B76A5"
		//vt_accountID:="5B52974FEF73384B942D2B3BC9C57A41"
		
		//Xylem
		vt_userID:="6A5CEA3BC08FF2429C193E86B88B76A5"
		vt_accountID:="26CF12A9153AC14D8CCE1233D60FE600"
		
		$e_user:=ds:C1482.user.get(vt_userID)
		vo_currentUser:=$e_user.toObject()
		
		$state:=True:C214
		
	: ($1="/api/reloadServer")
		$state:=True:C214
		
	Else 
		//TRACE
		
		Case of 
			: ($1="/api@")
				$vb_apiRequest:=True:C214
			: ($1="/app@") | ($1="/dist@") | ($1="/4DCGI@")
				$vb_appRequest:=True:C214
			: ($1="/print@")
				$vb_printRequest:=True:C214
		End case 
		
		If ($vb_printRequest) | ($vb_apiRequest) | ($vb_appRequest)
			$vb_postQuery:=(Position:C15("/query"; $1)>0) & ($2="POST@")
			$vt_Function:=Replace string:C233($1; "api/"; "")
			$vt_Function:=Replace string:C233($vt_Function; "app/"; "")
			$vt_Function:=Replace string:C233($vt_Function; "/count"; "")
			$vt_Function:=Replace string:C233($vt_Function; "/query"; "")
			$vt_Function:=Replace string:C233($vt_Function; "/"; "")
			$vl_Pos:=Position:C15("?"; $vt_Function)
			If ($vl_Pos>0)
				$vt_Function:=Substring:C12($vt_Function; 1; ($vl_Pos-1))
			End if 
			If ($vb_appRequest) & (($vt_Function="version") | ($vt_Function="propertyList") | ($vt_Function="currentUser") | ($vt_Function="checkreset") | ($vt_Function="passwordUpdate") | ($vt_Function="resetRequest"))
				$state:=True:C214
			End if 
		End if 
		
		
		If (Not:C34($state))
			Case of 
				: ($vb_appRequest) | ($vb_printRequest)
					If (vt_userID="") | ($vt_Function="login")
						C_TEXT:C284($passwordHash)
						$passwordHash:=NTK HMAC Text(Storage:C1525.namak.prefix+$password; "SHA512"; Storage:C1525.namak.key)
						QUERY:C277([user:4]; [user:4]username:2=$username; *)
						QUERY:C277([user:4];  & ; [user:4]password:3=$passwordHash)
						If (Records in selection:C76([user:4])=1)
							vt_userID:=[user:4]id:1
							$e_user:=ds:C1482.user.get(vt_userID)
							vo_currentUser:=$e_user.toObject()
							$state:=True:C214
						End if 
					Else 
						$state:=True:C214
					End if 
					
					//: ($vb_apiRequest)
					
					//C_TEXT($passwordHash)
					//$passwordHash:=NTK HMAC Text(Storage.namak.prefix+$password; "SHA512"; Storage.namak.key)
					//READ ONLY([apiKey])
					//QUERY([apiKey]; [apiKey]name=$username; *)
					//QUERY([apiKey];  & ; [apiKey]key=$passwordHash)
					//If (Records in selection([apiKey])=1)
					//vt_accountID:=[apiKey]fk_account
					//$state:=True
					//End if 
					
			End case 
		End if 
		
		If (vt_webSessionID#"DEV")
			vt_webSessionID:=WEB Get current session ID:C1162
		End if 
		
		If (Not:C34($state)) & ($vb_appRequest)
			If ($vt_Function="login")
				WEB_SET_RESPONSE_HEADER
				$vo_Response:=New object:C1471
				$vo_Response.response:="Failed"
				WEB SEND TEXT:C677(JSON Stringify:C1217($vo_Response))
			Else 
				WEB SEND FILE:C619("dist/index.html")
			End if 
		End if 
		
End case 
UNLOAD RECORD:C212([user:4])

$0:=$state

