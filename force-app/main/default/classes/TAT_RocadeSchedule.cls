/**
 * @author         Salesforce TAT Team
 * @date           Feb 20, 2019
 * @description    Used to schedule the execution of Rocade Service
 * @history
 * 
 **/
public class TAT_RocadeSchedule implements Schedulable {
 
    public void execute(SchedulableContext context) {  
        Datetime now = Datetime.now();
        Map<String, String> rocadeSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_ROCADE_SETTINGS);
        Integer delta = Integer.valueOf(rocadeSettings.get('Rocade Where Condition'));
        Integer batchSize = Integer.valueOf(rocadeSettings.get('Rocade Batch Size'));
        Integer scheduleSize = Integer.valueOf(rocadeSettings.get('Rocade Frequency'));
        Datetime lastHours = now.addHours(-delta);
        Datetime nextHours = now.addHours(+delta);
        String lastHoursFilter = String.valueOf(lastHours).replace(' ','T') + 'Z';
        String nextHoursFilter = String.valueOf(nextHours).replace(' ','T') + 'Z';
        String query = 'SELECT Id, TAT__c, TAT__r.Name, Sens_du_vol__c, Numero_du_vol__c, Jour_du_vol__c, Escale_depart_prevue__c, Cle_du_vol__c ';
        query += 'FROM Vol_TAT__c ';
        query += 'WHERE (Date_de_depart_prevue__c >= ' + lastHoursFilter + ' AND Date_de_depart_prevue__c <= ' + nextHoursFilter + ') OR (Date_d_arrivee_prevue__c >= ' + lastHoursFilter + ' AND Date_d_arrivee_prevue__c <= ' + nextHoursFilter + ') ';
         TAT_RocadeBatch rocadeBatch = new TAT_RocadeBatch(query, TAT_Utils.formatDate(lastHours.date()), TAT_Utils.formatDate(nextHours.date()), true, scheduleSize);
  Database.executeBatch(rocadeBatch, batchSize);
    }
    
}