CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

    METHODS recalcTotalAmount FOR MODIFY
      IMPORTING keys FOR ACTION Booking~recalcTotalAmount.

    METHODS unbooking FOR MODIFY
      IMPORTING keys FOR ACTION Booking~unbooking RESULT result.

    METHODS calculateBookingID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~calculateBookingID.

    METHODS setBookingStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~setBookingStatus.

    METHODS validateBusDetails FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateBusDetails.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD recalcTotalAmount.
  ENDMETHOD.

  METHOD unbooking.
  ENDMETHOD.

  METHOD calculateBookingID.
  ENDMETHOD.

  METHOD setBookingStatus.
  ENDMETHOD.

  METHOD validateBusDetails.
  ENDMETHOD.

  METHOD get_features.
   " Read the travel status of the existing travels
    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(bookings)
      FAILED failed.

    result =
      VALUE #(
        FOR booking IN bookings


            ( %tky                 = booking-%tky
              %action-unbooking = if_abap_behv=>fc-o-enabled

             ) ).

  ENDMETHOD.

ENDCLASS.
