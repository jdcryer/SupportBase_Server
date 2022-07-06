//%attributes = {}
C_TEXT:C284($RegKey)
C_LONGINT:C283($0)

If (Is macOS:C1572)
	$RegKey:="QYYZ5FRFY5M44VGUSU4G"  //Mac
Else 
	$RegKey:="WBBGG7GWYYPOORRHRPSS"  //Windows
End if 
$0:=NTK Register($RegKey)

