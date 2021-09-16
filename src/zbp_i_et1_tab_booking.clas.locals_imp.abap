CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF Booking_status,
        Booked    TYPE i VALUE 3,
        Cancelled TYPE i VALUE 1,
      END OF Booking_status.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.

    METHODS unbooking FOR MODIFY
      IMPORTING keys FOR ACTION Booking~unbooking RESULT result.

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

*  METHOD get_instance_features.
*  ENDMETHOD.

METHOD get_features.
*   " Read the travel status of the existing travels
    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
      ENTITY Booking
        FIELDS ( BookingStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(bookings)
      FAILED failed.

    result =
      VALUE #(
        FOR booking IN bookings
            LET is_accepted =   COND #( WHEN booking-BookingStatus = 'Booked'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_rejected =   COND #( WHEN booking-BookingStatus = 'Cancelled'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = booking-%tky
              %action-unbooking =  is_rejected
             ) ).
*
*
*                ( %tky                 = booking-%tky
*              %action-unbooking = if_abap_behv=>fc-o-enabled
*
*             ) ).

  ENDMETHOD.

  METHOD unbooking.
    MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
      ENTITY Booking
         UPDATE
           FIELDS ( BookingStatus )
           WITH VALUE #( FOR key IN keys
                           ( %tky         = key-%tky
                             BookingStatus =  'Cancelled'
                             Criticality = Booking_status-Cancelled ) )
      FAILED failed
      REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
      ENTITY Booking
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(bookings).

    result = VALUE #( FOR booking IN bookings
                        ( %tky   = booking-%tky
                          %param = booking ) ).

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

      DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
      DATA: LV_JO TYPE zgrp2_id_new .
      DATA: LV_JO_OPT TYPE zgrp2_id_new.

      TRY.

        CALL METHOD cl_numberrange_runtime=>number_get
            EXPORTING
                nr_range_nr = '01'
                object = 'ZET21_PNR'

            IMPORTING
                number = nr_number.
        CATCH cx_nr_object_not_found.
        CATCH cx_number_ranges.

      ENDTRY.
    MODIFY ENTITIES of zi_et1_tab_booking IN LOCAL MODE
    ENTITY Booking
    UPDATE
        from value #( for booking in bookings INDEX into i (
            %tky     = booking-%tky
            BookingId = max_bookingId + 1
*            BookingId = nr_number
            %control-BookingId = if_abap_behv=>mk-on ) )
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).


    " gen number range

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
    DATA output TYPE I.
    CALL METHOD zbp_i_et1_tab_method=>update_waitingListNo
        EXPORTING passenger_key = '02A63665CD761EEC85BD12556EFA4997'
        IMPORTING output = output.
  ENDMETHOD.

ENDCLASS.
