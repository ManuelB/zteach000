*&---------------------------------------------------------------------*
*& Report zteach000_basics
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zteach000_basics.

PARAMETERS: param1 TYPE bukrs,
            param2 TYPE int4.

DATA: variable1(20) TYPE c,
      variable2(40) TYPE c,
      zaehler       TYPE int4 VALUE 0.

variable1 = 'world01234501234567981'.

CONCATENATE 'Hello' variable1 INTO variable2 SEPARATED BY ' '.

WRITE:/ variable2.
WRITE:/ param1.

WHILE zaehler < 20.
  PERFORM print_when_bigger_10 USING zaehler.
  zaehler = zaehler + 1.
ENDWHILE.



FORM print_when_bigger_10 USING nummer TYPE int4.
  DATA: MAX_INT TYPE i Value 10.

  IF nummer > MAX_INT.
    WRITE: 'Der zweite Parameter ist größer als ', MAX_INT.
  ELSE.
    WRITE: 'Der zweite Parameter ist kleiner als 10'.
  ENDIF.
ENDFORM.
