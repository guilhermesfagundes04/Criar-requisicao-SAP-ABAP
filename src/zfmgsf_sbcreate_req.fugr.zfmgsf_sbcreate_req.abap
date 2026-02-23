FUNCTION zfmgsf_sbcreate_req.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(ID_MATNR) TYPE  EBAN-MATNR
*"     REFERENCE(ID_MENGE) TYPE  EBAN-MENGE
*"     REFERENCE(ID_WERKS) TYPE  EBAN-WERKS
*"  EXPORTING
*"     REFERENCE(ED_RESULTADO) TYPE  CHAR1
*"     REFERENCE(ED_MENSAGEM) TYPE  CHAR200
*"     REFERENCE(ED_BANFN) TYPE  EBAN-BANFN
*"----------------------------------------------------------------------

  DATA: lt_pritem  TYPE STANDARD TABLE OF bapimereqitemimp,
        lt_pritemx TYPE STANDARD TABLE OF bapimereqitemx,
        lt_return  TYPE STANDARD TABLE OF bapiret2.

  DATA: ls_return  TYPE bapiret2,
        ls_header  TYPE bapimereqheader,
        ls_headerx TYPE bapimereqheaderx.

  DATA: lv_preq_type TYPE bapimereqheader-pr_type,
        lv_banfn     TYPE banfn,
        lv_msg       TYPE string.

  CLEAR: ed_resultado, ed_mensagem, ed_banfn.

  "Busca tipo de requisição
  SELECT SINGLE low
    FROM tvarvc
    INTO @lv_preq_type
    WHERE name = 'ZGSF_CREATE_REQ'.

  IF lv_preq_type IS INITIAL.
    lv_preq_type = 'NB'.
  ENDIF.

  ls_header-pr_type  = lv_preq_type.
  ls_headerx-pr_type = 'X'.

  "Item
  lt_pritem = VALUE #(
   ( material   = id_matnr
     quantity   = id_menge
     plant      = id_werks
     deliv_date = sy-datum + 7
     pur_group  = '001'
     closed     = 'X'
     acctasscat = 'U' ) ).

  "ItemX
  lt_pritemx = VALUE #(
   ( material   = 'X'
     quantity   = 'X'
     plant      = 'X'
     deliv_date = 'X'
     pur_group  = 'X'
     closed     = 'X'
     acctasscat = 'X' ) ).

  "Chama BAPI_PR_CREATE
  CALL FUNCTION 'BAPI_PR_CREATE'
    EXPORTING
      prheader  = ls_header
      prheaderx = ls_headerx
    IMPORTING
      number    = lv_banfn
    TABLES
      return    = lt_return
      pritem    = lt_pritem
      pritemx   = lt_pritemx.

  "Tratamento de retorno
  LOOP AT lt_return INTO ls_return.
    IF ed_mensagem IS INITIAL.
      ed_mensagem = ls_return-message.
    ELSE.
      ed_mensagem = |{ ed_mensagem } / { ls_return-message }|.
    ENDIF.

    IF ls_return-type = 'E'
    OR ls_return-type = 'A'.
      ed_resultado = 'E'.
    ENDIF.
  ENDLOOP.

  "Commit / Rollback
  IF ed_resultado IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    ed_resultado = 'S'.
    ed_mensagem  = |Requisição criada com êxito: { ed_mensagem }|.
    ed_banfn     = lv_banfn.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ed_mensagem = |Falha na criação: { ed_mensagem }|.
  ENDIF.

ENDFUNCTION.
