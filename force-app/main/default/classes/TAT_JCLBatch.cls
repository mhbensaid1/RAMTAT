/**
* @author         Salesforce TAT Team
* @date           Apr 13, 2021
* @description    Batch responsible of fetching crew members from JCL
* @history        
*/
public class TAT_JCLBatch implements Database.Batchable<sObject> {
    public final String query;
    public final String startDate;
    public final String endDate;
    public final Boolean autoReschedule;
    public final Integer scheduleSize;
    
    
    public TAT_JCLBatch(String query, String startDate, String endDate, Boolean autoReschedule, Integer scheduleSize) {
        this.query = query;
        this.startDate = startDate;
        this.endDate = endDate;
        this.autoReschedule = autoReschedule;
        this.scheduleSize = scheduleSize;
    }
    
	public Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
   	}

   	public void execute(Database.BatchableContext BC, List<Vol_TAT__c> scope) {
    	Map<String, Vol_TAT__c> flights = new Map<String, Vol_TAT__c>();
        List<Integer> flightNumbers = new List<Integer>();
        
        for(Vol_TAT__c flight : scope) {
            flights.put(flight.Cle_du_vol__c, flight);
            flightNumbers.add(Integer.valueOf(flight.numero_du_vol__c));
        }

        TAT_CrewBean.CrewRoster[] crewRosters = TAT_JCLManagement.getCrewOnBoard(flightNumbers, startDate, endDate);
        if(crewRosters != null){
            TAT_JCLManagement.updateOnBoardCrews(crewRosters, flights);
        }
	}

   	public void finish(Database.BatchableContext BC) {
        if (!autoReschedule) {
            return;
        }
            
		for (CronTrigger job : [
            SELECT	Id
            FROM	CronTrigger
            WHERE	CronJobDetail.Name = 'JCT JOB'
        ]) {
            System.abortJob(job.Id);
        }
        
        TAT_JCLSchedule schedule = new TAT_JCLSchedule();
        DateTime runTime = Datetime.now().addMinutes(scheduleSize);
        String cronString = '' + runTime.second() + ' ' + runTime.minute() + ' ' + runTime.hour() + ' ';
        cronString += runTime.day() + ' ' + runTime.month() + ' ? ' + runTime.year();
		System.schedule('JCL JOB', cronString, schedule);
   	}

}
