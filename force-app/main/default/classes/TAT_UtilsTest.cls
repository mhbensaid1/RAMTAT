/**
* @author          Salesforce TAT Team
* @since           May 9, 2019
* @description     The test class of  TAT_MonitoringController
*/
@isTest
public class TAT_UtilsTest {
    
    private static testMethod void formatTimeTest() {    
       
            // test start
            Test.startTest();
            
            TAT_Utils.formatTime('1020');
            
            Test.stopTest();
        
    }
    
    private static testMethod void formatDateTest() {    
        
            // test start
            Test.startTest();
            
            TAT_Utils.formatDate('14','MAY','9');
            
            Test.stopTest();
      
    }
    
    private static testMethod void formatDate2Test() {    
        
            // test start
            Test.startTest();
            
            TAT_Utils.formatDate('9');
            
            Test.stopTest(); 
        
    }
    
    private static testMethod void formatCTOTDateTest() {    
         
            // test start
            Test.startTest();
            
            TAT_Utils.formatCTOTDate('190323');
            
            Test.stopTest();
        
    }
    
    
    
    private static testMethod void convertMinutesTest() {    
          
            TAT_Utils.getSessionId();
            
            // test start
            Test.startTest();
            
            TAT_Utils.convertMinutes(190323);
            
            Test.stopTest();
       
    }
    
    private static testMethod void writeLogTest() {    
         
            // test start
            Test.startTest();
            
            TAT_Utils.writeLog('TAT_MonitoringController', 'getFlightsByTAT', 'Success', 'Database', 'a free text describing the issue', 'Vol_TAT__c', 'a1A0Q000000KGGmUAO', true);
            
            Test.stopTest();
        
    }
    
    private static testMethod void sendEmailTemplateTest() {    
        
            // test start
            Test.startTest();
            try{  
                TAT_Utils.sendEmailTemplate('', '', '', '', null);
            }catch (exception e) {
                
            }
            
            Test.stopTest();
       
    }
    
    private static testMethod void getPickListValuesIntoListTest() {    
           
            // test start
            Test.startTest();
            try{  
                TAT_Utils.getPickListValuesIntoList('Vol_TAT__c','Appareil__c ');
            }catch (exception e) {
                
            }
            
            Test.stopTest();
      
    }
    
}