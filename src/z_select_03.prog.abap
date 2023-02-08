*&---------------------------------------------------------------------*
*& Report Z_SELECT_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_SELECT_03.

DATA: ls_flight TYPE sflight,
      lt_flights TYPE STANDARD TABLE OF sflight.

PARAMETERS:
pa_carid TYPE sflight-carrid DEFAULT 'LH',
pa_conid TYPE sflight-connid DEFAULT '0400'.

WRITE: pa_carid, pa_conid.

SELECT  * FROM sflight INTO ls_flight
  WHERE carrid = pa_carid AND connid = pa_conid.
 WRITE: / ls_flight-planetype, ls_flight-seatsmax, ls_flight-seatsocc.
ENDSELECT.
IF sy-subrc NE 0.
  WRITE sy-subrc.
ELSE.
  WRITE / sy-dbcnt.
ENDIF.
