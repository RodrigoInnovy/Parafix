USE [Protheus12]
GO
/****** Object:  StoredProcedure [dbo].[MA330CP_01]    Script Date: 01/07/2023 10:18:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author Alexander P. Silva>
-- Create date: <Create 2023/04/12>
-- Description:	<Procedure custo em partes com regra das partes>
-- =============================================
CREATE PROCEDURE [dbo].[MA330CP_01] (
    @IN_FILIALCOR Char( 02 ) ,
    @IN_COD Char( 15) ,
    @OUT_RESULTADO Integer  output ) AS

-- Declaracoes de variaveis
DECLARE @cFil_SB1 Char( 2)
DECLARE @cB1_TIPO Char( 2)
BEGIN
   EXEC XFILIAL_01_01 'SB1' , @IN_FILIALCOR , @cFil_SB1 output

   -- Select que efetua o filtro na tabela SB1 do referido  produto que a rotina esta processando o custo
   -- Campo personalizado para a validação do custo SB1->B1_TIPO

   SELECT @cB1_TIPO  = B1_TIPO
     FROM SB1010
     WHERE B1_FILIAL  = @cFil_SB1  and B1_COD  = @IN_COD and D_E_L_E_T_  = ' '
 
   -- Total de partes ja com a outros para o nosso caso são 2 partes distintas e a 3 como outros
   SET @OUT_RESULTADO  = 3
   IF @cB1_TIPO  IN ('MP','EM','SV','MS','MA','ME','PM')
   BEGIN
      SET @OUT_RESULTADO  = 1
   END

   IF @cB1_TIPO  = 'MO'
   BEGIN
      SET @OUT_RESULTADO  = 2
   END
   
END
