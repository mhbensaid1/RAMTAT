/**
 * @author         Salesforce TAT Team
 * @date           Mar 24, 2019
 * @description    Test class for Rocade web service
 * @history      
 *
 **/
@isTest
private class TAT_RocadeTest {
	@testSetup 
    static void initTest() {
        User superviseurUser = TAT_TestFactory.createUser(TAT_StaticConstants.Profile_Superviseur, true);
        System.runAs(superviseurUser) {
            Id tatMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER);
            Id crewMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
            Type_Appareil__c typeApp = TAT_TestFactory.createTypeAppareil('MP');
            Appareil__c appareil = TAT_TestFactory.createAppareil('788', typeApp.Id);        
            list<Vol_TAT__c> vols = TAT_TestFactory.createVols(1,'222', 260, 'CMN', appareil.id, true); 
            Vol_TAT__c currentVol = [SELECT Id,Sens_du_vol__c,TAT__c FROM Vol_TAT__c limit 1]; 
            Dispatch_Vol__c dispatchSuperviseur = TAT_TestFactory.createDispatchVol(tatMemberRT, currentVol.TAT__c,currentVol,superviseurUser,'Superviseur', true);
			Dispatch_Vol__c dispatchPassiveANDManuel = TAT_TestFactory.createPassiveANDManualDispatchVol(tatMemberRT, currentVol.TAT__c,currentVol,superviseurUser,'Superviseur',true ,true); 
        	Dispatch_Vol__c dispatchCDB = TAT_TestFactory.createDispatchVol(crewMemberRT, currentVol.TAT__c,currentVol,superviseurUser,'CDB', true);
        }
    }  
    
    @isTest static void testRocadeCallout() {
        // Because this is a test, job executes
        // immediately after Test.stopTest().
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new TAT_RocadeHttpCalloutMock());
   		Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('TAT_RocadeTest', CRON_EXP, new TAT_RocadeSchedule());
        String job2Id = System.schedule('TAT_RocadeTest 2', CRON_EXP, new TAT_RocdePrevisionnelSchedule ());
        //String job3Id = System.schedule('TAT_RocadeTest 3', CRON_EXP, new TAT_RocadeScheduleNextTwoDays());
        Test.stopTest();
    }
    
    @isTest static void testRocadeLoginCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new TAT_RocadeLoginHttpCalloutMock());
   		Test.startTest();
        System.enqueueJob(new TAT_RocadeService.Login(new Map<String, Vol_TAT__c>(), '', ''));
        Test.stopTest();
    }
        
	
}