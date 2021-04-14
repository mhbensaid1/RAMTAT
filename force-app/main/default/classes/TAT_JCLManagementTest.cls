@isTest
public class TAT_JCLManagementTest {
    @TestSetup
    static void makeData(){
        Type_Appareil__c typeApp = TAT_TestFactory.createTypeAppareil('MP');
        Appareil__c appareil = TAT_TestFactory.createAppareil('788', typeApp.Id);        

        Vol_TAT__c dummyFlight = new Vol_TAT__c(
            Appareil__c = appareil.id,
            Date_de_depart_prevue__c = Datetime.now().addMinutes(260),
            Date_d_arrivee_prevue__c = Datetime.now().addMinutes(260+180),
            Numero_du_vol__c = Decimal.valueOf(740),
            Escale_arrivee_realisee__c = 'PAR',              
            Vol_Ram__c = true,
            Compagnie_transporteur__c = 'AT',
            Jour_du_vol__c=DateTime.now().format('YYYYMMdd'),
            Escale_depart_realisee__c='CMN'
        );
    
        insert dummyFlight;

        TAT_TestFactory.createUsersWithExternalID(TAT_StaticConstants.Profile_Superviseur,5, true);
    }

    @isTest
    private static void testSuccessfulCalloutCall(){
        // given
        List<Integer> flightNumbers = new List<Integer>{740,650,665,8147,408,511,510};
        String startDate = '20210217';
        String endDate = '20210221';
        
        // When
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new TAT_JCLCrewOnBoardMock());
        TAT_CrewBean.CrewRoster[] rosters = TAT_JCLManagement.getCrewOnBoard(flightNumbers, startDate, endDate);        
        
        Test.stopTest();

        // Then
        System.assert(rosters != null);
        System.assert(rosters.size() > 0);
    }

    @isTest
    private static void testSuccessfulDispatchCreation(){
        // given
        Map<String, Vol_TAT__c> flights = new Map<String, Vol_TAT__c>();
        List<Integer> flightNumbers = new List<Integer>();

        List<Vol_TAT__c> scope =  [Select Cle_du_vol__c, numero_du_vol__c, TAT__c, Sens_du_vol__c from Vol_TAT__c];
        for(Vol_TAT__c flight : scope) {
            flights.put(flight.Cle_du_vol__c, flight);
            flightNumbers.add(Integer.valueOf(flight.numero_du_vol__c));
        }
        
        String startDate = '20210217';
        String endDate = '20210221';
        
        // When
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new TAT_JCLCrewOnBoardMock());
        TAT_CrewBean.CrewRoster[] rosters = TAT_JCLManagement.getCrewOnBoard(flightNumbers, startDate, endDate);
        TAT_JCLManagement.updateOnBoardCrews(rosters, flights);
        
        Test.stopTest();
        
        // Then
        List<Dispatch_Vol__c> flightsdispatch = [select Matricule_utilisateur__c from Dispatch_Vol__c];

        System.assert(rosters != null);
        System.assert(rosters.size() > 0);
        System.assert(flightsdispatch.size() > 0);
    }

    @isTest
    private static void shouldIgnoreUnkownRoleTypes(){
        // given
        Map<String, Vol_TAT__c> flights = new Map<String, Vol_TAT__c>();
        List<Integer> flightNumbers = new List<Integer>();

        List<Vol_TAT__c> scope =  [Select Cle_du_vol__c, numero_du_vol__c, TAT__c, Sens_du_vol__c from Vol_TAT__c];
        for(Vol_TAT__c flight : scope) {
            flights.put(flight.Cle_du_vol__c, flight);
            flightNumbers.add(Integer.valueOf(flight.numero_du_vol__c));
        }
        
        String startDate = '20210217';
        String endDate = '20210221';
        
        // When
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new TAT_JCLCrewOnBoardMock());
        TAT_CrewBean.CrewRoster[] rosters = TAT_JCLManagement.getCrewOnBoard(flightNumbers, startDate, endDate);

        for(TAT_CrewBean.CrewRoster roster : rosters){
            roster.CREWCAT = 'UNKNOWN CREW CATEGORY';
        }  

        TAT_JCLManagement.updateOnBoardCrews(rosters, flights);
        
        Test.stopTest();
        
        // Then
        List<Dispatch_Vol__c> flightsdispatch = [select Matricule_utilisateur__c from Dispatch_Vol__c];

        System.assert(rosters != null);
        System.assert(rosters.size() > 0);
        System.assertEquals(0, flightsdispatch.size(), 'No Flight dispatch should be created since the given crew roles are unknown');
    }
   

    @isTest
    private static void shouldIgnoreUnkownFlights(){
        // given
        Map<String, Vol_TAT__c> flights = new Map<String, Vol_TAT__c>();
        List<Integer> flightNumbers = new List<Integer>();

        List<Vol_TAT__c> scope =  [Select Cle_du_vol__c, numero_du_vol__c, TAT__c, Sens_du_vol__c from Vol_TAT__c];
        for(Vol_TAT__c flight : scope) {
            flights.put(flight.Cle_du_vol__c, flight);
            flightNumbers.add(Integer.valueOf(flight.numero_du_vol__c));
        }
        
        String startDate = '20210217';
        String endDate = '20210221';
        
        // When
        Test.startTest();
        
        Test.setMock(WebServiceMock.class, new TAT_JCLCrewOnBoardMock());
        TAT_CrewBean.CrewRoster[] rosters = TAT_JCLManagement.getCrewOnBoard(flightNumbers, startDate, endDate);

        for(TAT_CrewBean.CrewRoster roster : rosters){
            roster.FLTNBR = '99999';
        }  

        TAT_JCLManagement.updateOnBoardCrews(rosters, flights);
        
        Test.stopTest();
        
        // Then
        List<Dispatch_Vol__c> flightsdispatch = [select Matricule_utilisateur__c from Dispatch_Vol__c];

        System.assert(rosters != null);
        System.assert(rosters.size() > 0);
        System.assertEquals(0, flightsdispatch.size(), 'No Flight dispatch should be created since the given flight numbers are unknown');
    }
   
}