/**
* @author         Salesforce TAT Team
* @date           Apr 13, 2021
* @description    Schedule responsible of fetching crew members from JCL
* @history        
*/
public class TAT_JCLSchedule implements Schedulable{
    
    public void execute(SchedulableContext context) {  
        Datetime now = Datetime.now();
        Map<String, String> jclSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_JCL_SETTINGS);
        Integer delta = Integer.valueOf(jclSettings.get('JCL Where Condition'));
        Integer batchSize = Integer.valueOf(jclSettings.get('JCL Batch Size'));
        Integer scheduleSize = Integer.valueOf(jclSettings.get('JCL Frequency'));
        
        Datetime lastHours = now.addHours(-delta);
        Datetime nextHours = now.addHours(+delta);
        String lastHoursFilter = String.valueOf(lastHours).replace(' ','T') + 'Z';
        String nextHoursFilter = String.valueOf(nextHours).replace(' ','T') + 'Z';
        String query = 'SELECT Id, TAT__c, TAT__r.Name, Sens_du_vol__c, Numero_du_vol__c, Jour_du_vol__c, Escale_depart_prevue__c, Cle_du_vol__c ';
        query += 'FROM Vol_TAT__c ';
        query += 'WHERE (Date_de_depart_prevue__c >= ' + lastHoursFilter + ' AND Date_de_depart_prevue__c <= ' + nextHoursFilter + ') OR (Date_d_arrivee_prevue__c >= ' + lastHoursFilter + ' AND Date_d_arrivee_prevue__c <= ' + nextHoursFilter + ') ';
        
        TAT_JCLBatch rocadeBatch = new TAT_JCLBatch(query, TAT_Utils.formatDate(lastHours.date()), TAT_Utils.formatDate(nextHours.date()), true, scheduleSize);
        Database.executeBatch(rocadeBatch, batchSize);
    }
    
}
