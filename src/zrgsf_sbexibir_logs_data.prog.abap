TABLES: eban, mara, makt.

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

DATA: gt_saida TYPE STANDARD TABLE OF ty_saida,
      gt_log   TYPE STANDARD TABLE OF ty_log,
      gt_eban  TYPE STANDARD TABLE OF ty_eban,
      gt_mara  TYPE STANDARD TABLE OF ty_mara,
      gt_makt  TYPE STANDARD TABLE OF ty_makt.

DATA: go_cc          TYPE REF TO cl_gui_custom_container,
      go_alv         TYPE REF TO cl_gui_alv_grid,
      go_cc_log      TYPE REF TO cl_gui_custom_container,
      go_alv_log     TYPE REF TO cl_gui_alv_grid,
*>> Guilherme Fagundes SByte 26.11.2025
      go_zclgsf_logs TYPE REF TO zclgsf_logs.
*<< Guilherme Fagundes SByte 26.11.2025

*>> Guilherme Fagundes Sbyte 27.11.2025
CONSTANTS:
  objeto    TYPE string VALUE 'ZGSF',
  subobjeto TYPE string VALUE 'ZGSF001'.

DATA: gs_msg TYPE bal_s_msg.

DATA: gv_msgv1 TYPE symsgv,
      gv_msgv2 TYPE symsgv.
*<< Guilherme Fagundes SByte 27.11.2025

*>> Guilherme Fagundes SByte 09.12.2025
DATA: iv_banfn           TYPE string,     "Do tipo do parâmetro iv_num (por isso botei iv_banfn)
      gt_handles_process TYPE bal_t_logh.
*<< Guilherme Fagundes SByte 09.12.2025
