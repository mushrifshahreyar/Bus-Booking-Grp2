CLASS zcl_et21_eml_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_et21_eml_demo IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    " step 1 - READ
*    READ ENTITIES OF ZI_ET1_TAB_BOOKING
*      ENTITY Booking
*        FROM VALUE #( ( BookingUuid = '02D5290E594C1EDA93815057FD949924' ) )
*      RESULT DATA(travels).
*
*    out->write( travels ).

     " step 2 - READ with Fields
    READ ENTITIES OF ZI_ET1_TAB_BOOKING
      ENTITY Booking
        FIELDS ( BookingId BusID  )
      WITH VALUE #( ( BookingUuid = '02D5290E594C1EDA93815057FD949924' ) )
      RESULT DATA(travels).
    out->write( travels ).
  ENDMETHOD.
ENDCLASS.
