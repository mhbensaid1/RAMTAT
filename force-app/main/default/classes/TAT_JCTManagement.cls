/**
* @author         Salesforce TAT Team
* @date           Apr 12, 2021
* @description    Management class responsible of fetching crew members from altea
* @history        
*/
public with sharing class TAT_JCTManagement {
   
    /**
     * @description The method will get the list of the available crew members for a given list of flight numbers in a date period 
     * @param  flightNumbers List of flight numbers (ex : 777) 
     * @param  startDate     Used to limit the interval of the search to dates after the start date
     * @param  endDate       Used to limit the interval of the search to dates before the end date
     * @return               Crew members 
     */ 
    public static TAT_CrewBean.CrewRoster[] getCrewOnBoard(List<Integer> flightNumbers, String startDate, String endDate) {

        
        return null;
    }


    private static TAT_CrewBean.FlightCrewInput populateWSInput(){
        TAT_CrewBean.FlightCrewInput flightCrewInput = new TAT_CrewBean.FlightCrewInput();
        return 
    }
}
