MODULE exibir_tela_alv OUTPUT.

  IF go_cc IS INITIAL.

    go_cc = NEW cl_gui_custom_container( container_name = `MAIN` ).

    go_alv = NEW cl_gui_alv_grid( i_parent = go_cc ).

    go_event_handler = NEW lcl_event_handler( ).

    SET HANDLER go_event_handler->on_toolbar      FOR go_alv.
    SET HANDLER go_event_handler->on_user_command FOR go_alv.

    DATA(lt_fieldcat) = VALUE lvc_t_fcat(
    ( fieldname = 'CHECKBOX' coltext = `Checkbox`           outputlen = 15  edit = abap_true checkbox = abap_true )
    ( fieldname = 'BANFN'    coltext = `Requisição`         outputlen = 15 )
    ( fieldname = 'BNFPO'    coltext = `Item Requisição`    outputlen = 15 )
    ( fieldname = 'BADAT'    coltext = `Data Requisição`    outputlen = 15 )
    ( fieldname = 'LOEKZ'    coltext = `Pedido Eliminado`   outputlen = 15 )
    ( fieldname = 'MATNR'    coltext = `Material`           outputlen = 15 )
    ( fieldname = 'MAKTX'    coltext = `Descrição Material` outputlen = 15 )
    ( fieldname = 'AFNAM'    coltext = `Requisitante`       outputlen = 15 )
    ( fieldname = 'MENGE'    coltext = `Quantidade`         outputlen = 15 )
    ( fieldname = 'QTD_NOVA' coltext = `Quantidade Nova`    outputlen = 15  edit = abap_true )
    ( fieldname = 'MEINS'    coltext = `Unidade Medida`     outputlen = 15 ) ).

    go_alv->set_table_for_first_display(
      EXPORTING
        is_layout       = VALUE lvc_s_layo( zebra    = abap_true
                                            sel_mode = 'A' )
      CHANGING
        it_outtab       = gt_saida
        it_fieldcatalog = lt_fieldcat ).

  ENDIF.

ENDMODULE.
