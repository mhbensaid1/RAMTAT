@isTest
public class TAT_JCLBatchTest {
   
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
    
    @isTest private static void testSuccessfulBatchExecution(){
        String query = 'SELECT Id, TAT__c, TAT__r.Name, Sens_du_vol__c, Numero_du_vol__c, Jour_du_vol__c, Escale_depart_prevue__c, Cle_du_vol__c FROM Vol_TAT__c';        
        String startDate = '20210217';
        String endDate = '20210221';

        Test.startTest();
        Test.setMock(WebServiceMock.class, new TAT_JCLCrewOnBoardMock());

        TAT_JCLBatch batch = new TAT_JCLBatch(query, startDate, endDate, false, 20);
        Database.executeBatch(batch);
        Test.stopTest();

        System.assertEquals(4, [select count() from Dispatch_Vol__c]);
    }

    
}
