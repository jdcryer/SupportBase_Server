//%attributes = {}
C_LONGINT:C283($vl_OK)
If (Is macOS:C1572)
	$vl_OK:=xlBookRegister("ALLRFWW7G995B006")  //Mac
Else 
	$vl_OK:=xlBookRegister("H11R0ARREWW5K755")  //Windows
End if 
If ($vl_OK=0)
	ALERT:C41("Excel plugin license not valid!")
End if 
