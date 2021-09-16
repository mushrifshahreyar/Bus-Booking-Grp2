CLASS zcl_et21_eml_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    METHODS temp_function
        IMPORTING VALUE(temp) TYPE I
        EXPORTING value(temp_out) type I.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ET21_EML_DEMO IMPLEMENTATION.


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


*DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
*      DATA: LV_JO TYPE zgrp2_id_new .
*      DATA: LV_JO_OPT TYPE zgrp2_id_new.
*
*      TRY.
*
*        CALL METHOD cl_numberrange_runtime=>number_get
*            EXPORTING
*                nr_range_nr = '01'
*                object = 'ZET21_PNR'
*
*            IMPORTING
*                number = nr_number.
*
*         out->write( nr_number ).
*        CATCH cx_nr_object_not_found.
*        CATCH cx_number_ranges.
*
*      ENDTRY.



    READ ENTITIES OF zi_et1_tab_booking
        ENTITY Passenger BY \_Booking
            FIELDS ( BusId ) with value #( ( PassengerUuid = '02A63665CD761EDC85CCE85A38EB87DA' )  )
        RESULT DATA(bookings).

        READ ENTITIES of zi_et1_tab_booking
            ENTITY Passenger
                FIELDS ( WaitlistNumber ) with value #( ( PassengerUuid = '02A63665CD761EDC85CCE85A38EB87DA' ) )
               RESULT DATA(waiting_list_nos).

*        out->write( bookings ).
*        out->write( waiting_list_nos ).
        DATA itab_booking TYPE TABLE OF zet1_tab_booking.
        Data itab_pass type table of zet1_tab_pasengr.
        Data itab_pass_temp type table of zet1_tab_pasengr.
        LOOP AT bookings into data(booking_busid).
         SELECT * FROM zet1_tab_booking WHERE bus_id = @booking_busid-BusId into table @itab_booking.
        out->write( itab_booking ).
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
        out->write( itab_pass ).
*        out->write( temp_ ).
*
*
*        Data itab_pass type table of zet1_tab_pasengr.
*        Data itab_pass_temp type table of zet1_tab_pasengr.
*        LOOP AT bookings INTO DATA(temp).
*
*        out->write( temp-BusId ).


*
*        READ ENTITIES OF zi_et1_tab_booking
*                ENTITY Booking
*                    FIELDS ( BookingUuid ) with value #( (  %control-BusId = temp-BusId ) )
*                    RESULT DATA(datas).
*
*        LOOP AT datas INTO DATA(temp2).
*            out->write( temp2-BookingUuid ).
*        ENDLOOP.
*
*
*
*        SELECT * FROM zet1_tab_booking WHERE bus_id = @temp-BusId into table @itab.
*        out->write( itab ).
*
*        LOOP AT itab into data(_itab).
*            SELECT * FROM zet1_tab_pasengr WHERE booking_uuid = @_itab-booking_uuid into table @itab_pass_temp.
*
*           loop at itab_pass_temp into data(_itab_).
*                insert _itab_ into table itab_pass.
*           ENDLOOP.
*
*        ENDLOOP.
*        out->write( itab_pass ).
*
*            LOOP at waiting_list_nos into data(waiting_list_no).
*                out->write( waiting_list_no-WaitlistNumber ).
*                 LOOP AT itab_pass into data(_itab1_).
*                    out->write( 'waiting list number:' ).
*                    out->write( _itab1_-waitlist_number ).
*                    IF _itab1_-passenger_status <> 'Confirmed'.
*                         out->write( 'rchd here1' ).
*                        IF _itab1_-waitlist_number > waiting_list_no-WaitlistNumber.
*                            _itab1_-waitlist_number = _itab1_-waitlist_number - 1.
*                        ENDIF.
*                    ENDIF.
*                    IF _itab1_-passenger_status = 'Cancelled'.
*                        out->write( 'rchd here2' ).
*                        _itab1_-waitlist_number = 0.
*                    ENDIF.
*
*                    IF _itab1_-waitlist_number = 0 AND _itab1_-passenger_status <> 'Cancelled'.
*                        _itab1_-passenger_status = 'Confirmed'.
*                    ENDIF.
*
*                     modify itab_pass FROM _itab1_.
*
*                 ENDLOOP.
*            ENDLOOP.
*
*        ENDLOOP.
*        out->write( itab_pass ).

*    DATA output TYPE I.
*    CALL METHOD zbp_i_et1_tab_method=>update_waitingListNo
*        EXPORTING passenger_key = '02A63665CD761EEC85BD12556EFA4997'
*        IMPORTING output = output.
*
*    out->write( 'Function called' ).
*    out->write( output ).



" step 3 - READ with All Fields
*    READ ENTITIES OF zi_et1_tab_booking
*      ENTITY Booking
*        ALL FIELDS
*      WITH VALUE #( ( BookingUuid = '02D5290E594C1EDA93815057FD949924' ) )
*      RESULT DATA(travels).
*
*    out->write( travels ).

 " step 4 - READ By Association
*    READ ENTITIES OF zi_et1_tab_booking
*      ENTITY Booking BY \_Passenger
*        ALL FIELDS WITH VALUE #( ( BookingUuid = '02B2A163BC961EEC85BCE27066C21167' ) )
*      RESULT DATA(bookings).
*
*    out->write( bookings ).

*MODIFY ENTITIES OF zi_et1_tab_booking
*       ENTITY  Booking
*         UPDATE
*           SET FIELDS WITH VALUE
*             #( ( BookingUuid = '02D5290E594C1EDA93815057FD949924'
*                  BookingId = '11' ) )
*
*      FAILED DATA(failed)
*      REPORTED DATA(reported).
*       COMMIT ENTITIES
*       RESPONSE OF zi_et1_tab_booking
*       FAILED     DATA(failed_commit)
*       REPORTED   DATA(reported_commit).
*
*
*     out->write( 'Update done' ).

ENDMETHOD.
  METHOD TEMP_FUNCTION.
    temp_out = temp + 1.

  ENDMETHOD.

ENDCLASS.
