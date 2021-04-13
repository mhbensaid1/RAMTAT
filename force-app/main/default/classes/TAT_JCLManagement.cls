/**
* @author         Salesforce TAT Team
* @date           Apr 12, 2021
* @description    Management class responsible of fetching crew members from JCL
* @history        
*/
public class TAT_JCLManagement {
    private static final String DEFAULT_AIRLINE_VALUE = 'AT';
    private static final String USER_ID_SETTING = 'JCL USERID';
    private static final String WEBSERVICE_TIMEOUT = 'JCL WebService Timeout';
    private static final String DEFAULT_FLIGHT_NUMBER_SEPARATOR = ','; 
    private static final String DEFAULT_DATES_SEPARATOR = '-'; 
    private static final String DEFAULT_DISPATCH_KEY_SEPARATOR = '_'; 

    /**
     * @description The method will get the list of the available crew members for a given list of flight numbers in a date period 
     * @param  flightNumbers List of flight numbers (ex : 777) 
     * @param  startDate     Used to limit the interval of the search to dates after the start date
     * @param  endDate       Used to limit the interval of the search to dates before the end date
     * @return               Crew members 
     */ 
    public static TAT_CrewBean.CrewRoster[] getCrewOnBoard(List<Integer> flightNumbers, String startDate, String endDate) {
        Map<String, String> jclSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_JCL_SETTINGS);
        String userID = jclSettings.get(USER_ID_SETTING);
        Integer timeout = Integer.valueOf(jclSettings.get(WEBSERVICE_TIMEOUT));

        TAT_CrewBean.FlightCrewInput flightCrewInput = populateWSInput(flightNumbers, startDate, endDate, userID);

        TAT_CrewService.CrewInfoServiceImplHttpSoap11Endpoint jclWebService = new TAT_CrewService.CrewInfoServiceImplHttpSoap11Endpoint();
        jclWebService.timeout_x = timeout;

        TAT_CrewBean.FlightCrewOutput response = jclWebService.getCrewOnBoard(flightCrewInput);

        if(response != null) {
            return response.crewRoster;
        }

        System.debug('### The Following request to JCL' + flightCrewInput + ' returned no results');
        return null;
    }

    /**
     * @description The method will update the flights crew based on an array of rosters & flights
     * @param  crewRosters crews on board
     * @param  flights available flights
     */
    public static void updateOnBoardCrews(TAT_CrewBean.CrewRoster[] crewRosters, Map<String, Vol_TAT__c> flights){
        Map<String, Dispatch_Vol__c> dispatchMap = new Map<String, Dispatch_Vol__c>();

        Map<String, String> roleMappings = TAT_Utils.getAppSetting(TAT_StaticConstants.JCL_ROLE_MAPPING);
        Id crewMemberRecordTypeId = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c', TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);

        for(TAT_CrewBean.CrewRoster crewRoster : crewRosters){
            String flightKey = buildFlightKey(crewRoster);
            if(flights.containsKey(flightKey) && roleMappings.containsKey(crewRoster.CREWCAT)){
                Vol_TAT__c flight = flights.get(flightKey);
                String role = roleMappings.get(crewRoster.CREWCAT);
                
                Dispatch_Vol__c dispatch = new Dispatch_Vol__c(
                    Role__c = role,
                    RecordTypeId = crewMemberRecordTypeId,
                    Manuel__c = false,
                    Is_Passive__c = '1'.equals(crewRoster.ISPASSIVE),
                    TAT__c = flight.TAT__c,
                    Matricule_utilisateur__c = crewRoster.EMPNO 
                );

                if(dispatch.Is_Passive__c == true){
                    dispatch.Cle_dispatch_vol__c = dispatch.Role__c;
                    dispatch.Cle_dispatch_vol__c += DEFAULT_DISPATCH_KEY_SEPARATOR + dispatch.Matricule_utilisateur__c;
                    dispatch.Cle_dispatch_vol__c += DEFAULT_DISPATCH_KEY_SEPARATOR + flightKey;
                }else{
                    dispatch.Cle_dispatch_vol__c = dispatch.Role__c;
                    dispatch.Cle_dispatch_vol__c += DEFAULT_DISPATCH_KEY_SEPARATOR + flightKey;
                }
                
                if (flight.Sens_du_vol__c.equalsIgnoreCase(TAT_StaticConstants.TYPE_TAT_ARRIVEE)) {
                    dispatch.Vol_Arrivee__c = flight.Id;
                    dispatch.Vol_Depart__c = null;
                }
                else if (flight.Sens_du_vol__c.equalsIgnoreCase(TAT_StaticConstants.TYPE_TAT_DEPART)) {
                    dispatch.Vol_Depart__c = flight.Id;
                    dispatch.Vol_Arrivee__c = null;
                }
                dispatchMap.put(dispatch.Cle_dispatch_vol__c, dispatch);
            }
            
            if(!dispatchMap.isEmpty()){
                TAT_RocadeManagement.insertFlightDispatches(dispatchMap, flights);
            }
        }
    }

    private static TAT_CrewBean.FlightCrewInput populateWSInput(List<Integer> flightNumbers, String startDate, String endDate,String userID){
        TAT_CrewBean.FlightCrewInput flightCrewInput = new TAT_CrewBean.FlightCrewInput();
        flightCrewInput.FLTNBR = String.join(flightNumbers, DEFAULT_FLIGHT_NUMBER_SEPARATOR);
        flightCrewInput.USER_ID  = userID;
        flightCrewInput.AIRLINE = DEFAULT_AIRLINE_VALUE;
        flightCrewInput.STARTTIME = startDate + DEFAULT_DATES_SEPARATOR + endDate;
        return flightCrewInput;
    }

    private static String buildFlightKey(TAT_CrewBean.CrewRoster crewRoster){
        return DEFAULT_AIRLINE_VALUE + crewRoster.FLTNBR + crewRoster.DEP + crewRoster.STARTTIME.left(10).replaceAll('-', '');
    }
}
