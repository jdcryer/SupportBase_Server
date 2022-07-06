//%attributes = {}
// ----------------------------------------------------
// User name (OS): Dougie
// Date and time: 11/10/17, 13:55:12
// ----------------------------------------------------
// Method: ORDA_Get_Table
// Description
// Compiler_Web
//
// Parameters
// ----------------------------------------------------

//TRACE
C_OBJECT:C1216($0; $2; $vo_Request; $vo_Response; $vo_Content; $vo_SubTemplate; $vo_selectData)
C_OBJECT:C1216($es_data; $es_sourceData; es_data)
C_COLLECTION:C1488($vc_output)
C_TEXT:C284($1; $4; $vt_TableName; $vt_relateToken; $vt_date; $vt_time; $vt_selectToken)
C_POINTER:C301($vPtr; $vp_TablePtr; $vp_sourceTablePtr)
C_BOOLEAN:C305($vb_Count; $vb_selectToken; $vb_localHost; $vb_Items; $vb_subSet; $vb_omitSet; $vb_relateCount)
C_BOOLEAN:C305($3)  //$vb_PostGet
C_LONGINT:C283(vl_userID; $vl_Offset; $vl_RecordsFound; $cp; $vl_Field_Type; $vl_startIndex; $vl_endIndex)
C_LONGINT:C283($vl_TotalChunks; $vl_PageSent; $vl_RecordsSent; $vl_PageRequested; $vl_PageSize; $vl_sourceTableNum)
C_DATE:C307($vd_date)
C_COLLECTION:C1488($vc_template; $vc_templateRecord; $vc_relateCount)
ARRAY TEXT:C222($at_Field; 0)
ARRAY TEXT:C222($at_Value; 0)
$cp:=Count parameters:C259
If ($cp>1)
	$vo_Request:=OB Copy:C1225($2)
End if 
READ ONLY:C145(*)  //$vp_TablePtr->)
ARRAY TEXT:C222($at_TableName; 0)
ARRAY LONGINT:C221($al_TableNum; 0)
GET_TABLE_TITLES(->$at_TableName; ->$al_TableNum)
$vl_FIA:=Find in array:C230($at_TableName; $4)
If ($vl_FIA>0)
	
	If ($3)
		WEB_GET_URL_PARAMETERS($1; ->$at_Field; ->$at_Value)
	Else 
		WEB GET VARIABLES:C683($at_Field; $at_Value)  //Get standard parameters
	End if 
	
	$vl_TableNum:=$al_TableNum{$vl_FIA}
	$vp_TablePtr:=Table:C252($vl_TableNum)
	$vt_TableName:=$at_TableName{$vl_FIA}
	$vl_FIA:=Find in array:C230($at_Field; "viewId")
	If ($vl_FIA>0)
		$vc_template:=ORDA_Get_View_Template(Table name:C256($vp_TablePtr); $at_Value{$vl_FIA})
	Else 
		$vc_template:=ORDA_Get_Template(Table name:C256($vp_TablePtr); "storage,relatedEntity")
	End if 
	//If ($vl_TableNum=5)
	//TRACE
	//End if 
	
	$vc_templateRecord:=ORDA_Get_Template_Rec(Table name:C256($vp_TablePtr); ""; True:C214)
	$vc_templateQuery:=ORDA_Get_Template(Table name:C256($vp_TablePtr); "")
	$vb_Count:=($1="@/Count@")
	$vb_selectToken:=($1="@/selectToken@")
	$vb_subSet:=($1="@/subSet@")
	$vb_omitSet:=($1="@/omitSet@")
	ARRAY TEXT:C222($at_headerField; 0)
	ARRAY TEXT:C222($at_headerValue; 0)
	//TRACE
	WEB GET HTTP HEADER:C697($at_headerField; $at_headerValue)
	$vl_FIA:=Find in array:C230($at_headerField; "Origin")
	If ($vl_FIA>0)  //|Used for localhost Angular development
		$vb_localHost:=($at_headerValue{$vl_FIA}="http://localhost:4200@")
	End if 
	
	//Set standard defaults
	$vl_PageRequested:=1
	$vl_PageSize:=100  //Default page size
	
	
	$vl_FIA:=Find in array:C230($at_Field; "page")
	If ($vl_FIA>0)
		$vl_PageRequested:=Num:C11($at_Value{$vl_FIA})
	End if 
	$vl_FIA:=Find in array:C230($at_Field; "pageSize")
	If ($vl_FIA>0)
		$vl_PageSize:=Num:C11($at_Value{$vl_FIA})
	End if 
	
	$vl_FIA:=Find in array:C230($at_Field; "startIndex")
	$vl_FIA2:=Find in array:C230($at_Field; "endIndex")
	If ($vl_FIA>0) | ($vl_FIA2>0)
		If ($vl_FIA>0)
			$vl_startIndex:=Num:C11($at_Value{$vl_FIA})
		End if 
		If ($vl_FIA2>0)
			$vl_endIndex:=Num:C11($at_Value{$vl_FIA2})
		End if 
	End if 
	
	$vl_FIA:=Find in array:C230($at_Field; "relateCount")
	If ($vl_FIA>0)
		$vb_relateCount:=($at_Value{$vl_FIA}="true")
	End if 
	
	//TRACE
	$vl_FIA:=Find in array:C230($at_Field; "selectToken")
	If ($vl_FIA>0)
		//TRACE
		$vt_selectToken:=$at_Value{$vl_FIA}
	End if 
	
	$vl_FIA:=Find in array:C230($at_Field; "relateToken")
	If ($vl_FIA>0)
		$vt_relateToken:=$at_Value{$vl_FIA}
	End if 
	
	Case of 
		: ($vt_selectToken#"")
			If ($vb_localHost)  //Section for local Angular development
				ARRAY LONGINT:C221($al_recordNumbers; 0)
				$vt_Doc_Path:=Get 4D folder:C485(Database folder:K5:14)+"webSelections"+Folder separator:K24:12
				$vt_Doc_Path:=$vt_Doc_Path+$vt_selectToken+".json"
				$vt_selectData:=Document to text:C1236($vt_Doc_Path)
				$vo_selectObject:=JSON Parse:C1218($vt_selectData; Is object:K8:27)
				OB GET ARRAY:C1229($vo_selectObject; "recordNumbers"; $al_recordNumbers)
				CREATE SELECTION FROM ARRAY:C640($vp_TablePtr->; $al_recordNumbers; $vt_selectToken)
			End if 
			USE NAMED SELECTION:C332($vt_selectToken)
			$es_data:=Create entity selection:C1512($vp_TablePtr->)
			$vl_FIA:=Find in array:C230($at_Field; "order_by")
			If ($vl_FIA>0)
				$es_data:=ORDA_Sort(Table:C252($vp_TablePtr); $vc_Template; $at_Value{$vl_FIA}; $es_data)
			End if 
			
			If ($vb_subSet) | ($vb_omitSet)
				
				//TRACE
				
				ARRAY LONGINT:C221($al_subSet; 0)
				If (Not:C34($vo_Request.token=Null:C1517))
					$vt_selectToken:=$vo_Request.token
				End if 
				If (Not:C34($vo_Request.subset=Null:C1517))
					OB GET ARRAY:C1229($vo_Request; "subset"; $al_subSet)
					ARRAY LONGINT:C221($al_recordNumbers; 0)
					ARRAY LONGINT:C221($al_recordNumbersNew; 0)
					If ($vb_localHost)
						ARRAY LONGINT:C221($al_recordNumbers; 0)
						$vt_Doc_Path:=Get 4D folder:C485(Database folder:K5:14)+"webSelections"+Folder separator:K24:12
						$vt_Doc_Path:=$vt_Doc_Path+$vt_selectToken+".json"
						$vt_selectData:=Document to text:C1236($vt_Doc_Path)
						$vo_selectObject:=JSON Parse:C1218($vt_selectData; Is object:K8:27)
						OB GET ARRAY:C1229($vo_selectObject; "recordNumbers"; $al_recordNumbers)
					Else 
						USE ENTITY SELECTION:C1513($es_data)
						USE NAMED SELECTION:C332($vt_selectToken)
						SELECTION TO ARRAY:C260($vp_TablePtr->; $al_recordNumbers)
					End if 
					
					If ($vb_subSet)
						For ($recIndex; 1; Size of array:C274($al_subSet))
							APPEND TO ARRAY:C911($al_recordNumbersNew; $al_recordNumbers{($al_subSet{$recIndex}+1)})
						End for 
					Else 
						For ($recIndex; Size of array:C274($al_subSet); 1; -1)
							DELETE FROM ARRAY:C228($al_recordNumbers; ($al_subSet{$recIndex}+1))
						End for 
					End if 
					If ($vb_subSet)
						COPY ARRAY:C226($al_recordNumbersNew; $al_recordNumbers)
					End if 
					
					If ($vb_selectToken)
						CREATE SELECTION FROM ARRAY:C640($vp_TablePtr->; $al_recordNumbers; $vt_selectToken)
						USE NAMED SELECTION:C332($vt_selectToken)
					Else 
						$vt_tempSelection:=Generate UUID:C1066
						CREATE SELECTION FROM ARRAY:C640($vp_TablePtr->; $al_recordNumbers; $vt_tempSelection)
						USE NAMED SELECTION:C332($vt_tempSelection)
						CLEAR NAMED SELECTION:C333($vt_tempSelection)
					End if 
					$es_data:=Create entity selection:C1512($vp_TablePtr->)
				End if 
			End if 
			
		: ($vt_relateToken#"")
			//TRACE
			
			$vl_FIA:=Find in array:C230($at_Field; "sourceTable")
			If ($vl_FIA>0)
				$vt_sourceTable:=$at_Value{$vl_FIA}
			End if 
			
			If ($vt_sourceTable#"")
				$vl_FIA:=Find in array:C230($at_TableName; $vt_sourceTable)
				If ($vl_FIA>0)
					$vl_sourceTableNum:=$al_TableNum{$vl_FIA}
					$vp_sourceTablePtr:=Table:C252($vl_sourceTableNum)
					
					If ($vb_localHost)  //Section for local Angular development
						ARRAY LONGINT:C221($al_recordNumbers; 0)
						$vt_Doc_Path:=Get 4D folder:C485(Database folder:K5:14)+"webSelections"+Folder separator:K24:12
						$vt_Doc_Path:=$vt_Doc_Path+$vt_relateToken+".json"
						$vt_selectData:=Document to text:C1236($vt_Doc_Path)
						$vo_selectObject:=JSON Parse:C1218($vt_selectData; Is object:K8:27)
						OB GET ARRAY:C1229($vo_selectObject; "recordNumbers"; $al_recordNumbers)
						CREATE SELECTION FROM ARRAY:C640($vp_sourceTablePtr->; $al_recordNumbers; $vt_relateToken)
					End if 
					USE NAMED SELECTION:C332($vt_relateToken)
					$es_sourceData:=Create entity selection:C1512($vp_sourceTablePtr->)
					
					$es_data:=ORDA_Relate($vt_sourceTable; $vt_TableName; $es_sourceData)
					$es_data:=ORDA_Firewall($vl_TableNum; $es_data)
					
				End if 
			Else 
				OB SET:C1220($vo_Response; "error"; "Missing Mandatory parameters!")
			End if 
			
			
		Else 
			//TRACE
			$es_data:=ds:C1482[Table name:C256($vp_TablePtr)].all()
			
			//***** IF REQUEST OBJECT CONTAINS A QUERY THIS WILL RETURN RESULT OTHERWISE ALL RECORDS*****
			//TRACE
			$es_data:=ORDA_Query(Table:C252($vp_TablePtr); $vc_templateQuery; $vo_Request; $es_data)
			//***** START FILTER SECTION (passed query field and values) *****
			$vl_FIA:=Find in array:C230($at_Field; "simpleFilter")
			If ($vl_FIA>0)
				$es_data:=ORDA_Simple_Filter($vl_TableNum; $at_Value{$vl_FIA}; $es_data)
			End if 
			//$es_data:=ORDA_Filter(Table($vp_TablePtr);$vc_Template;->$at_Field;->$at_Value;$es_data)
			$es_data:=ORDA_Filter(Table:C252($vp_TablePtr); $vc_templateRecord; ->$at_Field; ->$at_Value; $es_data)
			$es_data:=ORDA_Firewall($vl_TableNum; $es_data)
			
			//***** END QUERY SECTION *****
			If (Not:C34($vb_Count))  //***** Ordering Data *****
				$vl_FIA:=Find in array:C230($at_Field; "order_by")
				If ($vl_FIA>0)
					$es_data:=ORDA_Sort(Table:C252($vp_TablePtr); $vc_Template; $at_Value{$vl_FIA}; $es_data)
				End if 
				
			End if 
			//***** END ORDERING DATA CODE *****
			
			
			
	End case 
	
	//Check fields to include and exclude
	$vc_Template:=ORDA_Related_Properties($vt_TableName; $vc_Template)
	$vc_Template:=ORDA_Fields_Exclude($vc_Template; $vc_templateRecord; ->$at_Field; ->$at_Value; "id")
	
	If ($vb_relateCount)
		$vc_relateCount:=ORDA_Relate_Count($vt_TableName; $es_data)
		OB SET:C1220($vo_Response; "relateCount"; $vc_relateCount)
	End if 
	
	$vl_RecordsFound:=$es_data.length
	Case of 
		: ($vb_Count)  //Simple Count just return count
			OB SET:C1220($vo_Response; "count"; $vl_RecordsFound)
			
		: ($vb_selectToken)
			//TRACE
			If ($vt_selectToken="")
				$vt_selectToken:=vt_webSessionID+"-"+String:C10(Table:C252($vp_TablePtr))+"-"+String:C10(Size of array:C274(at_selectToken)+1)  //Generate UUID
				APPEND TO ARRAY:C911(at_selectToken; $vt_selectToken)
			End if 
			//TRACE
			
			If ($vb_localHost)
				$vt_Doc_Path:=Get 4D folder:C485(Database folder:K5:14)+"webSelections"+Folder separator:K24:12
				If (Not:C34(Test path name:C476($vt_Doc_Path)=Is a folder:K24:2))
					CREATE FOLDER:C475($vt_Doc_Path; *)
				End if 
				ARRAY LONGINT:C221($al_recordNumbers; 0)
				USE ENTITY SELECTION:C1513($es_data)
				SELECTION TO ARRAY:C260($vp_TablePtr->; $al_recordNumbers)
				OB SET ARRAY:C1227($vo_selectData; "recordNumbers"; $al_recordNumbers)
				TEXT TO DOCUMENT:C1237($vt_Doc_Path+$vt_selectToken+".json"; JSON Stringify:C1217($vo_selectData; *))
			Else 
				USE ENTITY SELECTION:C1513($es_data)
				COPY NAMED SELECTION:C331($vp_TablePtr->; $vt_selectToken)
			End if 
			
			OB SET:C1220($vo_Response; "selectToken"; $vt_selectToken)
			OB SET:C1220($vo_Response; "recordsFound"; $vl_RecordsFound)
			
		Else   //Not count send back requested selection paged.
			
			If ($vl_PageSize>1000)  //Max page size is 1000
				$vl_PageSize:=1000
			End if 
			$vl_TotalChunks:=Int:C8($vl_RecordsFound/$vl_PageSize)+Num:C11(Dec:C9($vl_RecordsFound/$vl_PageSize)>0)
			ARRAY LONGINT:C221($al_ID; 0)
			//If ($vo_property.name="price_hostVariant")
			//$vo_property.filterName:=$vt_prop+".hostVariant_variant.variant_product.*"
			//Else 
			
			If ($vl_startIndex>0) | ($vl_endIndex>$vl_startIndex)
				$vc_output:=$es_data.toCollection($vc_template.extract("filterName"); 0; $vl_startIndex; $vl_endIndex-$vl_startIndex)
			Else 
				If ($vl_PageRequested<=$vl_TotalChunks)
					$vl_Offset:=(($vl_PageRequested-1)*$vl_PageSize)
					$vc_output:=$es_data.toCollection($vc_template.extract("filterName"); 0; $vl_Offset; $vl_PageSize)
				End if 
			End if 
			//TRACE
			$vl_RecordsSent:=$vc_output.length
			$vl_PageSent:=$vl_PageRequested
			$vo_Response:=ORDA_Build_Response($vt_TableName; $vc_output; $vl_PageSent\
				; $vl_TotalChunks; $vl_RecordsSent; $vl_RecordsFound; $vl_startIndex; $vl_endIndex; $vt_selectToken)
			//TRACE
	End case   //End count/selectToken check
Else 
	OB SET:C1220($vo_Response; "error"; "Resource not found!"; "htmlResponseCode"; "404 Not Found")
End if   //End table exists check
UNLOAD RECORD:C212($vp_TablePtr->)
$0:=$vo_Response

