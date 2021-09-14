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
      @EndUserText.label: 'Bus'
      @ObjectModel.text.element: ['BusName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'BusId'}, 
      additionalBinding: [ { localElement: 'StartPoint',    element: 'StartPoint', usage: #RESULT },
                           { localElement: 'EndPoint',   element: 'EndPoint',   usage: #RESULT},
                           { localElement: 'StartDate',  element: 'StartDate',        usage: #RESULT },
                           { localElement: 'EndDate', element: 'EndDate', usage: #RESULT } ]}]
      BusId,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Bus Name'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'BusName'},
      additionalBinding: [ { localElement: 'StartPoint',    element: 'StartPoint', usage: #RESULT },
                           { localElement: 'EndPoint',   element: 'EndPoint',   usage: #RESULT},
                           { localElement: 'StartDate',  element: 'StartDate',        usage: #RESULT },
                           { localElement: 'EndDate', element: 'EndDate', usage: #RESULT } ]}]
      BusName,
      @EndUserText.label: 'From'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'StartPoint'},
      additionalBinding: [ { localElement: 'BusId',    element: 'BusId', usage: #RESULT },
                           { localElement: 'EndPoint',   element: 'EndPoint',   usage: #RESULT},
                           { localElement: 'StartDate',  element: 'StartDate',        usage: #RESULT },
                           { localElement: 'EndDate', element: 'EndDate', usage: #RESULT } ] }]
      StartPoint,
      @EndUserText.label: 'To'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'EndPoint'},
      additionalBinding: [ { localElement: 'BusId',    element: 'BusId' ,  usage: #RESULT},
                           { localElement: 'StartPoint',   element: 'StartPoint',   usage: #RESULT},
                           { localElement: 'StartDate',  element: 'StartDate',        usage: #RESULT },
                           { localElement: 'EndDate', element: 'EndDate', usage: #RESULT } ]}]
      EndPoint,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Start Date'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'StartDate'},
      additionalBinding: [ { localElement: 'BusId',    element: 'BusId' ,  usage: #RESULT},
                           { localElement: 'StartPoint',   element: 'StartPoint',   usage: #RESULT},
                           { localElement: 'EndPoint',  element: 'EndPoint',        usage: #RESULT },
                           { localElement: 'EndDate', element: 'EndDate', usage: #RESULT } ] }]
      StartDate,
      @Search.defaultSearchElement: true
      @EndUserText.label: 'End Date'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ET1_TAB_BUS', element: 'EndDate'},
       additionalBinding: [ { localElement: 'BusId',    element: 'BusId' ,  usage: #RESULT},
                           { localElement: 'StartPoint',   element: 'StartPoint',   usage: #RESULT},
                           { localElement: 'EndPoint', element: 'EndPoint', usage: #RESULT },
                           { localElement: 'StartDate',  element: 'StartDate',        usage: #RESULT } ] }]
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
