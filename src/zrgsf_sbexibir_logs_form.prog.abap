FORM zf_buscas_tabelas_internas.

  SELECT banfn, bnfpo, badat, loekz, matnr, afnam, menge, meins
    FROM eban
    INTO CORRESPONDING FIELDS OF TABLE @gt_eban
    WHERE badat IN @s_badat
      AND banfn IN @s_banfn
      AND matnr IN @s_matnr.

  IF sy-subrc IS INITIAL.

    SELECT matnr
      FROM mara
      INTO CORRESPONDING FIELDS OF TABLE @gt_mara
      FOR ALL ENTRIES IN @gt_eban
      WHERE matnr EQ @gt_eban-matnr.

    SELECT matnr, spras, maktx
      FROM makt
      INTO CORRESPONDING FIELDS OF TABLE @gt_makt
      FOR ALL ENTRIES IN @gt_mara
      WHERE matnr EQ @gt_mara-matnr
        AND spras EQ @sy-langu.

  ENDIF.

  PERFORM zf_ordenacao_tabelas_internas.

ENDFORM.

FORM zf_ordenacao_tabelas_internas.

  SORT: gt_eban BY banfn,
        gt_mara BY matnr,
        gt_makt BY matnr.

ENDFORM.

FORM zf_tratamento_de_dados.

  CLEAR gt_saida[].

  LOOP AT gt_eban ASSIGNING FIELD-SYMBOL(<fs_eban>).

    APPEND INITIAL LINE TO gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).
    MOVE-CORRESPONDING <fs_eban> TO <fs_saida>.

* Leitura da tabela gt_mara ATRIBUINDO field-symbol fs_mara COM CHAVE matnr IGUAL a fs_eban-matnr em PESQUISA BINÁRIA. *
    READ TABLE gt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>)
                       WITH KEY matnr = <fs_eban>-matnr
                       BINARY SEARCH.

    IF sy-subrc IS NOT INITIAL.
      CONTINUE.
    ENDIF.

* Leitura da tabela gt_makt ATRIBUINDO field-symbol fs_makt COM CHAVE matnr IGUAL a fs_mara-matnr em PESQUISA BINÁRIA. *
    READ TABLE gt_makt ASSIGNING FIELD-SYMBOL(<fs_makt>)
                       WITH KEY matnr = <fs_mara>-matnr
                       BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      <fs_saida>-maktx = <fs_makt>-maktx.
    ENDIF.

  ENDLOOP.

ENDFORM.

FORM zf_modificar_requisicoes.

*>> Guilherme Fagundes SByte 28.11.2025
  CLEAR gt_log[].
*<< Guilherme Fagundes SByte 28.11.2025

  DATA: lv_result TYPE c LENGTH 200.

  LOOP AT gt_saida ASSIGNING FIELD-SYMBOL(<fs_saida>).

    IF <fs_saida>-checkbox <> 'X'.
      CONTINUE.
    ENDIF.

    APPEND INITIAL LINE TO gt_log ASSIGNING FIELD-SYMBOL(<fs_log>).
    MOVE-CORRESPONDING <fs_saida> TO <fs_log>.
    <fs_log>-qtd_anterior = <fs_saida>-menge.

    IF <fs_saida>-loekz = 'X'.
      <fs_log>-resultado = `Requisição eliminada. Não é possível modificar`.
      <fs_log>-icone = icon_message_warning.
*>> Guilherme Fagundes SByte 09.12.2025
      iv_banfn =  |{ <fs_saida>-banfn  }|.
      go_zclgsf_logs->mt_create( iv_banfn ).
*<< Guilherme Fagundes SByte 09.12.2025
*>> Guilherme Fagundes SByte 27.11.2025
      gv_msgv1 = <fs_saida>-banfn.
      PERFORM zf_adiciona_mensagem_log USING 'E' 'ZGSF_MSG' '001' gv_msgv1 ''.
*<< Guilherme Fagundes SByte 27.11.2025

    ELSEIF <fs_saida>-qtd_nova = 0 OR <fs_saida>-qtd_nova = <fs_saida>-menge.
      <fs_log>-resultado = `Quantidade <0 ou igual a atual>. Não é possível modificar`.
      <fs_log>-icone = icon_message_warning.
*>> Guilherme Fagundes SByte 09.12.2025
      iv_banfn =  |{ <fs_saida>-banfn  }|.
      go_zclgsf_logs->mt_create( iv_banfn ).
*<< Guilherme Fagundes SByte 09.12.2025
*>> Guilherme Fagundes SByte 27.11.2025
      gv_msgv1 = <fs_saida>-banfn.
      PERFORM zf_adiciona_mensagem_log USING 'E' 'ZGSF_MSG' '002' gv_msgv1 ''.
*<< Guilherme Fagundes SByte 27.11.2025

    ELSE.

      CALL FUNCTION 'ZFMGSF_SBUPD_REQ'
        EXPORTING
          id_banfn     = <fs_saida>-banfn
          id_bnfpo     = <fs_saida>-bnfpo
          id_nova_qtd  = <fs_saida>-qtd_nova
        IMPORTING
          ed_resultado = lv_result.
      <fs_log>-resultado = lv_result.
      <fs_log>-icone     = icon_checked.

*>> Guilherme Fagundes SByte 09.12.2025
      iv_banfn =  |{ <fs_saida>-banfn  }| .
      go_zclgsf_logs->mt_create( iv_banfn ).
*<< Guilherme Fagundes SByte 09.12.2025
*>> Guilherme Fagundes SBYte 27.11.2025
      gv_msgv1 = <fs_saida>-banfn.
      gv_msgv2 = <fs_saida>-qtd_nova.
      PERFORM zf_adiciona_mensagem_log USING 'S' 'ZGSF_MSG' '003' gv_msgv1 gv_msgv2.
*<< Guilherme Fagundes SByte 27.11.2025
    ENDIF.

  ENDLOOP.

  CALL SCREEN 0200.

**>> Guilherme Fagundes SByte 26.11.2025
  go_zclgsf_logs->mt_save( ).
**<< Guilherme Fagundes SByte 26.11.2025

ENDFORM.

FORM zf_criar_requisicoes.

  DATA: lt_fields   TYPE STANDARD TABLE OF sval.

  DATA: ls_fields TYPE sval.

  DATA: lv_matnr    TYPE eban-matnr,
        lv_menge    TYPE eban-menge,
        lv_werks    TYPE eban-werks,
        lv_result   TYPE char1,
        lv_mensagem TYPE char200,
        lv_banfn    TYPE eban-banfn.

  CLEAR lt_fields.

  DEFINE add_field.

    ls_fields = VALUE #(
       tabname   = 'EBAN'
       fieldname = &1
       field_obl = abap_true ).

   APPEND ls_fields TO lt_fields.

  END-OF-DEFINITION.

* Cada chamada expande o corpo do macro trocando &1 pelo parâmetro passado. *
  add_field 'MATNR'.                                              "Linha 1: tabname = 'EBAN', fieldname = 'MATNR', field_obl = 'X'.
  add_field 'MENGE'.                                              "Linha 2: tabname = 'EBAN', fieldname = 'MENGE', field_obl = 'X'.
  add_field 'WERKS'.                                              "Linha 3: tabname = 'EBAN', fieldname = 'WERKS', field_obl = 'X'.

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title     = 'Insira os dados da nova requisição!'
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  IF sy-subrc IS INITIAL.

    READ TABLE lt_fields INTO ls_fields
                         WITH KEY fieldname = 'MATNR'.
    lv_matnr = ls_fields-value.

    READ TABLE lt_fields INTO ls_fields
                         WITH KEY fieldname = 'MENGE'.
    lv_menge = ls_fields-value.

    READ TABLE lt_fields INTO ls_fields
                         WITH KEY fieldname = 'WERKS'.
    lv_werks = ls_fields-value.

    IF lv_matnr IS INITIAL OR
       lv_menge IS INITIAL OR
       lv_werks IS INITIAL.
      MESSAGE 'Preencha todos os campos por gentileza!' TYPE 'E'.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ZFMGSF_SBCREATE_REQ'
      EXPORTING
        id_matnr     = lv_matnr
        id_menge     = lv_menge
        id_werks     = lv_werks
      IMPORTING
        ed_resultado = lv_result
        ed_mensagem  = lv_mensagem
        ed_banfn     = lv_banfn.

    IF lv_result = 'S'.
      MESSAGE lv_mensagem TYPE 'S'.
*>> Guilherme Fagundes SByte 12.12.2025
      iv_banfn =  |{ lv_banfn }| .
      go_zclgsf_logs->mt_create( iv_banfn ).
*<< Guilherme Fagundes SByte 12.12.2025
*>> Guilherme Fagundes SByte 27.11.2025
      gv_msgv1 = lv_banfn.
      PERFORM zf_adiciona_mensagem_log USING 'S' 'ZGSF_MSG' '004' gv_msgv1 ''.
*<< Guilherme Fagundes SByte 27.11.2025

    ELSE.
      MESSAGE lv_mensagem TYPE 'I'.
*>> Guilherme Fagundes SByte 12.12.2025
      iv_banfn =  |{ lv_banfn }| .
      go_zclgsf_logs->mt_create( iv_banfn ).
*<< Guilherme Fagundes SByte 12.12.2025
*>> Guilherme Fagundes SByte 27.11.2025
      PERFORM zf_adiciona_mensagem_log USING 'E' 'ZGSF_MSG' '005' '' ''.
*<< Guilherme Fagundes SByte 27.11.2025
    ENDIF.

  ENDIF.

*>> Guilherme Fagundes SByte 26.11.2025
  go_zclgsf_logs->mt_save( ).
*<< Guilherme Fagundes SByte 26.11.2025

ENDFORM.

FORM zf_exibir_tela_log.

  IF go_cc_log IS INITIAL.

    go_cc_log  = NEW cl_gui_custom_container( container_name = `LOG` ).

    go_alv_log = NEW cl_gui_alv_grid( i_parent = go_cc_log ).

    DATA(lt_fieldcat) = VALUE lvc_t_fcat(
      ( fieldname = 'ICONE'        coltext = 'Status'              outputlen = 15 )
      ( fieldname = 'BANFN'        coltext = 'Requisição'          outputlen = 15 )
      ( fieldname = 'BNFPO'        coltext = 'Item Requisição'     outputlen = 15 )
      ( fieldname = 'BADAT'        coltext = 'Data Requisição'     outputlen = 15 )
      ( fieldname = 'MATNR'        coltext = 'Material'            outputlen = 15 )
      ( fieldname = 'QTD_NOVA'     coltext = 'Quantidade nova'     outputlen = 10 )
      ( fieldname = 'QTD_ANTERIOR' coltext = 'Quantidade anterior' outputlen = 10 )
      ( fieldname = 'RESULTADO'    coltext = 'Resultado'           outputlen = 100 ) ).

    go_alv_log->set_table_for_first_display(
      EXPORTING
        is_layout       = VALUE lvc_s_layo( zebra = abap_true )
      CHANGING
        it_outtab       = gt_log
        it_fieldcatalog = lt_fieldcat ).

  ENDIF.

*>> Guilherme Fagundes SByte 28.11.2025
  go_alv_log->refresh_table_display(
    EXCEPTIONS
      finished = 1
      OTHERS   = 2 ).
*<< Guilherme Fagundes SByte 28.11.2025

ENDFORM.

*>> Guilherme Fagundes SByte 28.11.2025
FORM zf_processa_logs_30dias.

  DATA: lv_date_from   TYPE sy-datum,
        ls_log_filter  TYPE bal_s_lfil,
        lt_log_header  TYPE balhdr_t,
        lt_log_handles TYPE bal_t_logh,
        lt_banfn_range TYPE RANGE OF eban-banfn,
        ls_banfn_range LIKE LINE OF lt_banfn_range,
        ls_handle      TYPE balloghndl.

*>> Guilherme Fagundes SByte 08.12.2025
  "1. Limpando logs já processados via function de refresh.
  LOOP AT gt_handles_process INTO ls_handle.
    CALL FUNCTION 'BAL_LOG_REFRESH'
      EXPORTING
        i_log_handle = ls_handle.
  ENDLOOP.

  CLEAR: gt_handles_process,
         lt_banfn_range,
         ls_handle.
*<< Guilherme Fagundes SByte 08.12.2025

  "2. Verificando requisições selecionadas, caso checbox esteja preenchido continua o programa.
  lt_banfn_range = VALUE #(
    FOR ls_saida IN gt_saida WHERE ( checkbox = 'X' )
      ( sign   = 'I'
        option = 'EQ'
        low    = ls_saida-banfn ) ).

  IF lt_banfn_range IS INITIAL.
    MESSAGE 'Por favor, selecione ao menos 1 requisição!' TYPE 'I'.
    RETURN.
  ENDIF.

  "3. Fazendo o cálculo de 30 dias via function de date com intervalo.
  DATA(lv_date_to) = sy-datum.

  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
    EXPORTING
      date      = sy-datum
      days      = 30
      months    = 0
      signum    = '-'
      years     = 0
    IMPORTING
      calc_date = lv_date_from.

  "4. Adicionando filtros para os logs.
  FREE ls_log_filter.

  ls_log_filter-object    = VALUE #( ( sign   = 'I'
                                       option = 'EQ'
                                       low    = objeto     ) ).

  ls_log_filter-subobject = VALUE #( ( sign   = 'I'
                                       option = 'EQ'
                                       low    = subobjeto  ) ).

  ls_log_filter-aldate    = VALUE #( ( sign   = 'I'
                                       option = 'BT'
                                       low    = lv_date_from
                                       high   = lv_date_to ) ).

*>> Guilherme Fagundes SByte 05.12.2025
  ls_log_filter-extnumber = lt_banfn_range.
*<< Guilherme Fagundes SByte 05.12.2025

  "5. Procurando cabeçalhos de logs via function search.
  "Enviando os filtros (ls_log_filter).
  "Recebendo os cabeçalhos (lt_log_header).
  FREE lt_log_header.

  CALL FUNCTION 'BAL_DB_SEARCH'
    EXPORTING
      i_s_log_filter = ls_log_filter
    IMPORTING
      e_t_log_header = lt_log_header
    EXCEPTIONS
      OTHERS         = 4.

  IF lt_log_header IS INITIAL.
    MESSAGE 'Nenhum log encontrado nos últimos 30 dias.' TYPE 'I'.
    RETURN.
  ENDIF.

*>> Guilherme Fagundes SByte 05.12.2025
  "6. Carregando handles de logs via function load.
  "Enviando os cabeçalhos (lt_log_header).
  "Recebendo os handles (lt_log_handles).
  FREE lt_log_handles.

  CALL FUNCTION 'BAL_DB_LOAD'
    EXPORTING
      i_t_log_header = lt_log_header
    IMPORTING
      e_t_log_handle = lt_log_handles
    EXCEPTIONS
      OTHERS         = 4.

  IF lt_log_handles IS INITIAL.
    MESSAGE 'Erro ao carregar logs.' TYPE 'I'.
    RETURN.
  ENDIF.
*<< Guilherme Fagundes SByte 05.12.2025

*>> Guilherme Fagundes SByte 08.12.2025
  "7. Adicionando os logs na tabela de logs processados.
  "Sendo assim, funcionando posteriormente a function de refresh para novos logs.
  APPEND LINES OF lt_log_handles TO gt_handles_process.
*<< Guilherme Fagundes SByte 08.12.2025

  "8. Acessando o méteodo mt_display da classe ZCLGSF_LOGS.
  "Para exibição dos logs.
  go_zclgsf_logs->mt_display( ).

ENDFORM.
*<< Guilherme Fagundes SByte 28.11.2025

*>> Guilherme Fagundes SByte 27.11.2025
FORM zf_adiciona_mensagem_log
  USING iv_msgty  TYPE sy-msgty
        iv_msgid  TYPE sy-msgid
        iv_msgno  TYPE sy-msgno
        iv_msgv1  TYPE sy-msgv1
        iv_msgv2  TYPE sy-msgv2.

  gs_msg = VALUE #(
    msgty     = iv_msgty
    msgid     = iv_msgid
    msgno     = iv_msgno
    msgv1     = iv_msgv1
    msgv2     = iv_msgv2 ).

  go_zclgsf_logs->mt_add_message( gs_msg ).

ENDFORM.
*<< Guilherme Fagundes SByte 27.11.2025
