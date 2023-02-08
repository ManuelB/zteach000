*&---------------------------------------------------------------------*
*& Report ZTEACH000_HELLO_WORLD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEACH000_HELLO_WORLD.

* START-OF-SELECTION.
* CALL SCREEN 100.

INITIALIZATION.
DATA: l_lines TYPE i,
ls_flight TYPE sflight,
lt_flights TYPE STANDARD TABLE OF sflight,
ls_bapisfldat TYPE bapisfldat,
lt_bapisfldats TYPE STANDARD TABLE OF bapisfldat,
ls_ret TYPE bapiret2,
lt_rets TYPE STANDARD TABLE OF bapiret2.

SELECTION-SCREEN BEGIN OF BLOCK 0
 WITH FRAME TITLE text-001.  "parameters for data selection
  PARAMETERS: pa_carid
    TYPE spfli-carrid DEFAULT 'LH'.
SELECTION-SCREEN END OF BLOCK 0.

SELECTION-SCREEN BEGIN OF BLOCK 1
 WITH FRAME TITLE text-002.  "method for data selection
  PARAMETERS:  p_sel RADIOBUTTON GROUP r1 ,
               p_fm RADIOBUTTON GROUP r1 .
SELECTION-SCREEN END OF BLOCK 1.

AT SELECTION-SCREEN.
  IF pa_carid IS INITIAL.
    MESSAGE ID '00' TYPE 'E' NUMBER '001'
       WITH 'Kennung der Fluggesellschaft angeben!'.
    EXIT.
  ENDIF.

START-OF-SELECTION.
  IF p_sel = 'X'.
    WRITE 'Prozedur SELECT-Anweisung'.
    SELECT  * FROM sflight INTO TABLE lt_flights
        WHERE carrid = pa_carid.
    IF sy-subrc NE 0.
      WRITE / 'Keine Ergebnisse für SELECT.'
        COLOR COL_NEGATIVE.
    ENDIF.
    l_lines = sy-dbcnt.
  ELSE.
    WRITE 'Prozedur CALL FUNCTION'.
    CALL FUNCTION 'BAPI_FLIGHT_GETLIST'
      EXPORTING
        airline     = pa_carid
      TABLES
        flight_list = lt_bapisfldats
        return      = lt_rets.
    DESCRIBE TABLE lt_bapisfldats lines l_lines.
    IF l_lines = 0.
      WRITE / 'Kein Inhalt in der Tabelle'
        COLOR COL_NEGATIVE.
      LOOP AT lt_rets INTO ls_ret.
        WRITE ls_ret-message.
      ENDLOOP.
    ENDIF.
  ENDIF.

AT LINE-SELECTION.
  CASE sy-lilli.
    WHEN 6.
      IF p_sel = 'X'.
        LOOP AT lt_flights INTO ls_flight.
          WRITE: / ls_flight-carrid,
           ls_flight-connid, ls_flight-fldate.
        ENDLOOP.
      ELSE.
        LOOP AT lt_bapisfldats INTO ls_bapisfldat.
          WRITE: /
         ls_bapisfldat-airlineid,
         ls_bapisfldat-connectid,
         ls_bapisfldat-flightdate.
        ENDLOOP.
      ENDIF.
    WHEN 8.
      IF p_sel = 'X'.
        CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
          EXPORTING
            i_structure_name = 'sflight'
          TABLES
            t_outtab         = lt_flights.
      ELSE.
        CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
          EXPORTING
            i_structure_name = 'bapisfldat'
          TABLES
            t_outtab         = lt_bapisfldats.
      ENDIF.
  ENDCASE.
