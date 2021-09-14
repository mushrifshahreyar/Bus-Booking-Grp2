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
*    READ ENTITIES OF ZI_ET1_TAB_BOOKING
*      ENTITY Booking
*        FIELDS ( BookingId BusID  )
*      WITH VALUE #( ( BookingUuid = '02D5290E594C1EDA93815057FD949924' ) )
*      RESULT DATA(travels).
*    out->write( travels ).

" step 3 - READ with All Fields
*    READ ENTITIES OF ZI_ET1_TAB_BOOKING
*      ENTITY Booking
*        ALL FIELDS
*      WITH VALUE #( ( BookingUuid = '02D5290E594C1EDA93815057FD949924' ) )
*      RESULT DATA(travels).
*
*    out->write( travels ).
 " step 4 - READ By Association
*    READ ENTITIES OF ZI_ET1_TAB_BOOKING
*      ENTITY Booking BY \_Passenger
*        ALL FIELDS WITH VALUE #( (  BookingUuid = '02D5290E594C1EDA93815057FD949924' ) )
*      RESULT DATA(bookings).
*
*    out->write( bookings ).
 " step 5 - Unsuccessful READ
*     READ ENTITIES OF ZI_ET1_TAB_BOOKING
*       ENTITY Booking
*         ALL FIELDS WITH VALUE #( ( BookingUuid = '11111111111111111111111111111111' ) )
*       RESULT DATA(travels)
*       FAILED DATA(failed)
*       REPORTED DATA(reported).
*
*     out->write( travels ).
*     out->write( failed ).    " complex structures not supported by the console output
*     out->write( reported ).  " complex structures not supported by the console output

      " step 6 - MODIFY Update
     MODIFY ENTITIES OF ZI_ET1_TAB_BOOKING
       ENTITY Booking
         UPDATE
           SET FIELDS WITH VALUE
             #( (  BookingUuid = '02D5290E594C1EDA93815057FD949924'
                  BookingStatus = 'Cancelled' ) )

      FAILED DATA(failed)
      REPORTED DATA(reported).

      COMMIT ENTITIES
       RESPONSE OF ZI_ET1_TAB_BOOKING
       FAILED     DATA(failed_commit)
       REPORTED   DATA(reported_commit).

     out->write( 'Update done' ).
  ENDMETHOD.
ENDCLASS.
