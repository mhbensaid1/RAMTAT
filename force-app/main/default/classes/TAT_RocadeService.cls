/**
 * @author         Salesforce TAT Team
 * @date           Jan 28, 2019
 * @description    Used for Rocade Webservice Calls
 * @history
 *
 **/

public class TAT_RocadeService {
    
    public class Login implements Queueable,Database.AllowsCallouts {
        
        private Map<String, Vol_TAT__c> flightsMap;
        private String startDate;
        private String endDate;
        
        public Login(Map<String, Vol_TAT__c> flightsMap, String startDate, String endDate) {
            this.flightsMap = flightsMap;
            this.startDate = startDate;
        	this.endDate = endDate;
        }
        
        public void execute(QueueableContext context) {
            Map<String, String> rocadeSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_ROCADE_SETTINGS);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
    
            PageReference staticTemplate = new PageReference('/resource/TAT_RocadeLoginRequestTemplate');
            Blob content;
            if(Test.isRunningTest()){
                content = Blob.valueOf('MockContent');
            }else{
            	content = staticTemplate.getContent();
            }
            String theBody = content.toString();
            theBody = theBody.replace('%%USER_ID%%', rocadeSettings.get('Rocade Username'));
            theBody = theBody.replace('%%USER_PASSWORD%%', rocadeSettings.get('Rocade Password'));
            
            req.setEndpoint(rocadeSettings.get('Rocade End Point') + '/RMI_WS/RMIService.asmx');
            //req.setEndpoint('http://rocpws.royalairmaroc.com/RMI_WS/RMIService.asmx');
            req.setHeader('Accept-Encoding', 'gzip,deflate');
            req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            req.setHeader(
                'SOAPAction',
                '"http://www.rmrocade.com/RMI/Login(UserId, password)"' 
            );
            req.setHeader('SkipSOAPAction', 'false');
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(theBody);
            //System.debug('### AES Rocade requette '+req);
            try {
                System.debug('Rocade LOGIN call');
                res = http.send(req);
                System.debug('LOGIN response: ' + res.getBody());
                Boolean loginOK = TAT_RocadeManagement.parseLoginResponse(res.getBody());
                System.debug('loginOK: ' + loginOK);
                if (loginOK) {
                	System.enqueueJob(new TAT_RocadeService.GetCrew(flightsMap, startdate, endDate));
                }
            } catch(System.CalloutException e) {
                System.debug('Callout error: '+ e);
                System.debug(res.toString());
            }
        }
    }
    
    public class GetCrew implements Queueable,Database.AllowsCallouts {
        
        private Map<String, Vol_TAT__c> flightsMap;
        private String startDate;
        private String endDate;
        
        public GetCrew(Map<String, Vol_TAT__c> flightsMap, String startDate, String endDate) {
            this.flightsMap = flightsMap;
            this.startDate = startDate;
        	this.endDate = endDate;
        }
        
        public void execute(QueueableContext context) {
            Map<String, String> rocadeSettings = TAT_Utils.getAppSetting(TAT_StaticConstants.CATEGORY_ROCADE_SETTINGS);
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
    		
            String flightNumbers = '';
            for (Vol_TAT__c flight : flightsMap.values()) {
                flightNumbers += Integer.valueOf(flight.numero_du_vol__c) + ',';
            }
            flightNumbers = flightNumbers.removeEnd(',');
            PageReference staticTemplate = new PageReference('/resource/TAT_RocadeGetCrewRequestTemplate');
            Blob content;
            if(Test.isRunningTest()){
                content = Blob.valueOf('MockContent');
            }else{
            	content = staticTemplate.getContent();    
            }
            String theBody = content.toString();
            theBody = theBody.replace('%%USER_ID%%', rocadeSettings.get('Rocade Username'));
            theBody = theBody.replace('%%AIRLINE%%', '\'AT\'');
            theBody = theBody.replace('%%FLTNBR%%', flightNumbers);
            theBody = theBody.replace('%%STARTTIME%%', (startDate+'-'+endDate));
            
            req.setEndpoint(rocadeSettings.get('Rocade End Point') + '/RMI_WS/RMIService.asmx');
            //req.setEndpoint('http://rocpws.royalairmaroc.com/RMI_WS/RMIService.asmx');
            req.setHeader('Accept-Encoding', 'gzip,deflate');
            req.setHeader('Content-Type', 'text/xml;charset=UTF-8');
            req.setHeader(
                'SOAPAction',
                '"http://www.rmrocade.com/RMI/GetCrewOnBoard(string UserId,DataSet Layout,ref DataSet ResultRows, ref DataSet MsgRows)"'
            );
            req.setHeader('SkipSOAPAction', 'false');
            req.setMethod('POST');
            req.setTimeout(120000);
            req.setBody(theBody);
            System.debug('### AES Rocade requette '+req);
            try {
                System.debug('Rocade GETCREW call');
                res = http.send(req);
                System.debug('GETCREW response: ' + res.getBody());
                Boolean connectionOK = TAT_RocadeManagement.isConnectionAlive(res.getBody());
                System.debug('connectionOK: ' + connectionOK);
                if (connectionOK) {
                    TAT_RocadeManagement.parseGetCrewResponse(res.getBody(), flightsMap);
                }
                else {
					System.enqueueJob(new TAT_RocadeService.Login(flightsMap, startDate, endDate));
                }
            } catch(System.CalloutException e) {
                System.debug('Callout error: '+ e);
                System.debug(res.toString());
            }
        }
    }
    
}