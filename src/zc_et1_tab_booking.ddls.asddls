@EndUserText.label: 'Projection view for booking'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZC_ET1_TAB_BOOKING
  as projection on ZI_ET1_TAB_BOOKING
{

  key BookingUuid,
      @EndUserText.label: 'PNR Number'
      @Search.defaultSearchElement: true
      BookingId,
      @Search.defaultSearchElement: true
      BusId,
      @EndUserText.label: 'Bus Name'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'BusName'} }]
      _Bus.BusName    as BusName,
      @EndUserText.label: 'From'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'StartPoint'} }]
      _Bus.StartPoint as StartPoint,
      @EndUserText.label: 'To'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'EndPoint'} }]
      _Bus.EndPoint as EndPoint,
      @EndUserText.label: 'Start Date'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'StartDate'} }]
      _Bus.StartDate as StartDate,
      @EndUserText.label: 'End Date'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'EndDate'} }]
      _Bus.EndDate as EndDate,
      @EndUserText.label: 'Booking Status'
      BookingStatus,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Created At'
      CreatedAt,
      @EndUserText.label: 'Last Changed By'
      LastChangedBy,
      @EndUserText.label: 'Last Changed At'
      LastChangedAt,
      /* Associations */
      _Bus,
      _Passenger : redirected to composition child ZC_ET1_TAB_PASENGER
}
