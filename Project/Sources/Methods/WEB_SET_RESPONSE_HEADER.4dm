//%attributes = {}

// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 08/01/19, 11:19:00
// ----------------------------------------------------
// Method: WEB_SET_RESPONSE_HEADER
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_LONGINT:C283($i; $hCount)
C_TEXT:C284($1; $vt_htmlResponseCode)
C_OBJECT:C1216(vo_inbound)
$hCount:=7
$i:=1
ARRAY TEXT:C222($at_Header; $hCount)
ARRAY TEXT:C222($at_Value; $hCount)
If (Count parameters:C259>0)
	$vt_htmlResponseCode:=$1
Else 
	If (OB Is defined:C1231(vo_inbound; "htmlResponseCode"))
		$vt_htmlResponseCode:=vo_inbound.htmlResponseCode
	Else 
		$vt_htmlResponseCode:="200 OK"  //Default
	End if 
End if 
$at_Header{$i}:="X-VERSION"
$at_Value{$i}:="HTTP/1.1"
$i:=$i+1

$at_Header{$i}:="X-STATUS"
$at_Value{$i}:=$vt_htmlResponseCode
$i:=$i+1

$at_Header{$i}:="Content-Type"
$at_Value{$i}:="application/json"
$i:=$i+1

$at_Header{$i}:="Access-Control-Allow-Origin"
$at_Value{4}:="*"
$i:=$i+1

$at_Header{$i}:="Access-Control-Allow-Credentials"
$at_Value{5}:="true"
$i:=$i+1

$at_Header{$i}:="Access-Control-Allow-Methods"
$at_Value{$i}:="POST,GET,PUT,DELETE,OPTIONS"
$i:=$i+1

$at_Header{$i}:="Access-Control-Allow-Headers"
$at_Value{$i}:="Origin, Content-Type, X-Auth-Token, content-type, authorization"


WEB SET HTTP HEADER:C660($at_Header; $at_Value)
