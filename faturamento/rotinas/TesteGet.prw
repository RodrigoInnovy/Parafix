#include "protheus.ch"

 

User Function TesteGet()

 

Local oDlg, oButton, oCombo, cCombo, aItems:= {"item1","item2","item3"}

cCombo:= aItems[2]

DEFINE MSDIALOG oDlg FROM 0,0 TO 150,300 PIXEL TITLE "Meu Combo"

oCombo:= tComboBox():New(10,10,{|u|if(PCount()>0,cCombo:=u,cCombo)},;
aItems,100,20,oDlg,,{||MsgStop("Mudou item")};
,,,,.T.,,,,,,,,,"cCombo")

// Botão para fechar a janela

@ 40,10 BUTTON oButton PROMPT "Confirmar" OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

MsgStop( "O valor é "+cCombo )

 

Return nil
