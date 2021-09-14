CLASS lhc_Passenger DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF Passenger_status,
        Confirmed    TYPE i VALUE 3,
        waitlist    type i value 0,
        Cancelled TYPE i VALUE 1,
      END OF PASSENGER_STATUS.

    METHODS calculatePassenerStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Passenger~calculatePassenerStatus.

    METHODS calculatePassengerID FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Passenger~calculatePassengerID.


ENDCLASS.

CLASS lhc_Passenger IMPLEMENTATION.

  METHOD calculatePassenerStatus.

*    DATA zseats_left TYPE abap_boolean.
    DATA zwait_list_no TYPE I value 0.
    DATA zcriticality type I.
    data zstatus type c length 15.
    data zseats_left type i value 0.

    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Passenger BY \_Booking
            FIELDS ( BookingUuid ) with CORRESPONDING #( keys )
        RESULT DATA(bookings).

    LOOP AT bookings INTO DATA(booking).
        READ ENTITIES of zi_et1_tab_booking in LOCAL MODE
            ENTITY Booking
                FIELDS ( BusId )
            WITH VALUE #( ( %tky = booking-%tky ) )
            RESULT DATA(buses).

    ENDLOOP.

    LOOP AT buses INTO DATA(bus).
        SELECT SINGLE FROM zet1_tab_bus FIELDS seats_left , total_waitlist , bus_uuid
        WHERE bus_id = @bus-BusId
        INTO @DATA(bus_details).

        if bus_details-seats_left > 0.
*            zseats_left = abap_true.
            zstatus = 'Confirmed'.
            zwait_list_no = 0.
            zcriticality = passenger_status-confirmed.
            zseats_left = bus_details-seats_left - 1.
        else.
*            zseats_left = abap_false.
             zstatus = 'In Waitlist'.
             zwait_list_no = bus_details-total_waitlist + 1.
             zcriticality = passenger_status-waitlist.

        endif.

        " Update status
        MODIFY ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
               ENTITY Passenger
                UPDATE FIELDS ( PassengerStatus Criticality WaitlistNumber )
                WITH VALUE #( FOR key in keys (
                %tky      = key-%tky
                PassengerStatus = zstatus
                Criticality = zcriticality
                WaitlistNumber = zwait_list_no
            ) )
            FAILED DATA(failed)
            REPORTED DATA(update_reported).

       DATA itab TYPE zet1_tab_bus.
       DATA itab_new TYPE TABLE OF zet1_tab_bus.

       SELECT SINGLE * FROM zet1_tab_bus WHERE bus_uuid = @bus_details-bus_uuid into @itab.
       itab-seats_left = zseats_left.
       itab-total_waitlist = zwait_list_no.

       APPEND itab to itab_new.



       UPDATE zet1_tab_bus FROM TABLE @itab_new.




    ENDLOOP.




  ENDMETHOD.

  METHOD calculatePassengerID.
    DATA max_passengerid TYPE zgrp2_id_new.
    DATA update TYPE TABLE FOR UPDATE zi_et1_tab_booking\\Passenger.

    READ ENTITIES OF zi_et1_tab_booking IN LOCAL MODE
        ENTITY Passenger BY \_Booking
            FIELDS ( BookingUuid ) with CORRESPONDING #( keys )
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

ENDCLASS.
