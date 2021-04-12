/**
 * @author         Salesforce TAT Team
 * @date           Jan 28, 2019
 * @description    Used for Rocade Webservice Calls
 * @history
 *
 **/

public class TAT_RocadeManagement {
    
    public static Boolean parseLoginResponse(String loginResponseBody) {
        String responseValue = loginResponseBody.substringBetween(
            '<Login_x0028_UserId_x002C__x0020_password_x0029_Result>', 
            '</Login_x0028_UserId_x002C__x0020_password_x0029_Result>'
        );
        return Boolean.valueOf(responseValue);        
    }
    
    public static void parseGetCrewResponse(String crewResponseBody, Map<String, Vol_TAT__c> flightsMap) {
        Map<String, Dispatch_Vol__c> dispatchMap = new Map<String, Dispatch_Vol__c>();
        Dispatch_Vol__c dispatch;
        Vol_TAT__c flight;
        String flightKey;
        
        Map<String, String> roleMap = TAT_Utils.getAppSetting('Rocade Role Mapping');
        Id crewMemberRecordTypeId = TAT_Utils.getRecordTypeByDevName('Dispatch_Vol__c', TAT_StaticConstants.DISPATCH_VOL_RECORD_TYPE_CREWMEMBER);
        
        String responseValue = crewResponseBody.substringBetween(
            '<NewDataSet xmlns="http://tempuri.org/NDSRosterData.xsd">',
            '</NewDataSet>'
        );
        if(responseValue != null){
            responseValue = '<NewDataSet>' + responseValue.replaceAll('diffgr:id', 'id');
            responseValue = responseValue.replaceAll('msdata:rowOrder', 'rowOrder') + '</NewDataSet>';
            XmlStreamReader reader = new XmlStreamReader(responseValue);
            while (reader.hasNext()) {
                if (reader.getEventType() == XmlTag.START_ELEMENT) {
                    if (reader.getLocalName() == 'Layout') {
                        dispatch = new Dispatch_Vol__c();
                        flightKey = 'AT';
                    }
                    else if (reader.getLocalName() == 'EMPNO') {
                        reader.next();
                        dispatch.Matricule_utilisateur__c = reader.getText();
                    }
                    else if (reader.getLocalName() == 'CREWCAT') {
                        reader.next();
                        dispatch.Role__c = reader.getText();
                    }
                    else if (reader.getLocalName() == 'ISPASSIVE') {
                        reader.next();
                        dispatch.Is_Passive__c = (reader.getText()=='1');
                    }
                    else if (reader.getLocalName() == 'FLTNBR') {
                        reader.next();
                        flightKey += reader.getText();//.leftPad(4, '0');
                    }
                    else if (reader.getLocalName() == 'DEP') {
                        reader.next();
                        flightKey += reader.getText();
                    }
                    else if (reader.getLocalName() == 'STARTTIME') {
                        reader.next();
                        flightKey += reader.getText().left(10).replaceAll('-', '');
                    }
                }
                else if (reader.getEventType() == XmlTag.END_ELEMENT) {
                    if (reader.getLocalName() == 'Layout') {
                        if (flightsMap.containsKey(flightKey)) { 
                            flight = flightsMap.get(flightKey);
                        }
                        else {
                            reader.next();
                            continue;
                        }
                        if (roleMap.containsKey(dispatch.Role__c)) {
                            dispatch.Role__c = roleMap.get(dispatch.Role__c);
                            dispatch.RecordTypeId = crewMemberRecordTypeId;
                            dispatch.Manuel__c = false;
                            dispatch.TAT__c = flight.TAT__c;
                            if(dispatch.Is_Passive__c == true){
                                dispatch.Cle_dispatch_vol__c = dispatch.Role__c;
                                dispatch.Cle_dispatch_vol__c += '_' + dispatch.Matricule_utilisateur__c;
                                dispatch.Cle_dispatch_vol__c += '_' + flight.Cle_du_vol__c;
                            }else{
                                dispatch.Cle_dispatch_vol__c = dispatch.Role__c;
                                dispatch.Cle_dispatch_vol__c += '_' + flight.Cle_du_vol__c;
                            }
                            if (flight.Sens_du_vol__c.equalsIgnoreCase(TAT_StaticConstants.TYPE_TAT_ARRIVEE)) {
                                dispatch.Vol_Arrivee__c = flight.Id;
                                dispatch.Vol_Depart__c = null;
                            }
                            else if (flight.Sens_du_vol__c.equalsIgnoreCase(TAT_StaticConstants.TYPE_TAT_DEPART)) {
                                dispatch.Vol_Depart__c = flight.Id;
                                dispatch.Vol_Arrivee__c = null;
                            }
                            dispatchMap.put(dispatch.Cle_dispatch_vol__c, dispatch);
                        }
                    }
                }
                reader.next();
            }
        }
        insertFlightDispatches(dispatchMap, flightsMap);
    }
    
    public static Boolean isConnectionAlive(String crewResponseBody) {
        String responseValue = crewResponseBody.substringBetween('<MSGTEXT>', '</MSGTEXT>');
        if(String.isNotBlank(responseValue) && responseValue.equalsIgnoreCase('No active connection. Login again.')){
            return false;
        }
        return true;
    }
    
    public static void insertFlightDispatches(Map<String, Dispatch_Vol__c> dispatchMap, Map<String, Vol_TAT__c> flightsMap) {
        User userInterface = [SELECT Id FROM User WHERE profile.Name =:TAT_StaticConstants.PROFILE_INTERFACE LIMIT 1];
        List<Dispatch_Vol__c> manualDispatches = [
            SELECT  Id, Cle_dispatch_vol__c
            FROM    Dispatch_Vol__c
            WHERE   Manuel__c = true AND User__c != :userInterface.Id
            AND     (Vol_Arrivee__r.Cle_du_vol__c IN :flightsMap.keySet() 
            OR      Vol_Depart__r.Cle_du_vol__c IN :flightsMap.keySet())
        ];

        List<Dispatch_Vol__c> isPassiveDispatches = [
            SELECT  Id, Cle_dispatch_vol__c
            FROM    Dispatch_Vol__c
            WHERE   Is_Passive__c = true 
            AND     (Vol_Arrivee__r.Cle_du_vol__c IN :flightsMap.keySet() 
            OR      Vol_Depart__r.Cle_du_vol__c IN :flightsMap.keySet())
        ];
        if(!isPassiveDispatches.isEmpty()){
            TAT_SpecificActions.deletedispatchVolList(isPassiveDispatches);
        }        
        for (Dispatch_Vol__c manualDispatch : manualDispatches) {
            dispatchMap.remove(manualDispatch.Cle_dispatch_vol__c);
        }        
        if (!dispatchMap.isEmpty()) {
            Database.upsert(dispatchMap.values(), Dispatch_Vol__c.Fields.Cle_dispatch_vol__c, false);
        }
    }
    
}