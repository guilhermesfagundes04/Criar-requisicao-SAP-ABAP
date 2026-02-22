*Faço meu módulo de PROCESS BEFORE OUTPUT (Processo antes da saída). *
MODULE pbo_0200 OUTPUT.                 "MÓDULO pbo_200 SAÍDA.

  SET PF-STATUS 'S_0200'.               "SETANDO O STATUS 'S_0200'.
  SET TITLEBAR  'T_0200'.               "SETANDO O TÍTULO 'T_0200'.
  PERFORM zf_display_log.               "EXECUTANDO o FORM zf_display_log.

ENDMODULE.                              "Fim do MÓDULO pbo_0200.

*Faço meu módulo de PROCESS AFTER INPUT (Processo depois da entrada). *
MODULE pai_0200 INPUT.                  "MÓDULO pai_0200 ENTRADA.

  CASE sy-ucomm.                        "CASO sy-ucomm (VARIÁVEL DE SISTEMA).
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.  "QUANDO FOR 'BACK' OU 'EXIT' OU 'CANCEL'.
      LEAVE TO SCREEN 00.               "SAIR DO PROGRAMA.
  ENDCASE.                              "Fim do CASO.

ENDMODULE.                              "Fim do MÓDULO pai_0200.
