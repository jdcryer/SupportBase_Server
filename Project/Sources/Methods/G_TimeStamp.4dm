//%attributes = {}
//*******************************************************************************
//* Method: G_TimeStamp
//* Description: 
//* This function will simply return the current data and time in one
//* simple string.
//* Returns YYYYMMDDHHMMSS (e.g. 20170114100346) for the current date and time by default.
//* ~ 
//* Parameters: 
//* ~ 
//* Methods called: 
//* ~ 
//* Layouts used: 
//* ~ 
//* Externals used: 
//* ~ 
//* Written by: Mehdi
//* Date written : 
// ******************************************************************************
C_TEXT:C284($0)
C_TEXT:C284($1; $2; $3; $4)
C_DATE:C307($5; $vd_Date)
C_TIME:C306($6; $vh_Time)
C_TIME:C306($vh_Time)
C_TEXT:C284($vt_DateSepatator; $vt_TimeSeparator; $vt_DatePrefix; $vt_TimePrefix)
If (Count parameters:C259>0)
	$vt_DateSepatator:=$1
End if 
If (Count parameters:C259>1)
	$vt_TimeSeparator:=$2
End if 
If (Count parameters:C259>2)
	$vt_DatePrefix:=$3
End if 
If (Count parameters:C259>3)
	$vt_TimePrefix:=$4
End if 
If (Count parameters:C259>4)
	$vd_Date:=$5
Else 
	$vd_Date:=Current date:C33(*)
End if 
If (Count parameters:C259>5)
	$vh_Time:=$6
Else 
	$vh_Time:=Current time:C178(*)
End if 

//$vh_Time:=Current time(*)
$vt_Timestring:=String:C10($vh_Time; HH MM SS:K7:1)
$0:=$vt_DatePrefix+String:C10(Year of:C25($vd_Date); "0000")+$vt_DateSepatator+String:C10(Month of:C24($vd_Date); "00")+$vt_DateSepatator+String:C10(Day of:C23($vd_Date); "00")
$0:=$0+$vt_TimePrefix+Substring:C12($vt_Timestring; 1; 2)+$vt_TimeSeparator+Substring:C12($vt_Timestring; 4; 2)+$vt_TimeSeparator+Substring:C12($vt_Timestring; 7; 2)
