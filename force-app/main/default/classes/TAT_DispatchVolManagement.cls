/**
* @author         Salesforce TAT Team
* @date           Dec 25, 2018
* @description    contains all methods related to dispatch vol object
* @history       
*
**/

public with sharing class TAT_DispatchVolManagement {
    
    public static void insertDispatchVol(List<Dispatch_Vol__c> dispatchVolList){ 
        TAT_TacheManagement.createHistoriqueTaches(dispatchVolList);          
    }
    
    public static void updateDispatchVol(Map<Id, Dispatch_Vol__c> dispatchVolMap){         
        TAT_TacheManagement.updateHistoriqueTachesFromDispatch(dispatchVolMap);          
    }
    
    public static void fillUserFromMatriculeUtilisateur(List<Dispatch_Vol__c> dispatchVolList){
        Map<String,Id> userMap = new Map<String,Id>();
        for(User user:[SELECT Id,Matricule_employe__c FROM User]){
            userMap.put(user.Matricule_employe__c,user.id);
        }
        for(Dispatch_Vol__c dispatch:dispatchVolList){
            if(dispatch.Matricule_utilisateur__c != null){
                dispatch.user__c =  userMap.get(dispatch.Matricule_utilisateur__c);
            }
        }
    }
    
    /**
    * @description      get dispatch vol by TAT Id
    * @param            tatIdSet : Set tat Id
    * @return           TatByDispatchMap : Map of Dispatch by tat Id
    */
    private static Map<Id,List<Dispatch_Vol__c>> getTatByDispatchMap(Set<Id> tatIdSet, Id recTypeId){
        Map<Id,List<Dispatch_Vol__c>> TatByDispatchMap = new Map<Id,List<Dispatch_Vol__c>>();
        List<Dispatch_Vol__c> dispatchVolList;
        if(recTypeId == null){
            dispatchVolList = [SELECT Id,Role__c,TAT__c,RecordTypeId ,Vol_Arrivee__c,Vol_Depart__c,User__c,Vol_Depart__r.TAT__c,Vol_Arrivee__r.TAT__c
                               FROM Dispatch_Vol__c WHERE Tat__c IN:tatIdSet AND Is_Passive__c = false];
        }else{
            dispatchVolList = [SELECT Id,Role__c,TAT__c,Vol_Arrivee__c,RecordTypeId ,Vol_Depart__c,User__c,Vol_Depart__r.TAT__c,Vol_Arrivee__r.TAT__c
                               FROM Dispatch_Vol__c WHERE Tat__c IN:tatIdSet AND recordTypeId =:recTypeId AND Is_Passive__c = false];
        }
        for(Dispatch_Vol__c dispatchVol:dispatchVolList){
            if(!TatByDispatchMap.containsKey(dispatchVol.TAT__c)){
                TatByDispatchMap.put(dispatchVol.TAT__c,new List<Dispatch_Vol__c>());
            }
            TatByDispatchMap.get(dispatchVol.TAT__c).add(dispatchVol);                                  
        } 
        return TatByDispatchMap;
    }
    
    private static Map<String,Id> getVolTATMap(Set<Id> tatIdSet){
        Map<String,Id> volMap = new Map<String,Id>();
        for(Vol_TAT__c vol:[SELECT Id,TAT__c,Sens_du_vol__c FROM Vol_TAT__c WHERE TAT__c IN:tatIdSet]){
            if(vol.Sens_du_vol__c == TAT_StaticConstants.TYPE_TAT_DEPART){
                volMap.put(vol.TAT__c+'_D',vol.Id);
            }else{
                volMap.put(vol.TAT__c+'_A',vol.Id);
            } 
        }
        return volMap;
    }
    
    public static void calculateRetartTAT(List<TAT__c> tatList){
        Set<Id> tatIdSet = new Set<Id>();
        for(TAT__c tat:tatList){
            tatIdSet.add(tat.Id);
        }
        TAT_TATManagement.calculateRetardANDPourcentageFROMTAT(tatIdSet);
    }
    
    public static void duplicateDVTATMember(List<TAT__c> tatList){
        List<Dispatch_Vol__c> dispatchListToUpdateOrInsert = new List<Dispatch_Vol__c>();
        Dispatch_Vol__c newdispatchVol = new Dispatch_Vol__c();
        Set<Id> tatIdSet = new Set<Id>();
        Set<Id> htToDelete = new Set<Id>();
        for(TAT__c tat:tatList){
            tatIdSet.add(tat.id);
        }  
        Map<Id,List<Dispatch_Vol__c>> dispatchVolTATMap = getTatByDispatchMap(tatIdSet,TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER));
        for(TAT__c tat:tatList){
            if(dispatchVolTATMap.get(tat.id) != null){
                for(Dispatch_Vol__c dispatchVol:dispatchVolTATMap.get(tat.id)){
                    if(tat.Type_TAT__c == TAT_StaticConstants.TYPE_TAT_DEPART && dispatchVol.Vol_Depart__c != null){
                        htToDelete.add(dispatchVol.Vol_Arrivee__c);
                        newdispatchVol = new Dispatch_Vol__c(recordTypeId = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER),
                                                             TAT__c = dispatchVol.Vol_Arrivee__r.TAT__c,
                                                             User__c = dispatchVol.User__c,
                                                             Vol_Arrivee__c = dispatchVol.Vol_Arrivee__c,
                                                             Vol_Depart__c = null,
                                                             Role__c = dispatchVol.Role__c);
                        dispatchVol.Vol_Arrivee__c = null;
                        dispatchListToUpdateOrInsert.add(newdispatchVol);
                        dispatchListToUpdateOrInsert.add(dispatchVol); 
                    }    
                    if(tat.Type_TAT__c == TAT_StaticConstants.TYPE_TAT_ARRIVEE && dispatchVol.Vol_Arrivee__c != null){
                        htToDelete.add(dispatchVol.Vol_Depart__c);
                        newdispatchVol = new Dispatch_Vol__c(recordTypeId = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER),
                                                             TAT__c = dispatchVol.Vol_Depart__r.TAT__c,
                                                             User__c = dispatchVol.User__c,
                                                             Vol_Arrivee__c = null,
                                                             Vol_Depart__c = dispatchVol.Vol_Depart__c,
                                                             Role__c = dispatchVol.Role__c);
                        dispatchVol.Vol_Depart__c = null;
                        dispatchListToUpdateOrInsert.add(newdispatchVol);
                        dispatchListToUpdateOrInsert.add(dispatchVol);
                    }
                   
                }
            }
        }
        if(!htToDelete.isEmpty()){
            TAT_SpecificActions.deleteHistoriqueTacheList([SELECT Id FROM Historique_de_tache__c WHERE Vol__c IN:htToDelete AND Dispatch_Vol__c IN:dispatchListToUpdateOrInsert]);
        }
        if(!dispatchListToUpdateOrInsert.isEmpty()){
            database.upsert(dispatchListToUpdateOrInsert, false);
        }
    } 
    
    
    public static void updateDVTATMember(Set<Id> tatIdSet){
        List<Dispatch_Vol__c> dispatchListToUpdateOrInsert = new List<Dispatch_Vol__c>();
        Dispatch_Vol__c newdispatchVol = new Dispatch_Vol__c();
        List<String> volCletList = new List<String>();
        Map<String,Vol_TAT__c> volByCleMap = new Map<String,Vol_TAT__c>();
        for(TAT__c tat:[SELECT Id,Name FROM TAT__C Where Id IN:tatIdSet]){
            volCletList.addAll(tat.Name.split('_'));
        }  
        for(Vol_TAT__c vol:[SELECT Id,Cle_du_vol__c FROM Vol_TAT__c WHERE  Cle_du_vol__c IN :volCletList]){
            volByCleMap.put(vol.Cle_du_vol__c,vol);
        }
        Map<Id,List<Dispatch_Vol__c>> dispatchVolTATMap = getTatByDispatchMap(tatIdSet,TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER));
        for(TAT__c tat:[SELECT Id,Name,Type_TAT__c FROM TAT__C Where Id IN:tatIdSet]){
            for(Dispatch_Vol__c dispatchVol:dispatchVolTATMap.get(tat.Id)){
                if(tat.Type_TAT__c == TAT_StaticConstants.TYPE_TAT_ARRIVEEDEPART){
                    List<String> tatNameList = tat.Name.split('_');
                    dispatchVol.Vol_Arrivee__c = volByCleMap.get(tatNameList[0]).Id;
                    dispatchVol.Vol_Depart__c = volByCleMap.get(tatNameList[1]).Id;
                }    
                dispatchListToUpdateOrInsert.add(dispatchVol);
            } 
        }
        if(!dispatchListToUpdateOrInsert.isEmpty()){
            database.upsert(dispatchListToUpdateOrInsert, false);
        }
    }  

    public static void createDispatchUserFictif(List<TAT__c> tatList){
        User userInterface = [SELECT Id FROM User WHERE profile.Name =:TAT_StaticConstants.PROFILE_INTERFACE LIMIT 1];
        List<Dispatch_Vol__c> dispatchVolToInsert = new List<Dispatch_Vol__c>();
        Map<Id,List<String>> existingRoleByTAT = new Map<Id,List<String>>();
        Map<String,List<Dispatch_Vol__c>> dispatchByRoleTAT = new Map<String,List<Dispatch_Vol__c>>();
        List<String> roleList = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_DISPATCH_RT_FROM_ROLE).get('Dispatch_RT_Role').split(';');
        Set<Id> tatIdSet = new Set<Id>();
        Set<Id> deleteDVSet = new Set<Id>();
        for(TAT__c tat:tatList){
            tatIdSet.add(tat.Id);
        }
        Map<Id,List<Dispatch_Vol__c>> tatByDispatchMap = getTatByDispatchMap(tatIdSet, null);
        Id recordTypeId = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER);
        Map<String,Id> volTATMap = getVolTATMap(tatIdSet);
        for(TAT__c tat:tatList){
            Id tatId = tat.Id;
            if(tatByDispatchMap.get(tatId)!= null){
                for(Dispatch_Vol__c dispatchVol:tatByDispatchMap.get(tatId)){
                    if((dispatchVol.Vol_Arrivee__c == null || dispatchVol.Vol_Depart__c == null) && dispatchVol.recordTypeId == recordTypeId && tat.Name.contains('_')){
                        deleteDVSet.add(dispatchVol.Id);
                    }else{
                        if(!existingRoleByTAT.containsKey(tatId)){
                            existingRoleByTAT.put(tatId,new List<String>());
                        }
                        existingRoleByTAT.get(tatId).add(dispatchVol.Role__c);
                        
                        if(!dispatchByRoleTAT.containsKey(tatId+'_'+dispatchVol.Role__c)){
                            dispatchByRoleTAT.put(tatId+'_'+dispatchVol.Role__c,new List<Dispatch_Vol__c>());
                        }
                        dispatchByRoleTAT.get(tatId+'_'+dispatchVol.Role__c).add(dispatchVol);
                    }
                }
            }
        }
        for(TAT__c tat:tatList){
            Id tatId = tat.Id;
            for(String role:roleList){
                String recordType;
                Id flightOneId = volTATMap.get(tatId+'_A');
                Id flightTwoId = volTATMap.get(tatId+'_D');
                if(role == 'Superviseur' || role == 'MCC' || role == 'Catering'){
                    recordType = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER);
                    if((existingRoleByTAT.get(tatId) != null && !existingRoleByTAT.get(tatId).contains(role)) || existingRoleByTAT.get(tatId) == null){
                        Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(recordTypeId = recordType,
                                                                          TAT__c = (Id)tatId,
                                                                          User__c = userInterface.Id,
                                                                          Vol_Arrivee__c = flightOneId,
                                                                          Vol_Depart__c = flightTwoId,
                                                                          Role__c = role,
                                                                          Manuel__c = false);
                        dispatchVolToInsert.add(dispatchVol);
                    }
                }else{
                    recordType = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
                    if(existingRoleByTAT.get(tatId) != null && existingRoleByTAT.get(tatId).contains(role) && tat.Name.contains('_')){
                        if(dispatchByRoleTAT.get(tatId+'_'+role).size() == 1){
                            if(dispatchByRoleTAT.get(tatId+'_'+role)[0].Vol_Depart__c != null){
                                Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(recordTypeId = recordType,TAT__c = (Id)tatId,User__c = userInterface.Id,
                                                                                  Vol_Arrivee__c = flightOneId, Role__c = role,Manuel__c = false);
                                dispatchVolToInsert.add(dispatchVol);
                            }
                            if(dispatchByRoleTAT.get(tatId+'_'+role)[0].Vol_Arrivee__c != null){
                                
                                Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(recordTypeId = recordType,TAT__c = (Id)tatId,User__c = userInterface.Id,
                                                                                  Vol_Depart__c = flightTwoId, Role__c = role,Manuel__c = false);
                                dispatchVolToInsert.add(dispatchVol);
                            }
                        }
                    }else if((existingRoleByTAT.get(tatId) != null && !existingRoleByTAT.get(tatId).contains(role)) || existingRoleByTAT.get(tatId) == null){
                        if(flightOneId != null){
                            Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(recordTypeId = recordType,TAT__c = (Id)tatId,User__c = userInterface.Id,
                                                                              Vol_Arrivee__c = flightOneId, Role__c = role,Manuel__c = false);
                            dispatchVolToInsert.add(dispatchVol);
                        }
                        if(flightTwoId != null){
                            Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(recordTypeId = recordType,TAT__c = (Id)tatId,User__c = userInterface.Id,
                                                                              Vol_Depart__c = flightTwoId, Role__c = role,Manuel__c = false);
                            dispatchVolToInsert.add(dispatchVol);
                        }
                    }
                    
                } 
            }
        }
        if(!deleteDVSet.isEmpty()){
            TAT_SpecificActions.deletedispatchVolList(deleteDVSet);
        }
        if(!dispatchVolToInsert.isEmpty()){
            database.insert(dispatchVolToInsert,false);
        }
    } 
    
    public static void updateTATForDispatchVol(Set<Id> updateDispatchVolSet){ 
        List<Dispatch_Vol__c> dispatchVolToUpdate = new List<Dispatch_Vol__c>();
        For(Dispatch_Vol__c dispatchVol:[SELECT Id,TAT__c,Vol_Depart__c,Vol_Depart__r.TAT__c,TAT__r.Name,Vol_Arrivee__c,Vol_Arrivee__r.TAT__c,Vol_Depart__r.Etat_du_vol__c,Vol_Arrivee__r.Etat_du_vol__c  
                                         FROM Dispatch_Vol__c WHERE TAT__r.Avancement_TAT__c != 100 
                                         AND (Vol_Arrivee__c IN:updateDispatchVolSet OR Vol_Depart__c IN:updateDispatchVolSet OR TAT__c IN:updateDispatchVolSet)
                                        ]){
                                            if(dispatchVol.Vol_Arrivee__c == null && dispatchVol.Vol_Depart__c != null && dispatchVol.Vol_Depart__r.TAT__c != dispatchVol.TAT__c){
                                                dispatchVol.TAT__c = dispatchVol.Vol_Depart__r.TAT__c;
                                                dispatchVolToUpdate.add(dispatchVol);
                                            }
                                            if(dispatchVol.Vol_Depart__c == null && dispatchVol.Vol_Arrivee__c != null && dispatchVol.Vol_Arrivee__r.TAT__c != dispatchVol.TAT__c){
                                                dispatchVol.TAT__c = dispatchVol.Vol_Arrivee__r.TAT__c;
                                                dispatchVolToUpdate.add(dispatchVol);
                                            }
                                            if(dispatchVol.Vol_Depart__c != null && dispatchVol.Vol_Arrivee__c != null && (dispatchVol.Vol_Depart__r.Etat_du_vol__c == 'CNL' || dispatchVol.Vol_Arrivee__r.Etat_du_vol__c == 'CNL')){
                                                if(dispatchVol.Vol_Depart__r.Etat_du_vol__c != 'CNL'){
                                                    dispatchVol.Vol_Arrivee__c = null;
                                                    dispatchVol.TAT__c = dispatchVol.Vol_Depart__r.TAT__c;
                                                }else{
                                                    dispatchVol.TAT__c = dispatchVol.Vol_Arrivee__r.TAT__c;
                                                    dispatchVol.Vol_Depart__c = null;
                                                }
                                                dispatchVolToUpdate.add(dispatchVol);
                                            }
                                        }
        if(!dispatchVolToUpdate.isEmpty()){
            database.update(dispatchVolToUpdate,false);
        }
    }
    
    
    public static void mergeDVTATMember(Set<Id> tatIds){ 
        Id tatMemberRT = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c',TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_TATMEMBER);
        Map<String,id> mapTAT = new Map<String,id>();
        Set<Id> deleteDV = new Set<Id>();
        Set<Id> htToDelete = new Set<Id>();
        List<Historique_de_tache__c> updateHT = new List<Historique_de_tache__c>();
        Map<Id,List<Historique_de_tache__c>> mapHT = new Map<Id,List<Historique_de_tache__c>>();
        List<Dispatch_Vol__c> dispatchVolToUpdate = new List<Dispatch_Vol__c>();
        for(Vol_TAT__c vol:[SELECT Id,Appareil__c,TAT__c,Sens_du_vol__c FROM Vol_TAT__c WHERE TAT__c IN:tatIds]){
            mapTAT.put(vol.TAT__c+'_'+vol.Sens_du_vol__c,vol.Id);
        }       
        for(Historique_de_tache__c ht:[SELECT Id,vol__c,Dispatch_Vol__c,Dispatch_Vol__r.role__c FROM Historique_de_tache__c WHERE vol__r.TAT__c IN:tatIds]){
            if(!mapHT.containsKey(ht.vol__c)){
                mapHT.put(ht.vol__c,new List<Historique_de_tache__c>());
            }
            mapHT.get(ht.vol__c).add(ht);
        }
        for(Dispatch_Vol__c dispatchVol:[SELECT Id,TAT__c,role__c,Vol_Depart__c,TAT__r.Name,Vol_Depart__r.TAT__c,Vol_Arrivee__c,Vol_Arrivee__r.TAT__c,Vol_Depart__r.Etat_du_vol__c,Vol_Arrivee__r.Etat_du_vol__c  
                                         FROM Dispatch_Vol__c WHERE TAT__c IN:tatIds AND recordTypeId =: tatMemberRT]){
                                             if(dispatchVol.Vol_Depart__c == null && dispatchVol.TAT__r.Name.contains('_')){
                                                 dispatchVol.Vol_Depart__c = mapTAT.get(dispatchVol.TAT__c+'_'+TAT_StaticConstants.TYPE_TAT_DEPART);
                                                 dispatchVolToUpdate.add(dispatchVol);
                                             }
                                             if(dispatchVol.Vol_Depart__c != null && dispatchVol.Vol_Depart__c != null && !dispatchVol.TAT__r.Name.contains('_')){
                                                 if(mapTAT.get(dispatchVol.TAT__c+'_'+TAT_StaticConstants.TYPE_TAT_ARRIVEE) != NULL){
                                                 	dispatchVol.Vol_Arrivee__c = mapTAT.get(dispatchVol.TAT__c+'_'+TAT_StaticConstants.TYPE_TAT_ARRIVEE);
                                                 }else{
                                                    htToDelete.add(dispatchVol.Vol_Arrivee__c);
                                                    dispatchVol.Vol_Arrivee__c = null; 
                                                 }
                                                 if(mapTAT.get(dispatchVol.TAT__c+'_'+TAT_StaticConstants.TYPE_TAT_DEPART) != NULL){
                                                 	dispatchVol.Vol_Depart__c = mapTAT.get(dispatchVol.TAT__c+'_'+TAT_StaticConstants.TYPE_TAT_DEPART);
                                                 }else{
                                                    htToDelete.add(dispatchVol.Vol_Depart__c);
                                                    dispatchVol.Vol_Depart__c = null;  
                                                 }
                                                 dispatchVolToUpdate.add(dispatchVol);
                                             }
                                         }
        for(Dispatch_Vol__c dv:dispatchVolToUpdate){
            for(Historique_de_tache__c ht:mapHT.get(dv.Vol_Depart__c)){
                if(ht.Dispatch_Vol__r.role__c == dv.role__c){
                    deleteDV.add(ht.Dispatch_Vol__c);
                    ht.Dispatch_Vol__c = dv.Id;
                    updateHT.add(ht);
                }
            }
        }
        if(!dispatchVolToUpdate.isEmpty()){
            database.update(dispatchVolToUpdate,false);
        }
        if(!updateHT.isEmpty()){
            database.update(updateHT,false);
        }
        if(!deleteDV.isEmpty()){
            // remove duplicate MCC dispatch vol with no task 
            for(Dispatch_Vol__c dv:[SELECT Id from Dispatch_Vol__c WHERE role__c = 'MCC' AND Vol_Arrivee__c = null AND TAT__c IN:tatIds]){
            	deleteDV.add(dv.Id);   
            }
            TAT_SpecificActions.deletedispatchVolList(deleteDV);
        }
        if(!htToDelete.isEmpty()){
            TAT_SpecificActions.deleteHistoriqueTacheList([SELECT Id FROM Historique_de_tache__c WHERE Vol__c IN:htToDelete AND Dispatch_Vol__c IN:dispatchVolToUpdate]);
        }
    }
}