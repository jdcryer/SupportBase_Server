//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 18/08/20, 12:00:17
// ----------------------------------------------------
// Method: REST_Put_Reset_Request
// Description
// Creates Reset request in [messageQueue] if given email
// address matches an existing account.
// Parameters
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_request; $1; $vo_response)
C_OBJECT:C1216($e_user; $vo_res; $e_msg)
C_TEXT:C284($vt_resetUUID; $vt_timeout)
C_DATE:C307($vd_date)
C_TIME:C306($vh_time)

$vo_request:=$1
$vo_response:=New object:C1471

If (OB Is defined:C1231($vo_request; "email"))
	$e_user:=ds:C1482.user.query("email == :1"; $vo_request.email).first()
	If ($e_user#Null:C1517)
		$vt_resetUUID:=Generate UUID:C1066
		$vd_date:=Current date:C33
		$vh_time:=Current time:C178+?01:00:00?
		If ($vh_time>?24:00:00?)
			$vd_date:=Add to date:C393($vd_date; 0; 0; 1)
			$vh_time:=$vh_time-?24:00:00?
		End if 
		
		$vt_timeout:=String:C10($vd_date; ISO date:K1:8; $vh_time)
		
		$e_user.detail.reset:=New object:C1471
		$e_user.detail.reset.uuid:=$vt_resetUUID
		$e_user.detail.reset.timeout:=$vt_timeout
		$vo_res:=$e_user.save()
		If ($vo_res.success)
			
			//$e_msg:=ds.messageQueue.new()
			//$e_msg.created:=String(Current date; ISO date; Current time)
			//$e_msg.detail:=New object
			//$e_msg.detail.type:="passwordReset"
			//Case of 
			//: ($e_user.type="sponsor")
			//$e_msg.detail.fk_sponsor:=$e_user.user_sponsor.id
			//: ($e_user.type="host")
			//$e_msg.detail.fk_sponsor:=""
			//: ($e_user.type="company")
			////$e_msg.detail.fk_sponsor:=$e_user.user_company.company_sponsor.id
			//$e_msg.detail.fk_sponsor:=$e_user.user_company.company_companySponsor.fk_sponsor
			//: ($e_user.type="warehouse")
			////$e_msg.detail.fk_sponsor:=$e_user.user_warehouse.warehouse_company.company_sponsor.id
			//$e_msg.detail.fk_sponsor:=$e_user.user_warehouse.warehouse_company.company_companySponsor.fk_sponsor
			//: ($e_user.type="system")
			//$e_msg.detail.fk_sponsor:=""
			//End case 
			//$e_msg.detail.content:=New object
			//$e_msg.detail.content.username:=$e_user.name
			//$e_msg.detail.content.resetUUID:=$vt_resetUUID
			//$e_msg.detail.recipients:=New collection($e_user.email)
			//$vo_res:=$e_msg.save()
			
			If ($vo_res.success)
				$vo_response.success:=True:C214
			Else 
				$vo_response.error:="Could not create messageQueue record"
			End if 
		Else 
			$vo_response.error:="Could not update user record"
		End if 
	Else 
		$vo_response.error:="User not found"
	End if 
Else 
	$vo_response.error:="Missing mandatory field: email"
End if 

$0:=$vo_response
