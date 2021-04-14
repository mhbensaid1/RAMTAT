/**
* @author         Salesforce TAT Team
* @date           Jan 21, 2018
* @description    Class for Actions that bypass the sharing model 
* @history        
*/ 

public without sharing class TAT_SpecificActions {
    /** 
    * @description    trigger the dispatch vol deletion when the user clicks on liberer button 
    * @param          tatId : TAT Id
    * @param          tatId : role TAT for the connected role
    * @return         
    */
    public static void libererVolAction(String tatId, String roleUser){
        Set<Id> dispatchIdSet = new Set<Id>();
        List<Dispatch_Vol__c> dispatchList = [SELECT Id FROM Dispatch_Vol__c WHERE TAT__c =:tatId AND Role__c =:roleUser];
        for(Dispatch_Vol__c dispatchVol:dispatchList){
            dispatchIdSet.add(dispatchVol.Id);
        }
        try{        
            delete [SELECT Id,Dispatch_Vol__c FROM Historique_de_tache__c WHERE Dispatch_Vol__c IN:dispatchIdSet];
            delete dispatchList;
            String emailLiberation = TAT_Utils.getAdminSetting().get('Email Libération');
            TAT_Utils.sendEmailTemplate('TAT_Notification_de_liberation_TAT',emailLiberation,'Aya','Ze',tatId);
        }catch(Exception e){throw new AuraHandledException('Libération de TAT échouée '+ e.getMessage());   }
    }
    
    /**
    * @description    Used without sharing to let superisor deleting ressources and materials
    * @param          dispatchVolId : Id Dispatch vol
    * @return         boolean: delete operation success or failed
    */
    public static Boolean deleteRessource(String dispatchVolId){
        try{
            //delete dispatch vol
            String queryDispatchVol = 'SELECT Id FROM Dispatch_Vol__c WHERE Id=:dispatchVolId';
            List<Dispatch_Vol__c> DispatchVols = Database.query(queryDispatchVol);
            delete DispatchVols;
            return true;           
        }catch (Exception e) {throw new AuraHandledException('Something went wrong while getting the deleteRessource function: '+ e.getMessage());    }
    }
	/**
    * @description    delete dispatch vol
    * @param          dispatchList : list dispatch to delete
    * @return        
    */
    public static void deletedispatchVolList(List<Dispatch_Vol__c> dispatchList){
        delete dispatchList;
    }
    
    /**
    * @description    delete TAT 
    * @param          tatList : list empty TAT to delete
    * @return        
    */
    public static void deleteTAT(List<TAT__c> tatList){
        database.delete(tatList,false);
    } 
  
    /**
    * @description    delete dispatch vol
    * @param          dispatchList : list dispatch to delete
    * @return        
    */
    public static void deletedispatchVolList(Set<Id> dispatchIdSet){
        delete [SELECT Id FROM Historique_de_tache__c WHERE Dispatch_Vol__c IN:dispatchIdSet OR Dispatch_Vol_2__c IN:dispatchIdSet OR Dispatch_Vol_3__c IN:dispatchIdSet];
        Database.delete([SELECT Id FROM Dispatch_Vol__c WHERE Id IN:dispatchIdSet],false);
    }
    /**
    * @description    delete HistoriqueTache
    * @param          HistoriqueTacheList : list HistoriqueTache to delete
    * @return        
    */
    public static void deleteHistoriqueTacheList(List<Historique_de_tache__c> historiqueTacheList){
        delete historiqueTacheList;
    }
}