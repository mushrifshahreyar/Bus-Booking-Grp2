CLASS lhc_Passenger DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF Passenger_status,
        Confirmed TYPE i VALUE 3,
        waitlist  TYPE i VALUE 0,
        Cancelled TYPE i VALUE 1,
      END OF passenger_status.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Passenger RESULT result.

    METHODS calculatePassenerStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Passenger~calculatePassenerStatus.

    METHODS calculatePassengerID FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Passenger~calculatePassengerID.

    METHODS cancellation FOR MODIFY
      IMPORTING keys FOR ACTION Passenger~cancellation RESULT result.


ENDCLASS.

CLASS lhc_Passenger IMPLEMENTATION.

  METHOD calculatePassenerStatus.

*    DATA zseats_left TYPE abap_boolean.
    DATA zwait_list_no TYPE i VALUE 0.
    DATA zcriticality TYPE i.
    DATA zstatus TYPE c LENGTH 15.
    DATA zseats_left TYPE i VALUE 0.

    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Passenger BY \_Booking
            FIELDS ( BookingUuid ) WITH CORRESPONDING #( keys )
        RESULT DATA(bookings).

    LOOP AT bookings INTO DATA(booking).
      READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
          ENTITY Booking
              FIELDS ( BusId )
          WITH VALUE #( ( %tky = booking-%tky ) )
          RESULT DATA(buses).

    ENDLOOP.

    LOOP AT buses INTO DATA(bus).
      SELECT SINGLE FROM zet1_tab_bus FIELDS seats_left , total_waitlist , bus_uuid
      WHERE bus_id = @bus-BusId
      INTO @DATA(bus_details).

      IF bus_details-seats_left > 0.
*            zseats_left = abap_true.
        zstatus = 'Confirmed'.
        zwait_list_no = 0.
        zcriticality = passenger_status-confirmed.
        zseats_left = bus_details-seats_left - 1.
      ELSE.
*            zseats_left = abap_false.
        zstatus = 'In Waitlist'.
        zwait_list_no = bus_details-total_waitlist + 1.
        zcriticality = passenger_status-waitlist.

      ENDIF.

      " Update status
      MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
             ENTITY Passenger
              UPDATE FIELDS ( PassengerStatus Criticality WaitlistNumber )
              WITH VALUE #( FOR key IN keys (
              %tky      = key-%tky
              PassengerStatus = zstatus
              Criticality = zcriticality
              WaitlistNumber = zwait_list_no
          ) )
          FAILED DATA(failed)
          REPORTED DATA(update_reported).

      DATA itab TYPE zet1_tab_bus.
      DATA itab_new TYPE TABLE OF zet1_tab_bus.

      SELECT SINGLE * FROM zet1_tab_bus WHERE bus_uuid = @bus_details-bus_uuid INTO @itab.
      itab-seats_left = zseats_left.
      itab-total_waitlist = zwait_list_no.

      APPEND itab TO itab_new.



      UPDATE zet1_tab_bus FROM TABLE @itab_new.

    ENDLOOP.




  ENDMETHOD.

  METHOD calculatePassengerID.
    DATA max_passengerid TYPE zgrp2_id_new.
    DATA update TYPE TABLE FOR UPDATE zi_et1_tab_booking\\Passenger.

    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Passenger BY \_Booking
            FIELDS ( BookingUuid ) WITH CORRESPONDING #( keys )
        RESULT DATA(bookings).

    LOOP AT bookings INTO DATA(booking).
      READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Booking BY \_Passenger
          FIELDS ( PassengerId )
        WITH VALUE #( ( %tky = booking-%tky ) )
        RESULT DATA(passengers).

      " Find max used BookingID in all bookings of this travel
      max_passengerid ='0000'.
      LOOP AT passengers INTO DATA(passenger).
        IF passenger-PassengerId > max_passengerid.
          max_passengerid = passenger-PassengerId.
        ENDIF.
      ENDLOOP.

      " Provide a booking ID for all bookings that have none.
      LOOP AT passengers INTO passenger WHERE PassengerId IS INITIAL.
        max_passengerid += 1.
        APPEND VALUE #( %tky      = passenger-%tky
                        PassengerId = max_passengerid
                      ) TO update.
      ENDLOOP.
    ENDLOOP.

    " Update the Booking ID of all relevant bookings
    MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
    ENTITY Passenger
      UPDATE FIELDS ( PassengerId ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD cancellation.





*        Updating waitlist number
    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
      ENTITY Passenger BY \_Booking
          FIELDS ( BusId ) WITH CORRESPONDING #( keys )
      RESULT DATA(booking_busids).

    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Passenger
            FIELDS ( WaitlistNumber ) WITH CORRESPONDING #( keys )
           RESULT DATA(waiting_list_nos).


*    LOOP AT booking_busids into data(booking_busid).
*        READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
*            ENTITY Booking
*                FIELDS ( BookingUuid ) with value #( %control-BusId = booking_busid )
*                    RESULT DATA(booking_uuids).
*    ENDLOOP.

    DATA itab_booking TYPE TABLE OF zet1_tab_booking.
    Data itab_pass type table of zet1_tab_pasengr.
    Data itab_pass_temp type table of zet1_tab_pasengr.

    LOOP AT booking_busids into data(booking_busid).
         SELECT * FROM zet1_tab_booking WHERE bus_id = @booking_busid-BusId into table @itab_booking.

    ENDLOOP.

    LOOP AT itab_booking into data(_itab_booking_inst).
        SELECT * FROM zet1_tab_pasengr WHERE booking_uuid = @_itab_booking_inst-booking_uuid into table @itab_pass_temp.
            loop at itab_pass_temp into data(_itab).
                insert _itab into table itab_pass.
             ENDLOOP.
*            READ ENTITIES OF zi_et1_tab_booking
*                ENTITY Passenger
*                    FIELDS ( PassengerUuid ) with value #( ( %control-BookingUuid = _itab_booking_inst-booking_uuid ) )
*                        RESULT DATA(temp_).
    ENDLOOP.

    loop at waiting_list_nos into data(waiting_list_no).
        loop at itab_pass into data(_itab_pass_inst).
            if _itab_pass_inst-waitlist_number > waiting_list_no-WaitlistNumber AND _itab_pass_inst-passenger_status = 'In Waitlist'.
                MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
                    ENTITY Passenger
                        UPDATE FIELDS ( WaitlistNumber )
                            WITH VALUE #( (
                                PassengerUuid = _itab_pass_inst-passenger_uuid
                                WaitlistNumber = _itab_pass_inst-waitlist_number - 1 ) )
                            FAILED failed
                            REPORTED reported.
                _itab_pass_inst-waitlist_number = _itab_pass_inst-waitlist_number - 1.
            endif.
            if _itab_pass_inst-waitlist_number = 0 AND _itab_pass_inst-passenger_status = 'In Waitlist'.
                MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
                    ENTITY Passenger
                        UPDATE FIELDS ( PassengerStatus )
                            WITH VALUE #( (
                                PassengerUuid = _itab_pass_inst-passenger_uuid
                                PassengerStatus = 'Confirmed' ) )
                            FAILED failed
                            REPORTED reported.
                 _itab_pass_inst-passenger_status = 'Confirmed'.
            endif.
        endloop.
    endloop.

    MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Passenger
           UPDATE
             FIELDS ( PassengerStatus Criticality WaitlistNumber )
             WITH VALUE #( FOR key IN keys
                             ( %tky         = key-%tky
                               PassengerStatus =  'Cancelled'
                               Criticality = Passenger_status-cancelled
                               WaitlistNumber = 0 ) )
        FAILED failed
        REPORTED reported.

      DATA itab_bus TYPE zet1_tab_bus.
      DATA itab_bus_temp TYPE TABLE OF zet1_tab_bus.

*      LOOP AT booking_busids into data(booking_busid).
      SELECT SINGLE * FROM zet1_tab_bus WHERE bus_id = @booking_busid-BusId INTO @itab_bus.
*      endloop.
      if itab_bus-total_waitlist > 0.
             itab_bus-total_waitlist = itab_bus-total_waitlist - 1.

      elseif itab_bus-total_waitlist <= 0.

             itab_bus-seats_left = itab_bus-seats_left + 1.
      endif.
      APPEND itab_bus TO itab_bus_temp.

      UPDATE zet1_tab_bus FROM TABLE @itab_bus_temp.

*    DATA itab TYPE TABLE OF zet1_tab_booking.
*    DATA itab_pass TYPE TABLE OF zet1_tab_pasengr.
*    DATA itab_pass_temp TYPE TABLE OF zet1_tab_pasengr.
*
*    LOOP AT booking_busids INTO DATA(temp).
*
*
*      SELECT * FROM zet1_tab_booking WHERE bus_id = @temp-BusId INTO TABLE @itab.
**        out->write( itab ).
*
*      LOOP AT itab INTO DATA(_itab).
*        SELECT * FROM zet1_tab_pasengr WHERE booking_uuid = @_itab-booking_uuid INTO TABLE @itab_pass_temp.
*
*        LOOP AT itab_pass_temp INTO DATA(_itab_).
*          INSERT _itab_ INTO TABLE itab_pass.
*        ENDLOOP.
*
*      ENDLOOP.
**        out->write( itab_pass ).
**
*      LOOP AT waiting_list_nos INTO DATA(waiting_list_no).
*
*        LOOP AT itab_pass INTO DATA(_itab1_).
*
*
*          IF _itab1_-passenger_status <> 'Confirmed'.
*
*            IF _itab1_-waitlist_number > waiting_list_no-WaitlistNumber.
*              _itab1_-waitlist_number = _itab1_-waitlist_number - 1.
*            ENDIF.
*          ENDIF.
*          IF _itab1_-passenger_status = 'Cancelled'.
*
*            _itab1_-waitlist_number = 0.
*          ENDIF.
*
*          IF _itab1_-waitlist_number = 0 AND _itab1_-passenger_status <> 'Cancelled'.
*            _itab1_-passenger_status = 'Confirmed'.
*          ENDIF.
*
*          MODIFY itab_pass FROM _itab1_.
*
*        ENDLOOP.
*      ENDLOOP.
*
*
*
*    ENDLOOP.
*    UPDATE zet1_tab_pasengr FROM TABLE @itab_pass.
*        out->write( itab_pass ).





*        --------------------

    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
    ENTITY Passenger
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(passengers).

    result = VALUE #( FOR passenger IN passengers
                        ( %tky   = passenger-%tky
                          %param = passenger ) ).






  ENDMETHOD.

  METHOD get_features.
    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
      ENTITY Passenger
        FIELDS ( PassengerStatus ) WITH CORRESPONDING #( keys )
      RESULT DATA(passengers)
      FAILED failed.

    result =
      VALUE #(
        FOR passenger IN passengers
            LET is_accepted =   COND #( WHEN passenger-PassengerStatus = 'Confirmed' OR passenger-PassengerStatus = 'In Waitlist'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled  )
              is_rejected =   COND #( WHEN passenger-PassengerStatus = 'Cancelled'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled )
          IN
            ( %tky                 = passenger-%tky
              %action-cancellation =  is_rejected
             ) ).

  ENDMETHOD.

ENDCLASS.
