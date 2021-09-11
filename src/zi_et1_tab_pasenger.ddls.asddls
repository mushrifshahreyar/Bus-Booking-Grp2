@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface view for passenger'
define view entity ZI_ET1_TAB_PASENGER as select from zet1_tab_pasengr 
association to parent ZI_ET1_TAB_BOOKING as _Booking on $projection.BookingUuid = _Booking.BookingUuid
{
    key passenger_uuid as PassengerUuid,
    booking_uuid as BookingUuid,
    passenger_id as PassengerId,
    first_name as FirstName,
    last_name as LastName,
    age as Age,
    contact_number as ContactNumber,
    passenger_status as PassengerStatus,
    waitlist_number as WaitlistNumber,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    _Booking
}
