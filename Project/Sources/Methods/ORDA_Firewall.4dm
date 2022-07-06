//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 13/03/19, 14:10:44
// ----------------------------------------------------
// Method: REST_FIREWALL_SELECTION
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_LONGINT:C283($1; $3; $vl_TableNum; $cp; $vl_deviceJobStatus)
C_OBJECT:C1216($2)
$vl_TableNum:=$1
$cp:=Count parameters:C259
If ($cp>2)
	$vl_deviceJobStatus:=$3
Else 
	$vl_deviceJobStatus:=-1
End if 
$0:=$2

Case of 
		//: ($vl_TableNum=Table(->[product]))
		//$0:=$2.query("fk_account = :1"; vt_accountID)
		
		//: ($vl_TableNum=Table(->[scanJob]))
		//$0:=$2.query("fk_account = :1"; vt_accountID)
		//If ($vl_deviceJobStatus>0)
		//$0:=$0.query("scanJob_device.status < :1"; $vl_deviceJobStatus)
		//End if 
		
		//: ($vl_TableNum=Table(->[scanItem]))
		//$0:=$2.query("scanItem_scanJob.fk_account = :1"; vt_accountID)
		
		//: ($vl_TableNum=Table(->[device]))
		//$0:=$2.query("fk_account = :1"; vt_accountID)
		
		//: ($vl_TableNum=Table(->[file]))
		//$0:=$2.query("fk_account = :1"; vt_accountID)
		
End case 
