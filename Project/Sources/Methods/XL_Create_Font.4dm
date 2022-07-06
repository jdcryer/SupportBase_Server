//%attributes = {}

// ----------------------------------------------------
// User name (OS): Tom
// Date and time: 07/09/17, 16:50:48
// ----------------------------------------------------
// Method: XL_Create_Font
// Description
// 
// Returns Longint Font for use with XL Plugin
//
// Parameters
// 1. Workbook   2. Font Name   3. Size 
// 4. Magic Number: 1 Bold; 2 Italic; 4 Underline; 8 Strikeout
// 5. Hex Colour   6. Script
// ----------------------------------------------------

C_LONGINT:C283($0; $1; $vl_workbook; ${3}; $vl_Font; $cp)
C_TEXT:C284($2)
$cp:=Count parameters:C259
$vl_workbook:=$1
$vl_Font:=xlBookAddFont($vl_workbook)
xlFontSetName($vl_Font; $2)
xlFontSetSize($vl_Font; $3)

If ($cp>3)
	Case of 
		: ($4=1)
			xlFontSetBold($vl_Font; 1)
			
		: ($4=2)
			xlFontSetItalic($vl_Font; 1)
			
		: ($4=3)
			xlFontSetBold($vl_Font; 1)
			xlFontSetItalic($vl_Font; 1)
			
		: ($4=4)
			xlFontSetUnderline($vl_Font; 1)
			
		: ($4=5)
			xlFontSetBold($vl_Font; 1)
			xlFontSetUnderline($vl_Font; 1)
			
		: ($4=6)
			xlFontSetItalic($vl_Font; 1)
			xlFontSetUnderline($vl_Font; 1)
			
		: ($4=7)
			xlFontSetBold($vl_Font; 1)
			xlFontSetItalic($vl_Font; 1)
			xlFontSetUnderline($vl_Font; 1)
			
		: ($4=8)
			xlFontSetStrikeOut($vl_Font; 1)
			
		: ($4=9)
			xlFontSetBold($vl_Font; 1)
			xlFontSetStrikeOut($vl_Font; 1)
			
		: ($4=10)
			xlFontSetItalic($vl_Font; 1)
			xlFontSetStrikeOut($vl_Font; 1)
			
		: ($4=11)
			xlFontSetBold($vl_Font; 1)
			xlFontSetItalic($vl_Font; 1)
			xlFontSetStrikeOut($vl_Font; 1)
			
		: ($4=12)
			xlFontSetUnderline($vl_Font; 1)
			xlFontSetStrikeOut($vl_Font; 1)
			
		: ($4=13)
			xlFontSetBold($vl_Font; 1)
			xlFontSetUnderline($vl_Font; 1)
			xlFontSetStrikeOut($vl_Font; 1)
			
		: ($4=14)
			xlFontSetItalic($vl_Font; 1)
			xlFontSetUnderline($vl_Font; 1)
			xlFontSetStrikeOut($vl_Font; 1)
			
		: ($4=15)
			xlFontSetBold($vl_Font; 1)
			xlFontSetItalic($vl_Font; 1)
			xlFontSetUnderline($vl_Font; 1)
			xlFontSetStrikeOut($vl_Font; 1)
		Else 
			
	End case 
End if 
If ($cp>4)
	xlFontSetColor($vl_Font; $5)
End if 
If ($cp>5)
	xlFontSetScript($vl_Font; $6)
End if 
$0:=$vl_Font

