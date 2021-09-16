CLASS zbp_i_et1_tab_method DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    CLASS-METHODS update_waitingListNo
        IMPORTING VALUE(passenger_key) TYPE sysuuid_x16
        EXPORTING VALUE(output) TYPE I.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zbp_i_et1_tab_method IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
  ENDMETHOD.
  METHOD update_waitinglistno.
    output = 1.
  ENDMETHOD.

ENDCLASS.
