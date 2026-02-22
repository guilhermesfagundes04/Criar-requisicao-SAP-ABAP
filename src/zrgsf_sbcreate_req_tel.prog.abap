*  Faço um SELECTION-SCREEN para por na tela a minha seleção que vai ser utilizada para filtrar os dados que vão ser pesquisados. *
SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_badat FOR eban-badat OBLIGATORY,
                  s_banfn FOR eban-banfn,
                  s_matnr FOR eban-matnr.

SELECTION-SCREEN END OF BLOCK bc01.

INITIALIZATION.                          "INICIALIZAÇÃO.

* Declarações de variáveis locais para fazer tratamento das DATAS. *
  DATA: lv_data_ref TYPE sy-datum,
        lv_low      TYPE sy-datum,
        lv_high     TYPE sy-datum.


  lv_data_ref = sy-datum.                "lv_data_ref IGUAL A sy-datum (data atual).


  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'  "CHAMADA DA FUNÇÃO 'RP_LAST_DAY_OF_MONTHS' (calcular o último dia de um determinado mês)
    EXPORTING                            "EXPORTANDO
      day_in            = lv_data_ref    "PARÂMETRO day_in IGUAL A variável local lv_data_ref
    IMPORTING                            "IMPORTANDO
      last_day_of_month = lv_high.       "PARÂMETRO last_day_of_month IGUAL A variável local lv_high (Nesse contexto seria ÚLTIMO).

  " Primeiro dia do mês
  lv_low = lv_high.                      "Variável local lv_low (PRIMEIRO) IGUAL A variável local lv_high (ÚLTIMO).
  lv_low+6(2) = '01'.                    "Variável local lv_low offset + tamanho (começa no 7° caractere da string e pega 2 posições, ou seja, o dia) IGUAL A '01'
  "(0 1 2 3 4 5 6 7)
  "(Y Y Y Y M M D D)

  s_badat = VALUE #( sign   = 'I'        "SELEÇÃO s_badat IGUAL A VALOR ( SINAL IGUAL A 'I' - Incluir
                     option = 'BT'       "OPÇÃO IGUAL A 'BT' - Between (entre dois valores)
                     low    = lv_low     "Primeiro dia do mês
                     high   = lv_high ). "Último dia do mês.

  APPEND s_badat.                        "ANEXAR SELEÇÃO s_badat (inclui essa linha no range s_aedat).
