#include "totvs.ch"
Class Xls
	Data nF1   As Integer
	Data cFile As String
	Data cFontName  As String  
	Data nFontSize  As Float   
	Data nColSpan   As Integer 
	Data nRowSpan   As Integer 
	Data cFormat    As String  
	Data cVAlign    As String  
	Data cHAlign    As String  
	Data cForeColor As String  
	Data cBackColor As String  
	Data nPadding   As Integer 
	Data nBorder    As Integer 
	Method New(cFile)
	Method NewTable()
	Method EndTable()
	Method NewLine()
	Method EndLine()
	Method Cell(xValue,cFontName,nFontSize,nColSpan,nRowSpan,cForeColor,cBackColor,cHAlign,cVAlign)
	Method Open(cFile)
EndClass           

Method New(cFile) Class Xls
	::cFile := cFile
	::nF1 := fCreate(cFile)        
	::cFontName  := "Verdana"
	::nFontSize  := 1
	::nColSpan   := 0
	::nRowSpan   := 0
	::cFormat    := "@E 999,999,999.99"
	::cVAlign    := "TOP"
	::cHAlign    := "LEFT"
	::cForeColor := "000000"
	::cBackColor := "FFFFFF"
	::nPadding   := 1
	::nBorder    := 0	
	fWrite(::nF1,"<HTML>"+CRLF)
Return Self

Method NewTable() Class Xls
	fWrite(::nF1,Chr(9)+"<Table Width=100% Border="+cValToChar(::nBorder)+" CellPadding="+cValToChar(::nPadding)+">"+CRLF)
Return 

Method EndTable() Class Xls
	fWrite(::nF1,Chr(9)+"</Table>"+CRLF)
Return

Method NewLine() Class Xls
	fWrite(::nF1,Chr(9)+Chr(9)+"<TR>"+CRLF)
Return
                    
Method EndLine() Class Xls
	fWrite(::nF1,Chr(9)+Chr(9)+"</TR>"+CRLF)	
Return                          

Method Cell(xValue,cFontName,nFontSize,nColSpan,nRowSpan,cForeColor,cBackColor,cHAlign,cVAlign) Class Xls
	Local cSpan        := ""
	Default cFontName  := ::cFontName
	Default nFontSize  := ::nFontSize
	Default cvAlign    := ::cVAlign
	Default chAlign    := ::cHAlign         
	Default nColSpan   := ::nColSpan
	Default nRowSpan   := ::nRowSpan
	Default cForeColor := ::cForeColor
	Default cBackColor := ::cBackColor
	If ValType(xValue)=="D"
		xValue := Dtoc(xValue) 
		chAlign := "Center"
	ElseIf Valtype(xValue)=="N" 
		xValue := Transform(xValue,::cFormat)
		chAlign := "Right"
	ElseIf VAltype(xValue)=="L"	
		xValue := If(xValue,"Verdadeiro","Falso")
	Endif                
	If nColsPan>0
		cSpan += " ColSpan= "+cValToChar(nColSpan)	
	Endif                                         
	If nRowsPan>0
		cSpan += " RowSpan= "+cValToChar(nRowSpan)	
	Endif                                         
	fWrite(::nF1,Chr(9)+Chr(9)+Chr(9)+"<TD BgColor="+cBackColor+" "+cSpan+" "+" Align='"+chAlign+"' VAlign='"+cvAlign+"'><Font face='"+cFontName+"' Size="+cValToChar(nFontSize)+" Color="+cForeColor+">"+xValue+"</Font></TD>"+CRLF)
Return   

Method Open() Class XLS
	Local oEx
	fWrite(::nF1,"</HTML>")
	fClose(::nF1)
	oEx := MsExcel():New()
	oEx:WorkBooks:Open(::cFile)
	oEx:SetVisible(.T.)
Return   