/**
 * @author         Salesforce TAT Team
 * @date           Feb 20, 2019
 * @description    Used to schedule the execution of Rocade Service
 * @history
 * 
 **/
public class TAT_RocdePrevisionnelSchedule implements Schedulable {
   
    public void execute(SchedulableContext context) {    
        Datetime now = Datetime.now();
        Map<String, String> tatInterfacesSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_INTERFACES_SETTINGS);
        Integer deltaPlus = Integer.valueOf(tatInterfacesSettings.get('Interfaces Where Condition +(Days)'));
        Integer deltaMoin = Integer.valueOf(tatInterfacesSettings.get('Interfaces Where Condition -(Days)'));
        Integer batchSize = Integer.valueOf(tatInterfacesSettings.get('Interfaces Batch Size'));
        Datetime lastDays = now.addDays(-deltaMoin);
        Datetime nextDays = now.addDays(+deltaPlus);
        String query = 'SELECT Id, TAT__c, TAT__r.Name, Sens_du_vol__c, Numero_du_vol__c, Jour_du_vol__c, Escale_depart_prevue__c, Cle_du_vol__c ';
        query += 'FROM Vol_TAT__c ';
        query += 'WHERE (Date_de_depart_prevue__c = NEXT_N_DAYS:'+deltaPlus+ ' OR Date_de_depart_prevue__c = LAST_N_DAYS:'+deltaMoin+' OR  Date_d_arrivee_prevue__c = NEXT_N_DAYS:'+deltaPlus+' OR Date_d_arrivee_prevue__c = LAST_N_DAYS:'+deltaMoin+')';
        TAT_RocadeBatch rocadeBatch = new TAT_RocadeBatch(query, TAT_Utils.formatDate(lastDays.date()), TAT_Utils.formatDate(nextDays.date()), false,0);
        Database.executeBatch(rocadeBatch, batchSize);
    }
    
}