@EndUserText.label: 'Projection view for passenger'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZC_ET1_TAB_PASENGER as projection on ZI_ET1_TAB_PASENGER {
    key PassengerUuid,
    BookingUuid,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Passenger ID'
    PassengerId,
    @EndUserText.label: 'First Name'
    @Search.defaultSearchElement: true
    FirstName,
    @EndUserText.label: 'Last Name'
    @Search.defaultSearchElement: true
    LastName,
    @EndUserText.label: 'Age'
    @Search.defaultSearchElement: true
    Age,
    @EndUserText.label: 'Contact Number'
    @Search.defaultSearchElement: true
    ContactNumber,
    @EndUserText.label: 'Passenger Status'
    @Search.defaultSearchElement: true
    PassengerStatus,
    @EndUserText.label: 'Waitlist Number'
    @Search.defaultSearchElement: true
    WaitlistNumber,
    @EndUserText.label: 'Created By'
    CreatedBy,
    @EndUserText.label: 'Created At'
    CreatedAt,
    @EndUserText.label: 'Last Changed By'
    LastChangedBy,
    @EndUserText.label: 'Last Changed At'
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent ZC_ET1_TAB_BOOKING
}
