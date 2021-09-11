@EndUserText.label: 'Projection view for booking'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_ET1_TAB_BOOKING
  as projection on ZI_ET1_TAB_BOOKING
{

  key BookingUuid,
      BookingId,
      @Search.defaultSearchElement: true
      BusId,
      _Bus.BusName    as BusName,
      _Bus.StartPoint as StartPoint,
      _Bus.EndPoint as EndPoint,
      _Bus.StartDate as StartDate,
      _Bus.EndDate as EndDate,
      BookingStatus,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      /* Associations */
      _Bus,
      _Passenger : redirected to composition child ZC_ET1_TAB_PASENGER
}
