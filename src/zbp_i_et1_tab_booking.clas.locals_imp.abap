CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF Booking_status,
        Booked    TYPE i VALUE 3,
        Cancelled TYPE i VALUE 1,
      END OF Booking_status.


    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

*    METHODS acceptBooking FOR MODIFY
*      IMPORTING keys FOR ACTION Booking~acceptBooking RESULT result.

    METHODS recalcTotalAmount FOR MODIFY
      IMPORTING keys FOR ACTION Booking~recalcTotalAmount.

    METHODS rejectBooking FOR MODIFY
      IMPORTING keys FOR ACTION Booking~rejectBooking RESULT result.

    METHODS calculateBookingID FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~calculateBookingID.

    METHODS setBookingStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR Booking~setBookingStatus.

    METHODS validateBusDetails FOR VALIDATE ON SAVE
      IMPORTING keys FOR Booking~validateBusDetails.

*    METHODS acceptBooking FOR MODIFY
*      IMPORTING keys FOR ACTION Booking~acceptBooking RESULT result.




ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.



  METHOD recalcTotalAmount.
  ENDMETHOD.


  METHOD rejectBooking.
*    MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
*      ENTITY Booking
*         UPDATE
*           FIELDS ( BookingStatus )
*           WITH VALUE #( FOR key IN keys
*                           ( %tky         = key-%tky
*                             BookingStatus =  'Cancelled'
*                             Criticality = Booking_status-Cancelled ) )
*      FAILED failed
*      REPORTED reported.
*
*    " Fill the response table
*    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
*      ENTITY Booking
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(bookings).
*
*    result = VALUE #( FOR booking IN bookings
*                        ( %tky   = booking-%tky
*                          %param = booking ) ).

  ENDMETHOD.

  METHOD calculateBookingID.
    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Booking
            FIELDS ( BookingId ) with CORRESPONDING #( keys )
        RESULT DATA(bookings).

    DELETE bookings WHERE BookingId is not INITIAL.
    CHECK bookings is not INITIAL.

    SELECT SINGLE FROM zet1_tab_booking FIELDS max( booking_id ) as BookingId
    INTO @data(max_bookingId).

    MODIFY ENTITIES of zi_et1_tab_booking IN LOCAL MODE
    ENTITY Booking
    UPDATE
        from value #( for booking in bookings INDEX into i (
            %tky     = booking-%tky
            BookingId = max_bookingId + 1
            %control-BookingId = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD setBookingStatus.

    MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
    ENTITY Booking
    UPDATE FIELDS ( BookingStatus Criticality )
    WITH VALUE #( FOR key in keys (
            %tky = key-%tky
            BookingStatus = 'Booked'
            Criticality = Booking_status-Booked
        ) )
        FAILED DATA(failed)
        REPORTED DATA(update_reported).


  ENDMETHOD.

  METHOD validateBusDetails.
  ENDMETHOD.

*METHOD acceptBooking.
*  ENDMETHOD.
ENDCLASS.
