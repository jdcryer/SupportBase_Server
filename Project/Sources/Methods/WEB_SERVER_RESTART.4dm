//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 03/05/18, 17:41:05
// ----------------------------------------------------
// Method: WEB_SERVER_RESTART
// Description
// 
//
// Parameters
// ----------------------------------------------------
//TRACE

C_TEXT:C284($CipherList; $vt_IPToListen; $vt_webRoot)
C_REAL:C285($vr_IP)
//$vt_IPToListen:="78.129.209.133"
//WEB GET OPTION(Web IP address to listen;$vt_IPToListen)
WEB STOP SERVER:C618
WEB SET OPTION:C1210(Web HSTS max age:K73:27; 31536000)  //Make sure this is over 180 days
WEB SET OPTION:C1210(Web HSTS enabled:K73:26; 1)
//$vt_webRoot:=Get 4D folder(Database folder)+"WebFolder"+Folder separator
//WEB SET ROOT FOLDER($vt_webRoot)
//WEB SET HOME PAGE("dist/index.html")
//Disabling HTTP means auto redirect cannot be done.
//WEB SET OPTION(Web HTTP enabled;0)
WEB SET OPTION:C1210(Web HTTPS enabled:K73:29; 1)


$CipherList:="ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:"+\
"ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:"+\
"ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256"
SET DATABASE PARAMETER:C642(SSL cipher list:K37:54; $CipherList)


//WEB SET OPTION(Web IP address to listen;$vt_IPToListen)
//for debug purposes
//WEB GET OPTION(Web IP address to listen;$vt_IPToListen)
WEB START SERVER:C617
