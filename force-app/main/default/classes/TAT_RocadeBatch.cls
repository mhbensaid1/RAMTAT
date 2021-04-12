/**
 * @author         Salesforce TAT Team
 * @date           Feb 20, 2019
 * @description    A batch used to call Rocade Service
 * @history
 *
 **/
public class TAT_RocadeBatch implements Database.Batchable<sObject> {
    public final String query;
    public final String startDate;
    public final String endDate;
    public final Boolean autoReschedule;
    public final Integer scheduleSize;
    
    
    public TAT_RocadeBatch(String query, String startDate, String endDate, Boolean autoReschedule, Integer scheduleSize) {
        this.query = query;
        this.startDate = startDate;
        this.endDate = endDate;
        this.autoReschedule = autoReschedule;
        this.scheduleSize = scheduleSize;
    }
    
	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
   	}

   	public void execute(Database.BatchableContext BC, List<sObject> scope) {
    	Map<String, Vol_TAT__c> flightsMap = new Map<String, Vol_TAT__c>();
        Vol_TAT__c flight;
        
        for(SObject s : scope) {
            flight = (Vol_TAT__c) s;
            flightsMap.put(flight.Cle_du_vol__c, flight);
        }
        System.enqueueJob(new TAT_RocadeService.GetCrew(flightsMap, startDate, endDate));
	}

   	public void finish(Database.BatchableContext BC) {
        if (!autoReschedule) {
            return;
        }
            
		for (CronTrigger job : [
            SELECT	Id
            FROM	CronTrigger
            WHERE	CronJobDetail.Name = 'Rocade JOB'
        ]) {
            System.abortJob(job.Id);
        }
        
        TAT_RocadeSchedule schedule = new TAT_RocadeSchedule();
        DateTime runTime = Datetime.now().addMinutes(scheduleSize);
        String cronString = '' + runTime.second() + ' ' + runTime.minute() + ' ' + runTime.hour() + ' ';
        cronString += runTime.day() + ' ' + runTime.month() + ' ? ' + runTime.year();
		System.schedule('Rocade JOB', cronString, schedule);
   	}

}