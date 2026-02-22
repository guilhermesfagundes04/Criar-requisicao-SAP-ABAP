*Faço meu módulo de PROCESS BEFORE OUTPUT (Processo antes da saída). *
MODULE pbo_0100 OUTPUT.                 "MÓDULO pbo_100 SAÍDA.

  SET PF-STATUS 'S_0100'.               "SETANDO O STATUS 'S_0100'.
  SET TITLEBAR  'T_0100'.               "SETANDO O TÍTULO 'T_0100'.

ENDMODULE.                              "Fim do MÓDULO pbo_0100.

*Faço meu módulo de PROCESS AFTER INPUT (Processo depois da entrada). *
MODULE pai_0100 INPUT.                  "MÓDULO pai_0100 ENTRADA.

  CASE sy-ucomm.                        "CASO sy-ucomm (VARIÁVEL DE SISTEMA).
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.  "QUANDO FOR 'BACK' OU 'EXIT' OU 'CANCEL'.
      LEAVE TO SCREEN 00.               "SAIR DO PROGRAMA.
  ENDCASE.                              "Fim do CASO.

ENDMODULE.                              "Fim do MÓDULO pai_0100.
