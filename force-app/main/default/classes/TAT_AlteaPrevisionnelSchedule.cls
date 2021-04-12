/**
* @author         Salesforce TAT Team
* @date           Jun 24, 2019
* @description    Used to schedule the execution of Altea WS
* @history          
*/
public class TAT_AlteaPrevisionnelSchedule implements Schedulable { 
      
    public void execute(SchedulableContext context) {
        
        Datetime now = Datetime.now();
        
        //Altea Interface
        Map<String, String> tatInterfacesSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_INTERFACES_SETTINGS);
        Integer deltaPlus = Integer.valueOf(tatInterfacesSettings.get('Interfaces Where Condition +(Days)'));
        Integer deltaMoin = Integer.valueOf(tatInterfacesSettings.get('Interfaces Where Condition -(Days)'));
        Integer batchSize = Integer.valueOf(tatInterfacesSettings.get('Interfaces Batch Size'));
        String query = 'SELECT Id, Numero_du_vol__c, Jour_du_vol__c, Best_Time_Depart__c, Escale_depart_prevue__c ';
        query += 'FROM Vol_TAT__c ';
        query += 'WHERE Compagnie_transporteur__c = \'AT\' AND (Date_de_depart_prevue__c = NEXT_N_DAYS:'+deltaPlus+ ' OR Date_de_depart_prevue__c = LAST_N_DAYS:'+deltaMoin+' OR  Date_d_arrivee_prevue__c = NEXT_N_DAYS:'+deltaPlus+' OR Date_d_arrivee_prevue__c = LAST_N_DAYS:'+deltaMoin+')';
        TAT_AlteaAllDataBatch alteaAllDataBatch = new TAT_AlteaAllDataBatch(query,false,0);
        Database.executeBatch(alteaAllDataBatch, batchSize); 
        
    }   
}