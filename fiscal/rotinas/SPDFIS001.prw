User Function SPDFIS001
Local aTipo := ParamIXB[1]

//ponto de entrada que vincula o Tipo do Produto com o codigo correto do SPED

aTipo := {{"ME","00"},;
          {"MD|MP","01"},;
          {"EB|EM","02"},;
          {"PE|PI","03"},;
          {"PA|PD","04"},;
          {"MS","06"},;
          {"MA|GG|IN|MC|PM","07"},;
          {"AI","08"},;
          {"MO|SV","09"},;
          {"GN","99"}}

Return aTipo
