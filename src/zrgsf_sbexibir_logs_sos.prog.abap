START-OF-SELECTION.

*>> Guilherme Fagundes SByte 27.11.2025
  IF go_zclgsf_logs IS INITIAL.
    go_zclgsf_logs = NEW zclgsf_logs( iv_obj    = objeto
                                      iv_subobj = subobjeto ).
  ENDIF.
*<< Guilherme Fagundes SByte 27.11.2025

  PERFORM zf_buscas_tabelas_internas.
  PERFORM zf_tratamento_de_dados.
  CALL SCREEN 0100.
