#INCLUDE "PROTHEUS.CH"

// Ponto de entrada utilizado para quando for realizar a copia de um produto, os campos abaixo não serão copiados 

User Function MTA010NC()

Local aCpoNC := {}
AAdd( aCpoNC, 'B1_MSBLQL' )
AAdd( aCpoNC, 'B1_ZDEV' )
AAdd( aCpoNC, 'B1_ZCOM' )
AAdd( aCpoNC, 'B1_ZFIS' )
AAdd( aCpoNC, 'B1_ZVEN' )
AAdd( aCpoNC, 'B1_ZQUA' )
AAdd( aCpoNC, 'B1_ZCMX' )
AAdd( aCpoNC, 'B1_ZPRO' )
AAdd( aCpoNC, 'B1_ZPCP' )
AAdd( aCpoNC, 'B1_ZUSER' )
AAdd( aCpoNC, 'B1_VM_I' )
AAdd( aCpoNC, 'B1_VM_GI' )
AAdd( aCpoNC, 'B1_IMPORT' )

Return (aCpoNC)

