/**
 * @author          Salesforce TAT Team
 * @since           Jan 25, 2019
 * @description     The test class of the vol trigger component
 */

@isTest
private class TAT_DispatchVolTriggerHandlerTest {

    @testSetup
    static void initTest() {
        Id crewMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
        Id tatMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER);
        User superviseurUser = TAT_TestFactory.createUser(TAT_StaticConstants.Profile_Superviseur, true);
        User pcEscaleUser = TAT_TestFactory.createUser(TAT_StaticConstants.Profile_PC_Escale, true);
        Type_Appareil__c typeApp = TAT_TestFactory.createTypeAppareil('MP');
        Appareil__c appareil = TAT_TestFactory.createAppareil('788', typeApp.Id);     
        list<Vol_TAT__c> vols = TAT_TestFactory.createVols(1, '777',30,'CMN', appareil.id, true);  
        list<Tache__c> taches = TAT_TestFactory.createTaches(3, false, false, true, true);
        List<Standard_des_taches__c> standartTacheListToInsert = new List<Standard_des_taches__c>();
        list<Role_de_tache__c> roleTachesList = new list<Role_de_tache__c>();
        for(Tache__c tache:taches){
            list<Standard_des_taches__c> standardTaches = TAT_TestFactory.createStandardTaches(5, tache.Id,TAT_StaticConstants.TYPE_TAT_ARRIVEE,'MP','BTA', false);
            Role_de_tache__c roleTacheCDB = TAT_TestFactory.createRoleTache(tache.Id,'CDB', false);
            Role_de_tache__c roleTacheOPL = TAT_TestFactory.createRoleTache(tache.Id,'OPL', false);
            standartTacheListToInsert.addAll(standardTaches);
            roleTachesList.add(roleTacheCDB); 
            roleTachesList.add(roleTacheOPL); 
        }
        insert standartTacheListToInsert; 
        insert roleTachesList;         
    }
    
    private static testMethod void insertDispatchVolTest() {
        Id crewMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
        // test start
        Test.startTest();
        Vol_TAT__c vol = [SELECT Id,TAT__c FROM Vol_TAT__c LIMIT 1];
        User user1 = [SELECT Id FROM User WHERE Profile.Name =:TAT_StaticConstants.Profile_Superviseur LIMIT 1];
        Dispatch_Vol__c dispatch = TAT_TestFactory.createDispatchVol(crewMemberRT, vol.TAT__c,vol,user1,'CDB', true);
        Test.stopTest();
        
        // test verification
        System.assertNotEquals([SELECT Id FROM Historique_de_tache__c WHERE Dispatch_Vol__c =:dispatch.Id], null);
    }

    private static testMethod void updateDispatchVolTest() {
       Id crewMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
        Vol_TAT__c vol = [SELECT Id,TAT__c FROM Vol_TAT__c LIMIT 1];
        User user1 = [SELECT Id FROM User WHERE Profile.Name =:TAT_StaticConstants.Profile_Superviseur LIMIT 1];
        User user2 = [SELECT Id FROM User WHERE Profile.Name =:TAT_StaticConstants.Profile_PC_Escale LIMIT 1];
        Dispatch_Vol__c dispatch = TAT_TestFactory.createDispatchVol(crewMemberRT, vol.TAT__c,vol,user1,'CDB', true);
        Historique_de_tache__c task = [SELECT Id,Statut__c FROM Historique_de_tache__c LIMIT 1];
        task.Statut__c = TAT_StaticConstants.HISTORIQUE_TACHE_STATUS_TERMINEE;
        update task;
        dispatch.User__c = user2.id;
        // test start
        Test.startTest();
        update dispatch;
        Test.stopTest();
        
        // test verification
        System.assertNotEquals([SELECT Id FROM Historique_de_tache__c WHERE ownerId =:user2.Id], null);
        // test verification
        System.assertEquals([SELECT Id FROM Historique_de_tache__c WHERE ownerId =:user1.Id].size(), 1);
    }
    
    private static testMethod void tachePartageeTest() {
        Id crewMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
        Vol_TAT__c vol = [SELECT Id,TAT__c FROM Vol_TAT__c LIMIT 1];
        User user1 = [SELECT Id FROM User WHERE Profile.Name =:TAT_StaticConstants.Profile_Superviseur LIMIT 1];
        User user2 = [SELECT Id FROM User WHERE Profile.Name =:TAT_StaticConstants.Profile_PC_Escale LIMIT 1];
        Dispatch_Vol__c dispatchCDB = TAT_TestFactory.createDispatchVol(crewMemberRT, vol.TAT__c,vol,user1,'CDB', true);
        Dispatch_Vol__c dispatchOPL = TAT_TestFactory.createDispatchVol(crewMemberRT, vol.TAT__c,vol,user2,'OPL', false);

        // test start
        Test.startTest();
        insert dispatchOPL;
        Test.stopTest();
        Historique_de_tache__c task = [SELECT Id,Responsable_Tache_2__c FROM Historique_de_tache__c LIMIT 1];
        // test verification
        System.assertEquals(task.Responsable_Tache_2__c,user2.Id);
    }
   
}