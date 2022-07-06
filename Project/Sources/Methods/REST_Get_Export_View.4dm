//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 07/09/20, 15:37:37
// ----------------------------------------------------
// Method: REST_Get_Export_View
// Description
// Exports a given selectToken's data to CSV / Excel.
// Format defined by given ViewID
// Parameters
// $0 - Object - response
// ----------------------------------------------------

C_OBJECT:C1216($0; $vo_response)
C_OBJECT:C1216($e_view; $e_record; $es_records; $vo_datafield; $vo_column)
C_TEXT:C284($vt_viewId; $vt_selectToken; $vt_format)
C_TEXT:C284($vt_filename; $vt_filepath)
C_POINTER:C301($vp_table)
C_BOOLEAN:C305($vb_localHost)

ARRAY TEXT:C222($at_field; 0)
ARRAY TEXT:C222($at_value; 0)

ARRAY TEXT:C222($at_tableName; 0)
ARRAY LONGINT:C221($al_tableNum; 0)

$vo_response:=New object:C1471

WEB GET VARIABLES:C683($at_field; $at_value)
$vl_fia:=Find in array:C230($at_field; "selectToken")
If ($vl_fia>0)
	$vt_selectToken:=$at_value{$vl_fia}
End if 

$vl_fia:=Find in array:C230($at_field; "viewId")
If ($vl_fia>0)
	$vt_viewId:=$at_value{$vl_fia}
End if 

$vl_fia:=Find in array:C230($at_field; "format")
If ($vl_fia>0)
	$vt_format:=$at_value{$vl_fia}
End if 

ARRAY TEXT:C222($at_headerField; 0)
ARRAY TEXT:C222($at_headerValue; 0)
WEB GET HTTP HEADER:C697($at_headerField; $at_headerValue)
$vl_FIA:=Find in array:C230($at_headerField; "Origin")
If ($vl_FIA>0)  //|Used for localhost Angular development
	$vb_localHost:=($at_headerValue{$vl_FIA}="http://localhost:4200@")
End if 

If ($vt_selectToken#"") & ($vt_viewId#"") & ($vt_format#"")
	//TRACE
	$e_view:=ds:C1482.interface.get($vt_viewId)
	If ($e_view#Null:C1517)
		
		GET_TABLE_TITLES(->$at_tableName; ->$al_tableNum)
		$vl_fia:=Find in array:C230($at_tableName; $e_view.handle)
		If ($vl_fia>0)
			$vp_table:=Table:C252($al_tableNum{$vl_fia})
			
			If ($vb_localHost)  //Section for local Angular development
				ARRAY LONGINT:C221($al_recordNumbers; 0)
				$vt_Doc_Path:=Get 4D folder:C485(Database folder:K5:14)+"webSelections"+Folder separator:K24:12
				$vt_Doc_Path:=$vt_Doc_Path+$vt_selectToken+".json"
				$vt_selectData:=Document to text:C1236($vt_Doc_Path)
				$vo_selectObject:=JSON Parse:C1218($vt_selectData; Is object:K8:27)
				OB GET ARRAY:C1229($vo_selectObject; "recordNumbers"; $al_recordNumbers)
				CREATE SELECTION FROM ARRAY:C640($vp_table->; $al_recordNumbers; $vt_selectToken)
			End if 
			
			USE NAMED SELECTION:C332($vt_selectToken)
			$es_records:=Create entity selection:C1512($vp_table->)
			$vt_reportFolder:=Get 4D folder:C485(Database folder:K5:14)+"Webfolder"+Folder separator:K24:12+"reports"+Folder separator:K24:12
			If (Not:C34(Test path name:C476($vt_reportFolder)=Is a folder:K24:2))
				CREATE FOLDER:C475($vt_reportFolder; *)
			End if 
			
			Case of 
				: ($vt_format="excel")
					
					C_LONGINT:C283($vl_workbook; $vl_worksheet; $vl_hFormat; $vl_hFont; $vl_numberFormat; $vl_row; $vl_col)
					
					$vt_filename:="Export_"+G_TimeStamp+".xlsx"
					
					$vl_workbook:=xlBookCreateXML
					xlBookSetDefaultFont($vl_workbook; "Calibri"; 10)
					$vl_worksheet:=xlBookAddSheet($vl_workbook; "Export View")
					
					$vl_hFormat:=xlBookAddFormat($vl_workbook)
					$vl_hFont:=XL_Create_Font($vl_workbook; "Arial"; 10; 1)
					xlFormatSetFont($vl_hFormat; $vl_hFont)
					
					$vl_numberFormat:=xlBookAddFormat($vl_workbook)
					xlFormatSetNumFormat($vl_numberFormat; 1)
					
					$vl_row:=1
					$vl_col:=1
					For each ($vo_column; $e_view.detail.columns)
						xlSheetSetCellText($vl_worksheet; $vl_row; $vl_col; $vo_column.label; $vl_hFormat)
						xlSheetSetColumnWidth($vl_worksheet; $vl_col; 15)
						$vl_col:=$vl_col+1
					End for each 
					//TRACE
					$vl_row:=2
					For each ($e_record; $es_records)
						$vl_col:=1
						For each ($vo_datafield; $e_view.detail.datafields)
							Case of 
								: ($vo_datafield.type="string") | ($vo_datafield.type="boolean") | ($vo_datafield.type="object")
									xlSheetSetCellText($vl_worksheet; $vl_row; $vl_col; String:C10(MISC_Parse_Entity_Datafield($e_record; $vo_datafield.name)))
									
								: ($vo_datafield.type="number")
									xlSheetSetCellNumber($vl_worksheet; $vl_row; $vl_col; Num:C11(MISC_Parse_Entity_Datafield($e_record; $vo_datafield.name)); $vl_numberFormat)
									
							End case 
							$vl_col:=$vl_col+1
						End for each 
						$vl_row:=$vl_row+1
					End for each 
					
					xlBookSaveFile($vl_workbook; $vt_reportFolder+$vt_filename)
					xlBookRelease($vl_workbook)
					
					$vo_response.filename:=$vt_filename
					
				: ($vt_format="csv")
					C_TIME:C306($vh_doc)
					C_TEXT:C284($vt_row)
					
					$vt_filename:="Export_"+G_TimeStamp+".csv"
					$vh_doc:=Create document:C266($vt_reportFolder+$vt_filename; "CSV")
					If (OK=1)
						//Process Header
						$vt_row:=""
						$vl_col:=0
						For each ($vo_column; $e_view.detail.columns)
							$vl_col:=$vl_col+1
							If ($vl_col>1)
								$vt_row:=$vt_row+","
							End if 
							$vt_row:=$vt_row+$vo_column.label
						End for each 
						SEND PACKET:C103($vh_doc; $vt_row+Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40))
						
						//Process Data
						For each ($e_record; $es_records)
							$vt_row:=""
							$vl_col:=0
							For each ($vo_datafield; $e_view.detail.datafields)
								$vl_col:=$vl_col+1
								Case of 
									: ($vo_datafield.type="string") | ($vo_datafield.type="object")
										$vt_columnText:=String:C10(MISC_Parse_Entity_Datafield($e_record; $vo_datafield.name))
										//Replace any double quotes with 2 double quotes
										$vt_columnText:=Replace string:C233($vt_columnText; Char:C90(Double quote:K15:41); (Char:C90(Double quote:K15:41)*2))
										If (Position:C15(","; $vt_columnText)>0)  //If the string contains a comma then quote it.
											$vt_columnText:=Char:C90(Double quote:K15:41)+$vt_columnText+Char:C90(Double quote:K15:41)
										End if 
										
									: ($vo_datafield.type="boolean")
										$vt_columnText:=String:C10(MISC_Parse_Entity_Datafield($e_record; $vo_datafield.name))
										
									: ($vo_datafield.type="number")
										$vt_columnText:=String:C10(Num:C11(MISC_Parse_Entity_Datafield($e_record; $vo_datafield.name)))
										
								End case 
								If ($vl_col>1)
									$vt_row:=$vt_row+","
								End if 
								$vt_row:=$vt_row+$vt_columnText
							End for each 
							SEND PACKET:C103($vh_doc; $vt_row+Char:C90(Carriage return:K15:38)+Char:C90(Line feed:K15:40))
						End for each 
						
						CLOSE DOCUMENT:C267($vh_doc)
						$vo_response.filename:=$vt_filename
					Else 
						$vo_response.error:="File not created!"
						
					End if 
					
			End case 
			
			
		End if 
	Else 
		$vo_response.error:="View not found!"
	End if 
Else 
	$vo_response.error:="Missing mandatory data!"
End if 

$0:=$vo_response