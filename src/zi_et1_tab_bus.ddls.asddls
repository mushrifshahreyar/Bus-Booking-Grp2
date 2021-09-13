@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface view for bus'

define view entity ZI_ET1_TAB_BUS as select from zet1_tab_bus as Bus {
    @UI.hidden: true
    @EndUserText.label: 'BusUuid'
    key bus_uuid as BusUuid,
    @EndUserText.label: 'Bus Id'
    bus_id as BusId,
    @EndUserText.label: 'Bus Name'
    bus_name as BusName,
    @EndUserText.label: 'Bus Capacity'
    bus_capacity as BusCapacity,
    @EndUserText.label: 'From'
    start_point as StartPoint,
    @EndUserText.label: 'To'
    end_point as EndPoint,
    @EndUserText.label: 'Start Date'
    start_date as StartDate,
    @EndUserText.label: 'End Date'
    end_date as EndDate,
    @EndUserText.label: 'Seats Left'
    seats_left as SeatsLeft,
    @EndUserText.label: 'Total Waitlist'
    total_waitlist as TotalWaitlist
}
