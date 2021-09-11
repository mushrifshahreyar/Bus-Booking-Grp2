@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface view for bus'

define view entity ZI_ET1_TAB_BUS as select from zet1_tab_bus {
    key bus_uuid as BusUuid,
    bus_id as BusId,
    bus_name as BusName,
    bus_capacity as BusCapacity,
    start_point as StartPoint,
    end_point as EndPoint,
    start_date as StartDate,
    end_date as EndDate,
    seats_left as SeatsLeft,
    total_waitlist as TotalWaitlist
}
