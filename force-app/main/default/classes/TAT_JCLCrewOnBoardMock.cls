/**
* @author         Salesforce TAT Team
* @date           Apr 13, 2021
* @description    TAT JCL Web service Mock 
* @history      
*
**/
@isTest
global class TAT_JCLCrewOnBoardMock implements WebServiceMock{

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
        
        TAT_CrewService.getCrewOnBoardResponse_element response_x = 
            new TAT_CrewService.getCrewOnBoardResponse_element();

        TAT_CrewBean.CrewRoster[] crewRosters = new  List<TAT_CrewBean.CrewRoster>();
        String currentDate = String.valueOf(Datetime.now());

        TAT_CrewBean.CrewRoster crewRoster1 = new TAT_CrewBean.CrewRoster();
        crewRoster1.CREWCAT = 'OPL';
        crewRoster1.DEP = 'CMN';
        crewRoster1.EMPNO = '0';
        crewRoster1.FLTNBR = '740';
        crewRoster1.ISPASSIVE = '0';
        crewRoster1.STARTTIME = currentDate;
        
        TAT_CrewBean.CrewRoster crewRoster2 = new TAT_CrewBean.CrewRoster();
        crewRoster2.CREWCAT = 'CA';
        crewRoster2.DEP = 'CMN';
        crewRoster2.EMPNO = '1';
        crewRoster2.FLTNBR = '740';
        crewRoster2.ISPASSIVE = '0';
        crewRoster2.STARTTIME = currentDate;
        
        TAT_CrewBean.CrewRoster crewRoster3 = new TAT_CrewBean.CrewRoster();
        crewRoster3.CREWCAT = 'CDB';
        crewRoster3.DEP = 'CMN';
        crewRoster3.EMPNO = '2';
        crewRoster3.FLTNBR = '740';
        crewRoster3.ISPASSIVE = '0';
        crewRoster3.STARTTIME = currentDate;
        
        TAT_CrewBean.CrewRoster crewRoster4 = new TAT_CrewBean.CrewRoster();
        crewRoster4.CREWCAT = 'CC';
        crewRoster4.DEP = 'CMN';
        crewRoster4.EMPNO = '3';
        crewRoster4.FLTNBR = '740';
        crewRoster4.ISPASSIVE = '0';
        crewRoster4.STARTTIME = currentDate;
        
        TAT_CrewBean.CrewRoster crewRoster5 = new TAT_CrewBean.CrewRoster();
        crewRoster5.CREWCAT = 'CDB';
        crewRoster5.DEP = 'CMN';
        crewRoster5.EMPNO = '4';
        crewRoster5.FLTNBR = '740';
        crewRoster5.ISPASSIVE = '1';
        crewRoster5.STARTTIME = currentDate;
        
        crewRosters.add(crewRoster1);
        crewRosters.add(crewRoster2);
        crewRosters.add(crewRoster3);
        crewRosters.add(crewRoster4);
        crewRosters.add(crewRoster5);

        TAT_CrewBean.FlightCrewOutput flightCrewOutput = new TAT_CrewBean.FlightCrewOutput();
        flightCrewOutput.crewRoster = crewRosters;

        response_x.return_x = flightCrewOutput;
        response.put('response_x', response_x); 
    }
}
