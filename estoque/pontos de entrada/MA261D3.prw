#Include "Protheus.ch"

User Function MA261D3()

Local aAreaSD3 := SD3->(GetArea())
Local nPos     := PARAMIXB

if !empty(GDFieldGet("D3_ZZOP",nPos))
	RecLock("SD3",.F.)
	SD3->D3_ZZOP := GDFieldGet("D3_ZZOP",nPos)
	MsUnLock()
	Commit
endif

if !empty(GDFieldGet("D3_ZZRNC",nPos))
	RecLock("SD3",.F.)
	SD3->D3_ZZRNC := GDFieldGet("D3_ZZRNC",nPos)
	MsUnLock()
	Commit
endif

if !empty(GDFieldGet("D3_ZZRNCOB",nPos))
	RecLock("SD3",.F.)
	SD3->D3_ZZRNCOB := GDFieldGet("D3_ZZRNCOB",nPos)
	MsUnLock()
	Commit
endif

if !empty(GDFieldGet("D3_RNCVA",nPos))
	RecLock("SD3",.F.)
	SD3->D3_VALRN := GDFieldGet("D3_RNCVA",nPos)
	MsUnLock()
	Commit
endif

if !empty(GDFieldGet("D3_ZZRASTR",nPos))// Criado por Gabriel Araujo
	RecLock("SD3",.F.)
	SD3->D3_ZZRASTR := GDFieldGet("D3_ZZRASTR",nPos)
	MsUnLock()
	Commit
endif

RestArea(aAreaSD3)

Return Nil
 