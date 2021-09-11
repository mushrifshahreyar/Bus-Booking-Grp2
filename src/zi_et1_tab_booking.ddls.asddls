@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface view for booking table'
define root view entity ZI_ET1_TAB_BOOKING as select from zet1_tab_booking 
composition [0..*] of ZI_ET1_TAB_PASENGER as _Passenger
association [0..1] to ZI_ET1_TAB_BUS as _Bus on $projection.BusId = _Bus.BusId

{
    key booking_uuid as BookingUuid,
    booking_id as BookingId,
    bus_id as BusId,
    booking_status as BookingStatus,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _Passenger,
    _Bus
}
