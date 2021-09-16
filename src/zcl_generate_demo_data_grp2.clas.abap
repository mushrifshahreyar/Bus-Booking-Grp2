CLASS zcl_generate_demo_data_grp2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_generate_demo_data_grp2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DELETE FROM zet1_tab_booking.
*   delete existing entries in the database table
    DELETE FROM zet1_tab_pasengr.
*   delete existing entries in the database table
    DELETE FROM zet1_tab_bus.

    DATA itab TYPE TABLE OF zet1_tab_booking.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( booking_uuid = '02D5290E594C1EDA93815057FD949924' booking_id = '0001' bus_id = '0701' booking_status = 'Booked' created_by = 'ALIFIYA'
created_at = '20210922184530' last_changed_by = 'ALIFIYA' last_changed_at = '20210922184530' )
    ).


    DATA itab1 TYPE TABLE OF zet1_tab_pasengr.

*   fill internal travel table (itab1)
    itab1 = VALUE #(
      ( passenger_uuid = '02D5290E594C1EDA93815057FD949926' booking_uuid = '02D5290E594C1EDA93815057FD949924' passenger_id = '0601' first_name = 'Alifiya' last_name = 'Hussain' age = '23' contact_number = '9876543299' passenger_status = 'Confirmed'
waitlist_number = '0'
created_by = 'ALIFIYA' created_at = '20210922184530' last_changed_by = 'ALIFIYA' last_changed_at = '20210922184530' )

    ).

    DATA itab2 TYPE TABLE OF zet1_tab_bus.

*   fill internal travel table (itab2)
    itab2 = VALUE #(
      ( bus_uuid = '02D5290E594C1EDA90815057FD949930' bus_id = '0701' bus_name = 'Parveen Travels' bus_capacity = '30' start_point = 'Mumbai' end_point = 'Bangalore' start_date = '20210921184530' end_date = '20210922184530' seats_left = '10'
total_waitlist = '0' )
      ( bus_uuid = '02D5290E594C1EDA90815057FD967930' bus_id = '0702' bus_name = 'Arveen Travels' bus_capacity = '30' start_point = 'Bangalore' end_point = 'Mumbai' start_date = '20210921184530' end_date = '20210922184530' seats_left = '10'
total_waitlist = '0' )
      ( bus_uuid = '02D5290E594C1EFA90815057FD968930' bus_id = '0703' bus_name = 'Teen Travels' bus_capacity = '30' start_point = 'Bangalore' end_point = 'Mumbai' start_date = '20210921184530' end_date = '20210922184530' seats_left = '1'
total_waitlist = '0' )

    ).


*   insert the new table entries
    INSERT zet1_tab_booking FROM TABLE @itab.
*   insert the new table entries
    INSERT zet1_tab_pasengr FROM TABLE @itab1.
*   insert the new table entries
    INSERT zet1_tab_bus FROM TABLE @itab2.

*   output the result as a console message
    out->write( |{ sy-dbcnt } travel entries inserted successfully!| ).

  ENDMETHOD.
ENDCLASS.
