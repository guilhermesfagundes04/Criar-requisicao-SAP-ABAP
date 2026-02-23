CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS:

      on_toolbar
        FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING
          e_object
          e_interactive,

      on_user_command
        FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING
          e_ucomm.

ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_toolbar.

    APPEND VALUE stb_button(
      function  = 'MODIFICAR'
      icon      = icon_generate
      quickinfo = `Modificar requisições`
      text      = `Modificar requisições`
    ) TO e_object->mt_toolbar.

    APPEND VALUE stb_button(
      function  = 'CRIAR'
      icon      = icon_create
      quickinfo = `Nova Requisição`
      text      = `Nova Requisição`
    ) TO e_object->mt_toolbar.

    APPEND VALUE stb_button(
      function  = 'LOGS'
      icon      = icon_information
      quickinfo = `Exibir Logs`
      text      = `Exibir Logs`
    ) TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_user_command.

    CASE e_ucomm.
      WHEN 'MODIFICAR'.
        PERFORM zf_modificar_requisicoes.
      WHEN 'CRIAR'.
        PERFORM zf_criar_requisicoes.
*>> Guilherme Fagundes SByte 26.11.2025
      WHEN 'LOGS'.
        PERFORM zf_processa_logs_30dias.
*<< Guilherme Fagundes SByte 26.11.2025
    ENDCASE.

  ENDMETHOD.

ENDCLASS.

"DECLARAR OBJETO go_event_handler TIPO REFERÊNCIA DE classe local lcl_event_handler.
DATA: go_event_handler TYPE REF TO lcl_event_handler.
