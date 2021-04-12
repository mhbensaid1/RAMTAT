/**
* @author         Salesforce TAT Team
* @date           Feb 27, 2019
* @description    Manage Altea WS
* @history        
*/
public with sharing class TAT_AlteaManagement {

    public static Vol_TAT__c getFlightInfo(Vol_TAT__c volToUpdate, Integer passengerProcess, Integer ptm, Integer speReq){
        Map<String, String> AlteaSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_ALTEA_All_DATA_SETTINGS);
        TAT_AlteaBean.FlightInfoInput myRequest = new TAT_AlteaBean.FlightInfoInput();
        // input parameters
        myRequest.boardPoint = volToUpdate.Escale_depart_prevue__c;
        myRequest.flightNumber = ''+(integer)volToUpdate.Numero_du_vol__c;
        myRequest.marketingCarrier = 'AT';
        myRequest.departureDate = volToUpdate.Jour_du_vol__c;
        myRequest.departureTime = string.ValueOf(volToUpdate.Best_Time_Depart__c.format('HH:mm'));
        myRequest.getPassengerList = 0;
        myRequest.getPassengerProcess = passengerProcess;
        myRequest.getPtm = ptm;
        myRequest.getSpeReq = speReq; 
        System.debug('### myRequest '+myRequest);
        TAT_AlteaService.PasengerInfoServiceImplHttpSoap11Endpoint endpointInstance = new TAT_AlteaService.PasengerInfoServiceImplHttpSoap11Endpoint();
        endpointInstance.timeout_x = 120000;
        endpointInstance.endpoint_x = AlteaSettings.get('Altea End Point') +'.PasengerInfoServiceImplHttpSoap11Endpoint/';
        TAT_AlteaBean.FlightInfoOutput myResponse = endpointInstance.getFlightInfo(myRequest);
        System.debug('### myResponse '+myResponse);
        Vol_TAT__c vol;
        if(myResponse != null){
            vol = updateVol(myResponse, volToUpdate, ptm, speReq);
        }
        return vol;
    }

    public static List<TAT_PassagerWrapper> getPassagerInfo(Vol_TAT__c volToUpdate){
        Map<String, String> AlteaSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_ALTEA_All_DATA_SETTINGS);
        List<TAT_PassagerWrapper> passagerList = new List<TAT_PassagerWrapper>();
        TAT_AlteaBean.FlightInfoInput myRequest = new TAT_AlteaBean.FlightInfoInput();
        // input parameters
        myRequest.boardPoint = volToUpdate.Escale_depart_prevue__c;
        myRequest.flightNumber = ''+(integer)volToUpdate.Numero_du_vol__c;
        myRequest.marketingCarrier = 'AT';
        myRequest.departureDate = volToUpdate.Jour_du_vol__c;
        myRequest.departureTime = string.ValueOf(volToUpdate.Best_Time_Depart__c.format('HH:mm'));
        myRequest.getPassengerList = 1;
        myRequest.getPassengerProcess = 0;
        myRequest.getPtm = 0;
        myRequest.getSpeReq = 0; 
        TAT_AlteaService.PasengerInfoServiceImplHttpSoap11Endpoint endpointInstance = new TAT_AlteaService.PasengerInfoServiceImplHttpSoap11Endpoint();
        endpointInstance.timeout_x = 120000;
        endpointInstance.endpoint_x = AlteaSettings.get('Altea End Point') +'.PasengerInfoServiceImplHttpSoap11Endpoint/';
        TAT_AlteaBean.FlightInfoOutput myResponse = endpointInstance.getFlightInfo(myRequest);
        System.debug('### myResponse '+myResponse);
        Vol_TAT__c vol;
        if(myResponse == null){
            myResponse = endpointInstance.getFlightInfo(myRequest);
        }
        if(myResponse != null){
            if(myResponse.passengerList.passengers != null){
                for(TAT_AlteaBean.Passenger alteaPassager:myResponse.passengerList.passengers){
                    TAT_PassagerWrapper passager = new TAT_PassagerWrapper();
                    passager.classe = alteaPassager.classe;
                    passager.firstName = alteaPassager.firstName;
                    passager.lastName = alteaPassager.lastName;
                    passager.pnr = alteaPassager.pnr;
                    passager.seat = alteaPassager.seat;
                    passager.secNumber = alteaPassager.secNumber;
                    passager.specialReq = alteaPassager.specialReq;
                    passager.status = alteaPassager.status;
                    passagerList.add(passager);
                }
            }
        }
        return passagerList;
    }
    
    private static Vol_TAT__c updateVol(TAT_AlteaBean.FlightInfoOutput responseClass, Vol_TAT__c volToUpdate, Integer ptm, Integer speReq){
        if(ptm == 1){
            volToUpdate.Nombre_de_passagers_PTM_In_enregistres__c = responseClass.acceptedPtmIn;
            volToUpdate.Nombre_de_passagers_PTM_Out_enregistres__c = responseClass.acceptedPtmOut;
            volToUpdate.Nombre_de_passagers_PTM_In_embarques__c = responseClass.boardedPtmIn;
            volToUpdate.Nombre_de_passagers_PTM_Out_embarques__c = responseClass.boardedPtmOut;
            volToUpdate.Nombre_de_passagers_PTM_In__c = responseClass.expectedPtmIn;
            volToUpdate.Nombre_de_passagers_PTM_Out__c = responseClass.expectedPtmOut;
        }
        volToUpdate.Nombre_de_passagers__c = responseClass.expectedTotal;
        volToUpdate.Nombre_de_passagers_enregistres__c = responseClass.acceptedTotal;
        volToUpdate.Nombre_de_passagers_embarques__c = responseClass.boardedTotal;
        //New updates
        if(speReq == 1){
            volToUpdate.Business_prevus__c = responseClass.expectedY;
            volToUpdate.Eco_prevus__c  = responseClass.expectedJ;
            volToUpdate.Infant_prevus_bebe__c = responseClass.expectedInf;
            volToUpdate.Detail_par_sous_type_CHW__c = responseClass.spclWchDetail;
            volToUpdate.Detail_par_sous_type_CRE__c = responseClass.spclCreDetail;
            volToUpdate.Detail_par_sous_type_KID__c = responseClass.spclKidDetail;
            //volToUpdate.Boarding_end_time__c = responseClass.BoardingEndTime;
            volToUpdate.CRE__c = responseClass.spclCre;
            volToUpdate.KID__c = responseClass.spclKid;
            volToUpdate.WCH__c = responseClass.spclWch;
        }
        return volToUpdate;
    }
}