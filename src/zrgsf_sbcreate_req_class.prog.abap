CLASS lcl_event_handler DEFINITION.                             "CLASSE local (botões, comandos) DEFINIÇÃO.
  PUBLIC SECTION.                                               "SEÇÃO PÚBLICA.
    METHODS:                                                    "MÉTODOS:

      on_toolbar FOR EVENT toolbar OF cl_gui_alv_grid           "on_toolbar PARA EVENTO toolbar DE cl_gui_alv_grid
        IMPORTING e_object e_interactive,                       "IMPORTANDO e_object, e_interactive (PARÂMETROS)

      on_user_command FOR EVENT user_command OF cl_gui_alv_grid "on_user_command PARA EVENTO user_command DE cl_gui_alv_grid
        IMPORTING e_ucomm.                                      "IMPORTANDO e_ucomm (PARÂMETROS).

ENDCLASS.                                                       "Fim da classe DEFINIÇÃO.

CLASS lcl_event_handler IMPLEMENTATION.                         "CLASSE local (botões, comandos) IMPLEMENTAÇÃO.

  METHOD on_toolbar.                                            "MÉTODO on_toolbar.

    DATA: ls_button TYPE stb_button.                            "DECLARAR ESTRUTURA ls_button TIPO stb_button.

    FREE ls_button.                                             "LIMPAR ESTRUTURA ls_button.
    ls_button-function  = 'MODIFICAR'.                          "FUNÇÃO modificar.
    ls_button-icon      = icon_generate.                        "ÍCONE próprio da SAP.
    ls_button-quickinfo = 'Modificar requisiçoes'.              "INFORMAÇÃO RÁPIDA DE UM ÍCONE.
    ls_button-text      = 'Modificar requisiçoes'.              "TEXTO.
    APPEND ls_button TO e_object->mt_toolbar.                   "ACRESCENTAR na ESTRUTURA ls_button PARA PARÂMETRO e_object ACESSANDO (->) atributo mt_toolbar.

    FREE ls_button.                                             "LIMPAR ESTRUTURA ls_button.
    ls_button-function  = 'CRIAR'.                              "FUNÇÃO criar.
    ls_button-icon      = icon_create.                          "ÍCONE próprio da SAP.
    ls_button-quickinfo = 'Nova Requisição'.                    "INFORMAÇÃO RÁPIDA DE UM ÍCONE.
    ls_button-text      = 'Nova Requisição'.                    "TEXTO.
    APPEND ls_button TO e_object->mt_toolbar.                   "ACRESCENTAR na ESTRUTURA ls_button PARA PARÂMETRO e_object ACESSANDO (->) atributo mt_toolbar.

  ENDMETHOD.                                                    "Fim do método on_toolbar

  METHOD on_user_command.                                       "MÉTODO on_user_command.

    CASE e_ucomm.                                               "CASO PARÂMETRO e_ucomm.
      WHEN 'MODIFICAR'.                                         "QUANDO for MODIFICAR.
        PERFORM zf_modificados.                                 "EXECUTAR (form zf_modificados).
      WHEN 'CRIAR'.                                             "QUANDO for MODIFICAR.
        PERFORM zf_criar_req.                                   "EXECUTAR (form zf_criar_req).
    ENDCASE.                                                    "Fim do caso.

  ENDMETHOD.                                                    "Fim do método on_user_command.

ENDCLASS.

DATA: go_event_handler TYPE REF TO lcl_event_handler.           "DECLARAR OBJETO go_event_handler TIPO REFERÊNCIA DE classe local lcl_event_handler.
