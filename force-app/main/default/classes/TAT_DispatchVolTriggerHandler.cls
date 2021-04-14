/**
  * @author         Salesforce TAT Team
  * @date           Dec 25, 2018
  * @description    Contains a context-specific methods that are automatically called when the dispatch trigger is executed
  * @history       
  *
  **/

public with sharing class TAT_DispatchVolTriggerHandler extends TAT_TriggerHandler{

    private List<Dispatch_Vol__c> newRocadeDispatchVolList;
     private List<Dispatch_Vol__c> newDispatchVolForTATList;
    private Id crewMemberRT,tatMemberRT;
    private List<Dispatch_Vol__c> newDispatchVolList;
    private List<Dispatch_Vol__c> oldDispatchVolList;
    private Map<Id, Dispatch_Vol__c> updatedRocadeDispatchVolMap;
    private Map<Id, Dispatch_Vol__c> newDispatchVolMap;
    private Map<Id, Dispatch_Vol__c> oldDispatchVolMap;
    private  User userInterface;
    private Set<Id> tatIds;

    public TAT_DispatchVolTriggerHandler() {
        crewMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
        tatMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER);
        newDispatchVolList = (List<Dispatch_Vol__c>) Trigger.new;
        oldDispatchVolList = (List<Dispatch_Vol__c>) Trigger.old;
        newRocadeDispatchVolList = new List<Dispatch_Vol__c>();
        updatedRocadeDispatchVolMap = new Map<Id, Dispatch_Vol__c>();
        newDispatchVolMap = (Map<Id, Dispatch_Vol__c>) Trigger.newMap;
        oldDispatchVolMap = (Map<Id, Dispatch_Vol__c>) Trigger.oldMap;
        userInterface = [SELECT Id FROM User WHERE IsActive = true and profile.Name =:TAT_StaticConstants.PROFILE_INTERFACE LIMIT 1];
         newDispatchVolForTATList = new List<Dispatch_Vol__c>();
        tatIds = new Set<Id>();
    }
    protected override void beforeInsert(){
        TAT_DispatchVolManagement.fillUserFromMatriculeUtilisateur(newDispatchVolList); 
    }
    protected override void afterInsert(){
        // create historique tache only for active crew members and tat members
       
        for(Dispatch_Vol__c dispatchVol:newDispatchVolList){
            if((dispatchVol.recordTypeId == crewMemberRT && dispatchVol.Is_Passive__c == false)|| (dispatchVol.recordTypeId == tatMemberRT && dispatchVol.Is_Passive__c == false)){
                newRocadeDispatchVolList.add(dispatchVol);
            }
            if(dispatchVol.TAT__c !=null && dispatchVol.User__c  != null ){
                newDispatchVolForTATList.add(dispatchVol);
                tatIds.add(dispatchVol.TAT__c);
            }
        }
        if(!newRocadeDispatchVolList.isEmpty()){
        	TAT_DispatchVolManagement.insertDispatchVol(newRocadeDispatchVolList);
        }
        if(!newDispatchVolForTATList.isEmpty()){
        	TAT_TATManagement.setDispatchUsersonTAT(newDispatchVolForTATList,tatIds);
        }

    }
    
    protected override void beforeUpdate(){
        TAT_DispatchVolManagement.fillUserFromMatriculeUtilisateur(newDispatchVolList); 
    }
    
    protected override void afterUpdate() {
        
        for(Id dispatchVolId:newDispatchVolMap.keySet()){
            if(
                (
                    (newDispatchVolMap.get(dispatchVolId).recordTypeId == crewMemberRT  && newDispatchVolMap.get(dispatchVolId).Is_Passive__c == false)
                    || (newDispatchVolMap.get(dispatchVolId).recordTypeId == tatMemberRT && newDispatchVolMap.get(dispatchVolId).Is_Passive__c == false)
                )
                && newDispatchVolMap.get(dispatchVolId).user__c != oldDispatchVolMap.get(dispatchVolId).user__c
            ){
                updatedRocadeDispatchVolMap.put(dispatchVolId,newDispatchVolMap.get(dispatchVolId));
            }
            if(newDispatchVolMap.get(dispatchVolId).TAT__c !=null && newDispatchVolMap.get(dispatchVolId).user__c != null   && newDispatchVolMap.get(dispatchVolId).user__c != oldDispatchVolMap.get(dispatchVolId).user__c){
                
                 newDispatchVolForTATList.add(newDispatchVolMap.get(dispatchVolId));
                tatIds.add(newDispatchVolMap.get(dispatchVolId).TAT__c);
            }
            
        }
        if(!updatedRocadeDispatchVolMap.isEmpty()){
            TAT_DispatchVolManagement.updateDispatchVol(updatedRocadeDispatchVolMap);
        }
        if(!newDispatchVolForTATList.isEmpty()){
        	TAT_TATManagement.setDispatchUsersonTAT(newDispatchVolForTATList,tatIds);
        }
    }
}