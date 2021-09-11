@EndUserText.label: 'Projection view for passenger'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_ET1_TAB_PASENGER as projection on ZI_ET1_TAB_PASENGER {
    key PassengerUuid,
    BookingUuid,
    @Search.defaultSearchElement: true
    PassengerId,
    FirstName,
    LastName,
    Age,
    ContactNumber,
    PassengerStatus,
    WaitlistNumber,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ZC_ET1_TAB_BOOKING
}