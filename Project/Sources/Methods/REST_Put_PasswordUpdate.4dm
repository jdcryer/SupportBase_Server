//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 18/08/20, 16:08:41
// ----------------------------------------------------
// Method: REST_Put_PasswordUpdate
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response; $1; $vo_request)
C_OBJECT:C1216($vo_res; $e_user)

$vo_response:=New object:C1471
$vo_request:=$1

If (OB Is defined:C1231($vo_request; "resetUUID")) & (OB Is defined:C1231($vo_request; "password"))
	
	$e_user:=ds:C1482.user.query("detail.reset.uuid == :1"; $vo_request.resetUUID).first()
	If ($e_user#Null:C1517)
		OB REMOVE:C1226($e_user.detail; "reset")
		$vt_password:=NTK HMAC Text(Storage:C1525.namak.prefix+$vo_request.password; "SHA512"; Storage:C1525.namak.key)
		$e_user.password:=$vt_password
		//$e_user.detail:=$e_user.detail
		$vo_res:=$e_user.save()
		If ($vo_res.success)
			$vo_response.success:=True:C214
		Else 
			$vo_response.error:="Error saving User record"
		End if 
	Else 
		$vo_response.error:="User not found!"
	End if 
Else 
	$vo_response.error:="Missing mandatory fields"
End if 
$0:=$vo_response