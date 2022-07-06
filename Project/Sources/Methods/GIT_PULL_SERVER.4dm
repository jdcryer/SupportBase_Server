//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 26/04/22, 12:12:32
// ----------------------------------------------------
// Method: GIT_PULL_SERVER
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($vt_batch)
$vt_batch:=Get 4D folder:C485(HTML Root folder:K5:20)+"pull_server.bat"

SET ENVIRONMENT VARIABLE:C812("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS"; "false")

LAUNCH EXTERNAL PROCESS:C811("cmd.exe /C "+$vt_batch)

RELOAD PROJECT:C1739

RESTART 4D:C1292

