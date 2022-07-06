//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 11/05/22, 14:57:04
// ----------------------------------------------------
// Method: REST_Get_Current_User
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)
C_TEXT:C284($1)

$vo_response:=New object:C1471

If ($1>"")
	
	$e_user:=ds:C1482.user.get($1)
	If ($e_user#Null:C1517)
		
		$vo_response.id:=$e_user.id
		$vo_response.username:=$e_user.name
		$vo_response.email:=$e_user.email
		$vo_response.type:=$e_user.type
		$vo_response.prefs:=New object:C1471
		$vo_response.prefs.lang:="en"
		
	Else 
		$vo_response.error:="Login not valid!"
	End if 
Else 
	$vo_response.error:="Login not valid.  User ID empty!"
End if 

$0:=$vo_response
