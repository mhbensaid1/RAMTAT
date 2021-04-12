/**
* @author         Salesforce TAT Team
* @date           Feb 27, 2019
* @description    Used to schedule the execution of Altea WS to get specific data
* @history        
*/
public with sharing class TAT_AlteaSpecificDataSchedule  implements Schedulable {
    
    public void execute(SchedulableContext context){
        
        //Specific Data
        Datetime now = Datetime.now();
        Map<String, String> alteaSpecificDataSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_ALTEA_SPECIFIC_DATA_SETTINGS);
        Integer deltaPlus = Integer.valueOf(alteaSpecificDataSettings.get('Altea Spec Data Where Condition +(min)'));
        Integer deltaMoin = Integer.valueOf(alteaSpecificDataSettings.get('Altea Spec Data Where Condition -(min)'));
        Integer batchSize = Integer.valueOf(alteaSpecificDataSettings.get('Altea Specific Data Batch Size'));
        Integer scheduleSize = Integer.valueOf(alteaSpecificDataSettings.get('Altea Specific Data Frequency'));
        Datetime lastHours = now.addMinutes(-deltaMoin);
        Datetime nextHours = now.addMinutes(+deltaPlus);
        String lastHoursFilter = String.valueOf(lastHours).replace(' ','T') + 'Z';
        String nextHoursFilter = String.valueOf(nextHours).replace(' ','T') + 'Z';
        String query = 'SELECT Id, Numero_du_vol__c, Jour_du_vol__c, Best_Time_Depart__c, Escale_depart_prevue__c ';
        query += 'FROM Vol_TAT__c ';
        query += 'WHERE Compagnie_transporteur__c = \'AT\' AND ((Date_de_depart_prevue__c >= ' + lastHoursFilter + ' AND Date_de_depart_prevue__c <= ' + nextHoursFilter + ') OR (Date_d_arrivee_prevue__c >= ' + lastHoursFilter + ' AND Date_d_arrivee_prevue__c <= ' + nextHoursFilter + ')) ';        
        TAT_AlteaSpecificDataBatch alteaSpecificDataBatch = new TAT_AlteaSpecificDataBatch(query,true,scheduleSize);
        Database.executeBatch(alteaSpecificDataBatch, batchSize);       
    }   
}