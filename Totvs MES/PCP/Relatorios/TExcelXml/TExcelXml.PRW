#INCLUDE "protheus.ch"

#DEFINE cEOL CHR(13) + CHR(10)

#DEFINE CELL_HALIGN_LEFT   1
#DEFINE CELL_HALIGN_CENTER 2
#DEFINE CELL_HALIGN_RIGHT  3

#DEFINE CELL_VALIGN_BOTTOM 1
#DEFINE CELL_VALIGN_CENTER 2
#DEFINE CELL_VALIGN_TOP    3

#DEFINE CELL_BORDER_NONE   0
#DEFINE CELL_BORDER_ALL    1
#DEFINE CELL_BORDER_LEFT   2
#DEFINE CELL_BORDER_RIGHT  3
#DEFINE CELL_BORDER_BOTTOM 4
#DEFINE CELL_BORDER_TOP    5
/*
������������������������������������������������������������������������
������������������������������������������������������������������������
��������������������������������������������������������������������ͻ��
��� Classe � TExcelXml� Autor � Deivid A.C. Lima   � Data � 14/01/09 ���
��������������������������������������������������������������������͹��
��� Desc.  � Classe para geracao de arquivo Excel Xml Dinamico.      ���
��������������������������������������������������������������������ͼ��
������������������������������������������������������������������������
������������������������������������������������������������������������
*/
Class TExcelXml

Data cFileNm	//Arquivo a ser gerado
Data cFile     //Handle do arquivo aberto para gravacao
Data aWorkSheet//Array com as planilhas
Data aConteudo //Conteudo do Excel Xml em array
Data aStyle    //Array dos estilos das celulas
Data aColSize  //Array dos tamanhos das colunas
Data aRowSize  //Array dos tamanhos das linhas

Method New(cFileNm) Constructor
Method Cabec()
Method Rodap()
Method Styles()
Method ColSize(nCol,nWidth)
Method RowSize(nRow,nHeight)
Method NewWorkSheet(cName)
Method NewRow(nHeight)
Method NewCol(cTexto,nMergeRow,nMergeCol,nStyle)
Method NewStyle(nAligHoriz,nAligVert,nBorder,cFont,nSize,lBold,lItalic,lUnderline,nColor,nBkColor)
Method GeraXml()
Method OpenXml()
Method CriaTxt()
Method IncLinha()
Method FechaTxt()

EndClass

/************************************************************
Funcao: New
Desc.: Contrutor da classe TExcelXml
*************************************************************/
Method New(cFileNm) Class TExcelXml

::cFileNm	:= cFileNm
::cFile     := 0
::aConteudo := {}
::aStyle    := {}
::aWorkSheet:= {}
::aColSize  := {}
::aRowSize  := {}

Return

/************************************************************
Funcao: Cabec
Desc.: Classe TExcelXml
*************************************************************/
Method Cabec() Class TExcelXml

Local cRet := ""

cRet += '<?xml version="1.0"?>' + cEOL
cRet += '<?mso-application progid="Excel.Sheet"?>' + cEOL
cRet += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"' + cEOL
cRet += ' xmlns:o="urn:schemas-microsoft-com:office:office"' + cEOL
cRet += ' xmlns:x="urn:schemas-microsoft-com:office:excel"' + cEOL
cRet += ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"' + cEOL
cRet += ' xmlns:html="http://www.w3.org/TR/REC-html40">' + cEOL
cRet += ' <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">' + cEOL
cRet += '  <Author>admin</Author>' + cEOL
cRet += '  <LastAuthor>admin</LastAuthor>' + cEOL
cRet += '  <Created>2009-01-14T13:09:30Z</Created>' + cEOL
cRet += '  <Version>12.00</Version>' + cEOL
cRet += ' </DocumentProperties>' + cEOL
cRet += ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">' + cEOL
cRet += '  <WindowHeight>8415</WindowHeight>' + cEOL
cRet += '  <WindowWidth>19095</WindowWidth>' + cEOL
cRet += '  <WindowTopX>120</WindowTopX>' + cEOL
cRet += '  <WindowTopY>150</WindowTopY>' + cEOL
cRet += '  <ProtectStructure>False</ProtectStructure>' + cEOL
cRet += '  <ProtectWindows>False</ProtectWindows>' + cEOL
cRet += ' </ExcelWorkbook>' + cEOL
cRet += ' <Styles>' + cEOL
cRet += '  <Style ss:ID="Default" ss:Name="Normal">' + cEOL
cRet += '   <Alignment ss:Vertical="Bottom"/>' + cEOL
cRet += '   <Borders/>' + cEOL
cRet += '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>' + cEOL
cRet += '   <Interior/>' + cEOL
cRet += '   <NumberFormat/>' + cEOL
cRet += '   <Protection/>' + cEOL
cRet += '  </Style>' + cEOL

Return(cRet)

/************************************************************
Funcao: Rodap
Desc.: Classe TExcelXml
*************************************************************/
Method Rodap() Class TExcelXml

Local cRet := "</Workbook>" + cEOL

Return(cRet)

/************************************************************
Funcao: Styles()
Desc.: Classe TExcelXml
*************************************************************/
Method Styles() Class TExcelXml

Local nI
Local cRet := ""

For nI := 1 to Len(::aStyle)
	//Alinhamento da celula Horizontal
	If ::aStyle[nI][01] == CELL_HALIGN_LEFT
		cAlignH := "Left"
	ElseIf ::aStyle[nI][01] == CELL_HALIGN_CENTER
		cAlignH := "Center"
	ElseIf ::aStyle[nI][01] == CELL_HALIGN_RIGHT
		cAlignH := "Right"
	Endif

	//Alinhamento da celula Vertical
	If ::aStyle[nI][02] == CELL_VALIGN_BOTTOM
		cAlignV := "Bottom"
	ElseIf ::aStyle[nI][02] == CELL_VALIGN_CENTER
		cAlignV := "Center"
	ElseIf ::aStyle[nI][02] == CELL_VALIGN_TOP
		cAlignV := "Top"
	Endif

	cRet += '  <Style ss:ID="s'+StrZero(nI,3)+'">'+cEOL
	cRet += '   <Alignment ss:Horizontal="'+cAlignH+'" ss:Vertical="'+cAlignV+'"/>'+cEOL

	//Bordas da celula
	If ::aStyle[nI][03] <> CELL_BORDER_NONE
		cRet += '   <Borders>'+cEOL
		If ::aStyle[nI][03] == CELL_BORDER_BOTTOM .or. ::aStyle[nI][03] == CELL_BORDER_ALL
			cRet += '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>'+cEOL
		Endif
		If ::aStyle[nI][03] == CELL_BORDER_LEFT   .or. ::aStyle[nI][03] == CELL_BORDER_ALL
			cRet += '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>'+cEOL
		Endif
		If ::aStyle[nI][03] == CELL_BORDER_RIGHT  .or. ::aStyle[nI][03] == CELL_BORDER_ALL
			cRet += '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>'+cEOL
		Endif
		If ::aStyle[nI][03] == CELL_BORDER_TOP    .or. ::aStyle[nI][03] == CELL_BORDER_ALL
			cRet += '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>'+cEOL
		Endif
		cRet += '   </Borders>'+cEOL
	Endif

//Method NewStyle(nAligHoriz,nAligVert,nBorder,cFont,nSize,lBold,lItalic,lUnderline,nColor,nBkColor)
	
	cRet += '   <Font ss:FontName="'+::aStyle[nI][04]+'" x:Family="Swiss" ss:Size="'+AllTrim(Str(::aStyle[nI][05]))+'" ss:Color="'+::aStyle[nI][09]+'"'+cEOL
	cRet += '    ss:Bold="'+IIF(::aStyle[nI][06],"1","0")+'" ss:Italic="'+IIF(::aStyle[nI][07],"1","0")+'" ss:Underline="'+IIF(::aStyle[nI][08],"Single","None")+'"/>'+cEOL
	If ::aStyle[nI][10] <> ""
		cRet += '   <Interior ss:Color="'+::aStyle[nI][10]+'" ss:Pattern="Solid"/>'+cEOL
	Else
		cRet += '   <Interior/>'+cEOL
	Endif
	cRet += '  </Style>'+cEOL
Next nI

cRet += ' </Styles>' + cEOL

Return(cRet)

/************************************************************
Funcao: ColSize
Desc.: Classe TExcelXml
*************************************************************/
Method ColSize(nCol,nWidth) Class TExcelXml

_nP := aScan(::aColSize,{|x|x[1] == nCol})

If _nP == 0
	aAdd(::aColSize,{nCol,nWidth})
Else 
	::aColSize[_nP][2] := nWidth
Endif

Return

/************************************************************
Funcao: RowSize
Desc.: Classe TExcelXml
*************************************************************/
Method RowSize(nRow,nHeight) Class TExcelXml

_nP := aScan(::aRowSize,{|x|x[1] == nRow})

If _nP == 0
	aAdd(::aRowSize,{nRow,nHeight})
Else 
	::aRowSize[_nP][2] := nHeight
Endif

Return

/************************************************************
Funcao: NewWorkSheet
Desc.: Classe TExcelXml
*************************************************************/
Method NewWorkSheet(cName) Class TExcelXml

Default cName := "Plan"+AllTrim(Str(Len(::aWorkSheet)+1))

aAdd(::aWorkSheet,cName)

Return

/************************************************************
Funcao: NewRow
Desc.: Classe TExcelXml
*************************************************************/
Method NewRow() Class TExcelXml

aAdd(::aConteudo,{})

Return

/************************************************************
Funcao: NewCol
Desc.: Classe TExcelXml
*************************************************************/
Method NewCol(cTexto,nMergeRow,nMergeCol,nStyle) Class TExcelXml

aAdd(::aConteudo[Len(::aConteudo)],{cTexto,nMergeRow,nMergeCol,nStyle,Len(::aWorkSheet)})

Return

/************************************************************
Funcao: NewStyle
Desc.: Classe TExcelXml
*************************************************************/
Method NewStyle(nAligHoriz,nAligVert,nBorder,cFont,nSize,lBold,lItalic,lUnderline,nColor,nBkColor) Class TExcelXml

Local nRet := Len(::aStyle) + 1

Default nAligHoriz := CELL_HALIGN_LEFT
Default nAligVert  := CELL_VALIGN_BOTTOM
Default nBorder    := CELL_BORDER_NONE
Default cFont      := "Calibri"
Default nSize      := 11
Default lBold      := .F.
Default lItalic    := .F.
Default lUnderline := .F.
Default nColor     := 0
Default nBkColor   := -1

cColor   := "#"+NtoC(nColor,16,6)

If nBkColor == -1
	cBkColor := ""
Else
	cBkColor := "#"+NtoC(nBkColor,16,6)
Endif

aAdd(::aStyle,{nAligHoriz,nAligVert,nBorder,cFont,nSize,lBold,lItalic,lUnderline,cColor,cBkColor})

Return(nRet)

/************************************************************
Funcao: GeraXml
Desc.: Classe TExcelXml
*************************************************************/
Method GeraXml() Class TExcelXml

Local nI
// Local cLinha

::CriaTxt()

::IncLinha(::Cabec()) //cabecalho do Xml
::IncLinha(::Styles()) //styles da planilha Xml

For nI := 1 to Len(::aWorkSheet)
	::IncLinha(' <Worksheet ss:Name="'+::aWorkSheet[nI]+'">')
	::IncLinha('  <Table x:FullColumns="1"')
	::IncLinha('   x:FullRows="1" ss:DefaultRowHeight="15">')
	
	For nJ := 1 to Len(::aColSize)
		::IncLinha('   <Column ss:Index="'+AllTrim(Str(::aColSize[nJ][1]))+'" ss:AutoFitWidth="0" ss:Width="'+AllTrim(Str(::aColSize[nJ][2]))+'"/>')
	Next nJ
	
//aAdd(::aConteudo[Len(::aConteudo)],{cTexto,nMergeRow,nMergeCol,nStyle,Len(aWorkSheet)})
	For nJ := 1 to Len(::aConteudo)
		If ::aConteudo[nJ][01][05] == nI //Verifica se a linha pertence a WorkSheet
			_nP := aScan(::aRowSize,{|x|x[1] == nJ})
			If _nP > 0
				cRowHeight := ' ss:Height="'+AllTrim(Str(::aRowSize[_nP][2]))+'"'
			Else
				cRowHeight := ''
			Endif
			::IncLinha('   <Row ss:AutoFitHeight="0"'+cRowHeight+'>')

			For nK := 1 to Len(::aConteudo[nJ])
				cMergRow := IIF(::aConteudo[nJ][nK][2] > 0,'ss:MergeDown="'+AllTrim(Str(::aConteudo[nJ][nK][2]-1))+'" ','')
				cMergCol := IIF(::aConteudo[nJ][nK][3] > 0,'ss:MergeAcross="'+AllTrim(Str(::aConteudo[nJ][nK][3]-1))+'" ','')
				cStyle   := IIF(::aConteudo[nJ][nK][4] > 0,'ss:StyleID="s'+StrZero(::aConteudo[nJ][nK][4],3)+'" ','')

				If ValType(::aConteudo[nJ][nK][1]) == "N"
					cType    := "Number"
					cConteud := AllTrim(Str(::aConteudo[nJ][nK][1]))
				ElseIf ValType(::aConteudo[nJ][nK][1]) == "D"
					cType    := "String"
					cConteud := Dtoc(::aConteudo[nJ][nK][1])
				Else
					cType    := "String"
					cConteud := ::aConteudo[nJ][nK][1]
				Endif

				::IncLinha('    <Cell '+cMergCol+cMergRow+cStyle+'><Data ss:Type="'+cType+'">'+cConteud+'</Data></Cell>')
			Next nK

			::IncLinha('   </Row>')
		Endif
	Next nJ
	
	::IncLinha('  </Table>')
	::IncLinha('  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">')
	::IncLinha('   <PageSetup>')
	::IncLinha('    <Header x:Margin="0.31496062000000002"/>')
	::IncLinha('    <Footer x:Margin="0.31496062000000002"/>')
	::IncLinha('    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024"')
	::IncLinha('     x:Right="0.511811024" x:Top="0.78740157499999996"/>')
	::IncLinha('   </PageSetup>')
	::IncLinha('   <Unsynced/>')
	::IncLinha('   <Print>')
	::IncLinha('    <ValidPrinterInfo/>')
	::IncLinha('    <PaperSizeIndex>9</PaperSizeIndex>')
	::IncLinha('    <HorizontalResolution>600</HorizontalResolution>')
	::IncLinha('    <VerticalResolution>600</VerticalResolution>')
	::IncLinha('   </Print>')
	::IncLinha('   <Selected/>')
	::IncLinha('   <Panes>')
	::IncLinha('    <Pane>')
	::IncLinha('     <Number>3</Number>')
	::IncLinha('     <RangeSelection>R1C1:R1C2</RangeSelection>')
	::IncLinha('    </Pane>')
	::IncLinha('   </Panes>')
	::IncLinha('   <ProtectObjects>False</ProtectObjects>')
	::IncLinha('   <ProtectScenarios>False</ProtectScenarios>')
	::IncLinha('  </WorksheetOptions>')
	::IncLinha(' </Worksheet>')
Next nI

::IncLinha(::Rodap()) //styles da planilha Xml

::FechaTxt()

Return

/************************************************************
Funcao: CriarTxt
Desc.: Classe TExcelXml
*************************************************************/
Method CriaTxt() Class TExcelXml
  Local lRet := .T.

  If File(::cFileNm)
    FErase(::cFileNm)
  Endif

  If (::cFile := FCreate(::cFileNm,0)) == -1
    lRet := .F.
    Conout("Erro na cria��o do arquivo "+ ::cFileNm +"." )
  Endif    
Return lRet

/************************************************************
Funcao: IncLinha
Desc.: Classe TExcelXml
*************************************************************/
Method IncLinha( cLinha ) Class TExcelXml
  FWrite( ::cFile , cLinha + cEOL )
Return

/************************************************************
Funcao: FechaTxt
Desc.: Classe TExcelXml
*************************************************************/
Method FechaTxt() Class TExcelXml
  Local lRet := .T.

  If !(fClose(::cFile))
    lRet := .F.
    ConOut("Erro ao fechar o arquivo "+ ::cFileNm +"." )
  Endif  
Return lRet

/************************************************************
Funcao: OpenXml()
Desc.: Classe TExcelXml
*************************************************************/
Method OpenXml() Class TExcelXml

Local lRet := .T.

If ! ApOleClient( 'MsExcel' )
	ConOut( "MsExcel nao instalado" )
	lRet := .F.
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( ::cFileNm ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Endif

Return(lRet)