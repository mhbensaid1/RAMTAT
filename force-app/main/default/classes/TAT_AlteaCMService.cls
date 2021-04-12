/**
* @author         Salesforce TAT Team
* @date           Feb 27, 2019
* @description    Manage Altea WS
* @history        
*/
public with sharing class TAT_AlteaCMService {

    public class updateFlight implements Queueable,Database.AllowsCallouts {
        
        private List<Vol_TAT__c> flightsToProcess = new List<Vol_TAT__c>();
        private List<Vol_TAT__c> flightsToUpdate = new List<Vol_TAT__c>();
        private Integer passengerProcess;
        private Integer ptm;
        private Integer speReq;
        
        public updateFlight(List<Vol_TAT__c> flightToProcess, List<Vol_TAT__c> flightToUpdate, Integer passengerProcess, Integer ptm, Integer speReq) {
            this.flightsToProcess = flightToProcess;
            this.flightsToUpdate = flightToUpdate;
            this.passengerProcess = passengerProcess;
            this.ptm = ptm;
            this.speReq = speReq;
        }        
        public void execute(QueueableContext context) {
            try {
                if(!flightsToProcess.isEmpty()){
                    Vol_TAT__c volUpdated = TAT_AlteaManagement.getFlightInfo(flightsToProcess[0], passengerProcess, ptm, speReq);
                    if(volUpdated != null){
                        flightsToUpdate.add(volUpdated);
                    }
                    flightsToProcess.remove(0);
                    if (!flightsToProcess.isEmpty()) {
                        System.enqueueJob(new TAT_AlteaCMService.updateFlight(flightsToProcess,flightsToUpdate, passengerProcess, ptm, speReq));
                    }else{
                        update flightsToUpdate;
                    }
                }
            } catch(System.CalloutException e) {
                System.debug('Callout error: '+ e);
            }
        }
    }
}