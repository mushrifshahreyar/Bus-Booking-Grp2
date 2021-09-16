@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for bus'

define view entity ZI_ET1_TAB_BUS as select from zet1_tab_bus as Bus {
    @UI.hidden: true
    @EndUserText.label: 'BusUuid'
    key bus_uuid as BusUuid,
    @EndUserText.label: 'Bus Id'
    @UI.lineItem: [{position: 10 }]
    bus_id as BusId,
    @EndUserText.label: 'Bus Name'
    @UI.lineItem: [{position: 20 }]
    bus_name as BusName,
    @EndUserText.label: 'Bus Capacity'
    @UI.lineItem: [{position: 30 }]
    bus_capacity as BusCapacity,
    @EndUserText.label: 'Travel Amount'
    @UI.lineItem: [{position: 60 }]
    travel_fare as TravelFare,
    @EndUserText.label: 'From'
    @UI.lineItem: [{position: 40 }]
    start_point as StartPoint,
    @UI.lineItem: [{position: 50 }]
    @EndUserText.label: 'To'
    end_point as EndPoint,
    @EndUserText.label: 'Start Date'
    @UI.lineItem: [{position: 80 }]
    start_date as StartDate,
    @EndUserText.label: 'End Date'
    @UI.lineItem: [{position: 90 }]
    end_date as EndDate,
    @EndUserText.label: 'Seats Left'
    @UI.lineItem: [{position: 60 }]
    seats_left as SeatsLeft,
    @UI.lineItem: [{position: 70 }]
    @EndUserText.label: 'Total Waitlist'
    total_waitlist as TotalWaitlist
}
