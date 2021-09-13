@EndUserText.label: 'Projection view for booking'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: ['BookingId']
define root view entity ZC_ET1_TAB_BOOKING
  as projection on ZI_ET1_TAB_BOOKING
{

  key BookingUuid,
      @EndUserText.label: 'PNR Number'
      @Search.defaultSearchElement: true
      BookingId,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Bus Id'
      BusId,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Bus Name'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'BusName'}, 
      additionalBinding: [ { localElement: 'BusId',    element: 'BusId' },{ localElement: 'StartPoint',    element: 'StartPoint' },
                                                                 { localElement: 'EndPoint',   element: 'EndPoint',   usage: #RESULT},
                                                                 { localElement: 'StartDate',  element: 'StartDate',        usage: #RESULT },
                                                                 { localElement: 'EndDate', element: 'EndDate', usage: #RESULT } ] }]
      BusName,
      @EndUserText.label: 'From'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'StartPoint'} }]
      StartPoint,
      @EndUserText.label: 'To'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'EndPoint'} }]
     EndPoint,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Start Date'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'StartDate'} }]
     StartDate,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'End Date'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'EndDate'} }]
      EndDate,
      @EndUserText.label: 'Booking Status'
      @Search.defaultSearchElement: true
      BookingStatus,
      Criticality,
      @EndUserText.label: 'Created By'
      @Search.defaultSearchElement: true
      CreatedBy,
      @EndUserText.label: 'Created At'
      @Search.defaultSearchElement: true
      CreatedAt,
      @EndUserText.label: 'Last Changed By'
      @Search.defaultSearchElement: true
      LastChangedBy,
      @EndUserText.label: 'Last Changed At'
      @Search.defaultSearchElement: true
      LastChangedAt,
      /* Associations */
      _Bus,
      _Passenger : redirected to composition child ZC_ET1_TAB_PASENGER
}
