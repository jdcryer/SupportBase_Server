//%attributes = {}
C_OBJECT:C1216($vo_namak)
C_TEXT:C284($vt_keyFile; $vt_text; $vt_secFolder; $vt_privateKeyFile; $vt_publicKeyFile)
C_BLOB:C604($vx_blob; $vx_privKey; $vx_pubKey)
C_TIME:C306($vh_doc)
$vt_secFolder:=Get 4D folder:C485(Database folder:K5:14)+"Preferences"+Folder separator:K24:12+"Security"+Folder separator:K24:12
$vt_privateKeyFile:=$vt_secFolder+"privKey.txt"
$vt_publicKeyFile:=$vt_secFolder+"pubKey.txt"
If (Not:C34(Test path name:C476($vt_secFolder)=Is a folder:K24:2))
	CREATE FOLDER:C475($vt_secFolder; *)
	GENERATE ENCRYPTION KEYPAIR:C688($vx_privKey; $vx_pubKey; 2048)
	BLOB TO DOCUMENT:C526($vt_privateKeyFile; $vx_privKey)
	BLOB TO DOCUMENT:C526($vt_publicKeyFile; $vx_pubKey)
Else 
	DOCUMENT TO BLOB:C525($vt_privateKeyFile; $vx_privKey)
	DOCUMENT TO BLOB:C525($vt_publicKeyFile; $vx_pubKey)
End if 
$vt_keyFile:=Get 4D folder:C485(Database folder:K5:14)+"namak.txt"
If (Not:C34(Test path name:C476($vt_keyFile)=Is a document:K24:1))  //If document does not exist
	$vo_keyData:=New object:C1471
	$vo_keyData.namak:="5ymb0!zX3("
	$vo_keyData.key:=Generate UUID:C1066
	$vt_text:=JSON Stringify:C1217($vo_keyData; *)
	VARIABLE TO BLOB:C532($vt_text; $vx_blob; *)
	ENCRYPT BLOB:C689($vx_blob; $vx_privKey)
	BLOB TO DOCUMENT:C526($vt_keyFile; $vx_blob)
Else 
	DOCUMENT TO BLOB:C525($vt_keyFile; $vx_blob)
	DECRYPT BLOB:C690($vx_blob; $vx_pubKey)
	BLOB TO VARIABLE:C533($vx_blob; $vt_text)
	$vo_keyData:=JSON Parse:C1218($vt_text; Is object:K8:27)
End if 

Use (Storage:C1525)
	$vo_namak:=New shared object:C1526("prefix"; $vo_keyData.namak; \
		"key"; $vo_keyData.key)
	Storage:C1525.namak:=$vo_namak
End use 