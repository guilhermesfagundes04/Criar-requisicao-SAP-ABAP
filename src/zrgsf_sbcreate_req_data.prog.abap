* Declarando minhas tabelas que vão ser utilizadas no REPORT *
TABLES: eban, mara, makt.

* Declarando meus tipos que vão ser utilizados no REPORT *
TYPES: BEGIN OF ty_saida,
         checkbox TYPE flag,
         banfn    TYPE eban-banfn,
         bnfpo    TYPE eban-bnfpo,
         badat    TYPE eban-badat,
         loekz    TYPE eban-loekz,
         matnr    TYPE eban-matnr,
         maktx    TYPE makt-maktx,
         afnam    TYPE eban-afnam,
         menge    TYPE eban-menge,
         qtd_nova TYPE eban-menge,
         meins    TYPE eban-meins,
       END OF ty_saida,

       BEGIN OF ty_log,
         icone        TYPE icon_d,
         banfn        TYPE eban-banfn,
         bnfpo        TYPE eban-bnfpo,
         badat        TYPE eban-badat,
         matnr        TYPE eban-matnr,
         qtd_nova     TYPE eban-menge,
         qtd_anterior TYPE eban-menge,
         resultado    TYPE c LENGTH 200,
       END OF ty_log,

       BEGIN OF ty_eban,
         banfn TYPE eban-banfn,
         bnfpo TYPE eban-bnfpo,
         badat TYPE eban-badat,
         loekz TYPE eban-loekz,
         matnr TYPE eban-matnr,
         afnam TYPE eban-afnam,
         menge TYPE eban-menge,
         meins TYPE eban-meins,
       END OF ty_eban,

       BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
       END OF ty_mara,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         spras TYPE makt-spras,
         maktx TYPE makt-maktx,
       END OF ty_makt.

* Declarando minhas tabelas internas globais que vão ser utilizadas no REPORT *
DATA: gt_saida TYPE STANDARD TABLE OF ty_saida,
      gt_log   TYPE STANDARD TABLE OF ty_log,
      gt_eban  TYPE STANDARD TABLE OF ty_eban,
      gt_mara  TYPE STANDARD TABLE OF ty_mara,
      gt_makt  TYPE STANDARD TABLE OF ty_makt.

* Declarando meus objetos globais que vão ser utilizados para a exibição do ALV *
DATA: go_cc  TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.

* Declarando meus objetos globais que vão ser utilizados para a exibição do ALV (LOG) *
DATA: go_cc_log  TYPE REF TO cl_gui_custom_container,
      go_alv_log TYPE REF TO cl_gui_alv_grid.
