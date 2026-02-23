# Criar-requisicao-SAP-ABAP

**Objetivo**
Criação de requisição via BAPI. 

**Detalhamento** 

**Processos**

* Criar uma função – Nome: ZFM<iniciais>_SBCREATE_REQ.
    * Receber Parâmetros na forma de estrutura
        * EBAN-MANTR (material)
        * EBAN-MENGE (quantidade)
        * EBAN-WERKS (centro - plant)
    * Retornar Estrutura de Erro
        * Resultado (char1, “S/E”)
        * Mensagem (char, 200)
        * EBAN-BANFN (requisição)
    * Regra
        * Executar BAPI ‘BAPI_PR_CREATE’ para criar a requisição.
        * Se houver necessidade de atribuir informar mais algum campo na BAPI, utilizar a transação STVARV para parametrizar.
* Criar um relatório ALV (report) – Nome: ZR<iniciais>_SBCREATE_REQ, que será uma cópia do programa ZR<iniciais>_SBUPDATE_REQ
    * Todas as regras existentes no ZR<iniciais>_SBUPDATE_REQ são válidas.
    * Adicionar novo botão na barra de ferramentas: “Nova Requisição”. Adicionar ícone “ICON_CREATE” no botão.
        * Este botão, irá abrir uma nova tela, no formato Popup, que terá os campos: Material, Quantidade e Centro.
        * Ao confirmar, deverá executar a função ZFM<iniciais>_SBCREATE_REQ, exibindo uma mensagem com o resultado, fechar o popup e atualizar o ALV.



**Novo exercício**

**Objetivo**
Alterar programa que cria requisição, para implementar a lógica das classes de logs.

**Desenvolvimento**
* Implementar classe desenvolvida para gravar os logs gerados no log padrão. 
* Adicionar botão no ALV, para exibir os logs, dos últimos 30 dias, das requisições selecionadas. 
