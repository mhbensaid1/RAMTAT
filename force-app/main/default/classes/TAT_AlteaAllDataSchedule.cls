/**
* @author         Salesforce TAT Team
* @date           Feb 27, 2019
* @description    Used to schedule the execution of Altea WS tto get all Vol Data
* @history        
*/
public with sharing class TAT_AlteaAllDataSchedule implements Schedulable {

    public void execute(SchedulableContext context) {
        
        //AllData
        Datetime now = Datetime.now();
        Map<String, String> alteaAllDataSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_ALTEA_All_DATA_SETTINGS);
        Integer deltaPlus = Integer.valueOf(alteaAllDataSettings.get('Altea All Data Where Condition +(min)'));
        Integer deltaMoin = Integer.valueOf(alteaAllDataSettings.get('Altea All Data Where Condition -(min)'));
        Integer batchSize = Integer.valueOf(alteaAllDataSettings.get('Altea All Data Batch Size'));
        Integer scheduleSize = Integer.valueOf(alteaAllDataSettings.get('Altea All Data Frequency'));
        Datetime lastHours = now.addMinutes(-deltaMoin);
        Datetime nextHours = now.addMinutes(+deltaPlus);
        String lastHoursFilter = String.valueOf(lastHours).replace(' ','T') + 'Z';
        String nextHoursFilter = String.valueOf(nextHours).replace(' ','T') + 'Z';
        String query = 'SELECT Id, Numero_du_vol__c, Jour_du_vol__c, Best_Time_Depart__c, Escale_depart_prevue__c ';
        query += 'FROM Vol_TAT__c ';
        query += 'WHERE Compagnie_transporteur__c = \'AT\' AND ((Date_de_depart_prevue__c >= ' + lastHoursFilter + ' AND Date_de_depart_prevue__c <= ' + nextHoursFilter + ') OR (Date_d_arrivee_prevue__c >= ' + lastHoursFilter + ' AND Date_d_arrivee_prevue__c <= ' + nextHoursFilter + ')) ';        
        TAT_AlteaAllDataBatch alteaAllDataBatch = new TAT_AlteaAllDataBatch(query,true,scheduleSize);
        Database.executeBatch(alteaAllDataBatch, batchSize); 
    
    }   
}