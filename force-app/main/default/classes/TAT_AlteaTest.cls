/**
 * @author         Salesforce TAT Team
 * @date           Mar 24, 2019
 * @description    Test class for Altea web service
 * @history      
 *
 **/

@isTest
private class TAT_AlteaTest {
	@testSetup 
    static void initTest() {
        User superviseurUser = TAT_TestFactory.createUser(TAT_StaticConstants.Profile_Superviseur, true);
        System.runAs(superviseurUser) {
            Type_Appareil__c typeApp = TAT_TestFactory.createTypeAppareil('MP');
            Appareil__c appareil = TAT_TestFactory.createAppareil('788', typeApp.Id);        
            list<Vol_TAT__c> vols = TAT_TestFactory.createVols(1,'222', 260, 'PAR', appareil.id, true); 
        }
    }
    
    private static testMethod void insertVolTest() {
        // Because this is a test, job executes
        // immediately after Test.stopTest().
        String CRON_EXP = '0 0 0 15 3 ? 2022';
   		Test.startTest();
        Test.setMock(WebServiceMock.class, new TAT_AlteaMockImpl());
        // Schedule the test job
        String jobId = System.schedule('TAT_AlteaTest', CRON_EXP, new TAT_AlteaAllDataSchedule());
        String job4Id = System.schedule('TAT_AlteaTest 4', CRON_EXP, new TAT_AlteaSpecificDataSchedule());
        String job2Id = System.schedule('TAT_AlteaTest 2', CRON_EXP, new TAT_AlteaPrevisionnelSchedule());
        //String job3Id = System.schedule('TAT_AlteaTest 3', CRON_EXP, new TAT_AlteaScheduleNextTwoDays());
        Test.stopTest();
    }
    
    private static testMethod void getPassagerTest() {
        Vol_TAT__c vol = [SELECT Id, Numero_du_vol__c, Jour_du_vol__c, Escale_depart_prevue__c 
                          FROM Vol_TAT__c LIMIT 1];
        Test.startTest();
        Test.setMock(WebServiceMock.class, new TAT_AlteaMockImpl());
        List<TAT_PassagerWrapper> wrap = TAT_MonitoringController.getPassager(vol.Id);
        Test.stopTest();
    }
    
    private static testMethod void getAlteaTest() {
        Vol_TAT__c vol = [SELECT Id, Numero_du_vol__c, Jour_du_vol__c, Escale_depart_prevue__c 
                          FROM Vol_TAT__c LIMIT 1];
        Test.startTest();
        Test.setMock(WebServiceMock.class, new TAT_AlteaMockImpl());
        List<Vol_TAT__c> wrap = TAT_MonitoringController.getAltea(vol.Id, null);
        Test.stopTest();
    }
}