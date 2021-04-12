/**
* @author         Salesforce TAT Team
* @date           Feb 27, 2019
* @description    A batch used to call Altea Service
* @history
*
**/
public with sharing class TAT_AlteaSpecificDataBatch implements Database.Batchable<sObject> {
    
    public final String query;
    public final Boolean autoReschedule;
    public final Integer scheduleSize;

    public TAT_AlteaSpecificDataBatch(String query,Boolean autoReschedule, Integer scheduleSize) {
        this.query = query;
        this.autoReschedule = autoReschedule;
        this.scheduleSize = scheduleSize;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope) {
        System.enqueueJob(new TAT_AlteaCMService.updateFlight((List<Vol_TAT__c>)scope, new List<Vol_TAT__c>(), 4, 0, 0));
    }
    
    public void finish(Database.BatchableContext BC) {
        if (!autoReschedule) {
            return;
        }
        for (CronTrigger job : [
            SELECT  Id
            FROM    CronTrigger
            WHERE   CronJobDetail.Name = 'Altea Specific Data JOB'
        ]) {
            System.abortJob(job.Id);
        }
        
        TAT_AlteaSpecificDataSchedule schedule = new TAT_AlteaSpecificDataSchedule();
        DateTime runTime = Datetime.now().addMinutes(scheduleSize);
        String cronString = '' + runTime.second() + ' ' + runTime.minute() + ' ' + runTime.hour() + ' ';
        cronString += runTime.day() + ' ' + runTime.month() + ' ? ' + runTime.year();
        System.schedule('Altea Specific Data JOB', cronString, schedule);
    }
}