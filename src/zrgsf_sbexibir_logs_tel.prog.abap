SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_badat FOR eban-badat OBLIGATORY,
                  s_banfn FOR eban-banfn,
                  s_matnr FOR eban-matnr.

SELECTION-SCREEN END OF BLOCK bc01.

INITIALIZATION.

  DATA lv_last_day  TYPE sy-datum.

  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = sy-datum
    IMPORTING
      last_day_of_month = lv_last_day.

  DATA(lv_first_day) = lv_last_day.
  lv_first_day+6(2) = '01'.

  s_badat = VALUE #(
    sign   = 'I'
    option = 'BT'
    low    = lv_first_day
    high   = lv_last_day
  ).

  APPEND s_badat.
