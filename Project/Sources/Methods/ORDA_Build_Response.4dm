//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 24/01/18, 11:54:07
// ----------------------------------------------------
// Method: ORDA_Build_Response
// Description
// Creates standard header and attaches the passed list with the passed name.
// Returns the object to be sent.
// Parameters
C_TEXT:C284($1)  //Name of list
C_COLLECTION:C1488($2)  //Collection
C_LONGINT:C283($3; $4; $5; $6)  //Page, PageCount, RecordsSent & RecordsFound
C_OBJECT:C1216($0; $vo_Response; $vo_Content)
// ----------------------------------------------------

$vo_Response:=New object:C1471
$vo_Content:=New object:C1471
$vo_Content.page:=$3  //$vl_PageSent
$vo_Content.pageCount:=$4  //$vl_TotalChunks
$vo_Content.recordsSent:=$5  //$vl_RecordsSent
$vo_Content.recordsFound:=$6  //$vl_RecordsFound
$vo_Content[$1]:=$2
$vo_Response.response:=$vo_Content
//$vo_Response.htmlResponseCode:="200 OK"
$0:=OB Copy:C1225($vo_Response)
