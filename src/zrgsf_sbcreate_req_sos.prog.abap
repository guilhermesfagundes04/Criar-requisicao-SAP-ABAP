* Faço um START-OF-SELECTION para executar meu FORM de busca, FORM de tratamento e TELA 0100. *
START-OF-SELECTION.

  PERFORM zf_busca.      "EXECUTAR FORM zf_busca.
  PERFORM zf_tratamento. "EXECUTAR FORM zf_tratamento.
  CALL SCREEN 0100.      "CHAMAR TELA 0100.
