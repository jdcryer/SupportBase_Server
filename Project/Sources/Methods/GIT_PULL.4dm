//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 04/01/18, 16:53:08
// ----------------------------------------------------
// Method: GIT_PULL
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($vt_batch)
$vt_batch:=Get 4D folder:C485(HTML Root folder:K5:20)+"pull.bat"

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")

LAUNCH EXTERNAL PROCESS:C811("cmd.exe /C "+$vt_batch)

