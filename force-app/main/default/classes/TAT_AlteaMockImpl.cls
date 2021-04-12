/**
* @author         Salesforce TAT Team
* @date           Mar 24, 2019
* @description    TAT Web service Mock 
* @history      
*
**/
@isTest
global class TAT_AlteaMockImpl implements WebServiceMock {
    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName, 
        String responseType) {
            TAT_AlteaService.getFlightInfoResponse_element respElement = new TAT_AlteaService.getFlightInfoResponse_element();
            TAT_AlteaBean.FlightInfoOutput responseClass = new TAT_AlteaBean.FlightInfoOutput();
            responseClass.acceptedPtmIn = 0;
            responseClass.acceptedPtmOut = 0;
            responseClass.acceptedTotal = 0;
            responseClass.boardedPtmIn = 0;
            responseClass.boardedPtmOut = 0;
            responseClass.boardedTotal = 0;
            responseClass.expectedBoardingTime = '0';
            responseClass.expectedPtmIn = 0;
            responseClass.expectedPtmOut = 0;
            responseClass.expectedTotal = 0;
            responseClass.spclCre = 0;
            responseClass.spclKid = 0;
            responseClass.spclWch = 0;
            responseClass.passengerList = new TAT_AlteaBean.PassengerList();
            responseClass.passengerList.passengers = new List<TAT_AlteaBean.Passenger>();
            TAT_AlteaBean.Passenger passenger = new TAT_AlteaBean.Passenger();
            passenger.firstName = '';
            passenger.lastName = '';
            passenger.pnr = '';
            passenger.seat = '';
            passenger.secNumber = '';
            passenger.specialReq = '';
            passenger.status = '';
            responseClass.passengerList.passengers.add(passenger);
            respElement.return_x = responseClass;
            response.put('response_x', respElement); 
        }
}