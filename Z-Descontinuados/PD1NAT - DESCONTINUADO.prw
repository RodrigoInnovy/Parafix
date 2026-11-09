#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PD1NAT   ºAutor  ³Silverto T. Hayakawaº Data ³ Mar/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza a conta contabil do item da nota conforme a natur º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Parafix                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PD1Nat()
   cArqTxt := "PD1Nat.txt"
   nHdl    := fCreate(cArqTxt)
   cEOL    := chr(13)+chr(10)
   if nHdl == -1
      MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
      Return
   endif
   ApMsgAlert("Aguarde processando a manutencao")
   cBuffer  := "Nota Fiscal;Serie;Item;Conta" + cEOL
   fWrite(nHdl,cBuffer)
   dbSelectArea("SE2")
   dbSetOrder(6)
   dbSelectArea("SED")
   dbSetOrder(1)
   dbSelectArea("SD1")
   dbGoTop()
   while !eof()
      if substr(SD1->D1_TES,2,1)=='S' //.and. empty(SD1->D1_CONTAaa)
         if SE2->(dbSeek(xFilial("SE2")+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_SERIE+SD1->D1_DOC))
            if SED->(dbSeek(xFilial("SED")+SE2->E2_NATUREZ))
               if !empty(SED->ED_Conta)
                  recLock("SD1",.f.)
                  SD1->D1_Conta := SED->ED_Conta
                  msUnlock()
                  cBuffer := "'" + SD1->D1_DOC + ";'" + SD1->D1_Serie  + ";'" + SD1->D1_Item + ";'" + SD1->D1_Conta + ";" + cEOL
                  fWrite(nHdl,cBuffer)
               endif
            endif
         endif
      endif
      dbSelectArea("SD1")
      dbSkip()
   enddo
   ApMsgStop("Atualizacao encerrada com sucesso, gerado log no system "+cArqTxt)
   fClose(nHdl)
Return()
