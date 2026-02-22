* Faço meu MÓDULO display_alv NA SAÍDA para exibição do ALV *
MODULE display_alv OUTPUT.

  IF go_cc IS INITIAL.                                        "SE meu OBJETO GLOBAL go_cc FOR INICIAL (tem seu valor padrão).

    CREATE OBJECT go_cc                                       "CRIAR OBJETO go_cc (INSTANCIANDO UMA CLASSE)
      EXPORTING                                               "EXPORTANDO
        container_name = 'MAIN'.                              "container_name IGUAL a 'MAIN' (nome do custom control que criei no LAYOUT da minha tela 100).
    CREATE OBJECT go_alv                                      "CRIAR OBJETO go_alv (INSTANCIANDO UMA CLASSE).
      EXPORTING                                               "EXPORTANDO
        i_parent = go_cc.                                     "i_parent(CONTAINER PAI) IGUAL a go_cc.

    CREATE OBJECT go_event_handler.                           "CRIAR OBJETO go_event_handler (INSTANCIANDO UMA CLASSE).
    SET HANDLER go_event_handler->on_toolbar      FOR go_alv. "MANIPULANDO O CONJUNTO go_event_handler ACESSANDO o método on_toolbar PARA o objeto go_alv.
    SET HANDLER go_event_handler->on_user_command FOR go_alv. "MANIPULANDO O CONJUNTO go_event_handler ACESSANDO o método on_user_command PARA o objeto go_alv.

* Declaração de tabela interna local e estrutura local de fieldcat para "configuração" das colunas *
    DATA: lt_fieldcat TYPE lvc_t_fcat,
          ls_fieldcat TYPE lvc_s_fcat.

* Monta o catálogo de campos, definindo nome e tamanho *
    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'CHECKBOX'.
    ls_fieldcat-coltext   = 'Checkbox'.
    ls_fieldcat-outputlen = 15.
    ls_fieldcat-checkbox  = abap_true.
    ls_fieldcat-edit      = abap_true.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'BANFN'.
    ls_fieldcat-coltext   = 'Requisição'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'BNFPO'.
    ls_fieldcat-coltext   = 'Item Requisição'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'BADAT'.
    ls_fieldcat-coltext   = 'Data Requisição'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'LOEKZ'.
    ls_fieldcat-coltext   = 'Pedido Eliminado'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'MATNR'.
    ls_fieldcat-coltext   = 'Material'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'MAKTX'.
    ls_fieldcat-coltext   = 'Descrição Material'.
    ls_fieldcat-outputlen = 10.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'AFNAM'.
    ls_fieldcat-coltext   = 'Requisitante'.
    ls_fieldcat-outputlen = 10.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'MENGE'.
    ls_fieldcat-coltext   = 'Quantidade'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'QTD_NOVA'.
    ls_fieldcat-coltext   = 'Quantidade Nova'.
    ls_fieldcat-outputlen = 15.
    ls_fieldcat-edit      = abap_true.
    APPEND ls_fieldcat TO lt_fieldcat.

    FREE ls_fieldcat.
    ls_fieldcat-fieldname = 'MEINS'.
    ls_fieldcat-coltext   = 'Unidade Medida'.
    ls_fieldcat-outputlen = 15.
    APPEND ls_fieldcat TO lt_fieldcat.

* Chamada para exibição do ALV *
    CALL METHOD go_alv->set_table_for_first_display                 "MÉTODO DE CHAMADA go_alv ACESSANDO o método set_table_for_first_display
      EXPORTING                                                     "EXPORTANDO
        is_layout       = VALUE lvc_s_layo( zebra = abap_true       "is_layout IGUAL a VALOR lvc_s_layo ( zebra = abap_true )
                                            sel_mode        = 'A' ) "sel_mode IGUAL A 'A' - Campo para selecionar
      CHANGING                                                      "MUDANDO
        it_outtab       = gt_saida                                  "it_outtab IGUAL a gt_saida.
        it_fieldcatalog = lt_fieldcat.                              "it_fieldcatalog IGUAL a lt_fieldcat.

  ENDIF.                                                            "Fim do IF (go_cc).

ENDMODULE.                                                          "Fim do MODULE (display_alv).
