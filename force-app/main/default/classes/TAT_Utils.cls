/**
* @author         Salesforce TAT Team
* @date           Dec 25, 2018
* @description    Class for utility methods
* @history      
*
**/

public with sharing class TAT_Utils {

    /**
    * @description  method used to get session Ids
    * @param   
    * @return   String: get Session Id
    */
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }

    /**
     * @description	method used to send an email based on an email template and a temporary contact
     * @param		developerName : email template developer name aka Unique Name
     * @param		contact Email
     * @param		firstname
     * @param		lastname
     * @param		whatId : Id of the record to get the informations in the template in case u're using Merge Fields 
     * @return		void
     */
    public static void sendEmailTemplate(String developerName, String contactEmail, String firstName, String lastName, Id theWhatId) {

        SavePoint sp = Database.setSavepoint();
        Contact hackContact = new Contact(
            FirstName = firstName,
            LastName = lastName,
            Email = contactEmail,
            Salutation = 'M.' //required
        );
        insert hackContact;
        try {
            sendEmailTemplate(developerName, contactEmail, hackContact.Id, theWhatId);
            delete hackContact;
        }
        catch (Exception exp) {
            Database.rollback(sp);
        }
    }
     /**
     * @description	method used to send an email based on an email template & an existion contact
     * @param		developerName : email template developer name
     * @param		contact Email
     * @param		contact Id
     * @param		whatId : Id of the record to get the informations in the template
     * @return		void
     */
    public static void sendEmailTemplate(String developerName, String contactEmail, Id contactId, Id theWhatId) {
        List<String> toEmails = new List<String>();
        toEmails.add(contactEmail);
        //OrgWideEmailAddress owa = [select id, DisplayName, Address from OrgWideEmailAddress limit 1];
        EmailTemplate templateId = [Select id from EmailTemplate where DeveloperName = :developerName];
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTargetObjectId(contactId);
        mail.setToAddresses(toEmails);
        mail.setTemplateID(templateId.Id);
        mail.setSaveAsActivity(false);
        //mail.setOrgWideEmailAddressId(owa.id);
        if (theWhatId != null) {
            mail.setWhatId(theWhatId);
        }
        allmsg.add(mail);
        Messaging.sendEmail(allmsg);
    }


 
    /**
    * @description	method used to get the app setting (custom metadata type)
    * @param	category
    * @return	Map<String, String>
    */
    public static Map<String, String> getAppSetting(String category) {
        Map<String, String> result = new Map<String, String>();
        list<TAT_AppSetting__mdt> techSettings = [
            SELECT MasterLabel, TAT_Value__c
            FROM TAT_AppSetting__mdt
            WHERE TAT_Category__c = :category
        ];
        for (TAT_AppSetting__mdt techSetting : techSettings) {
            result.put(techSetting.MasterLabel, techSetting.TAT_Value__c);
        }
        return result;
    }
    
    /**
    * @description	method used to get the admin setting (custom metadata type)
    * @param	category
    * @return	Map<String, String>
    */
    
    public static Map<String, String> getAdminSetting() {
        Map<String, String> result = new Map<String, String>();
        list<TAT_AdminSetting__mdt> techSettings = [
            SELECT MasterLabel, Value__c
            FROM TAT_AdminSetting__mdt
        ];
        for (TAT_AdminSetting__mdt techSetting : techSettings) {
            result.put(techSetting.MasterLabel, techSetting.Value__c);
        }
        return result;
    }
    
      /**
     * @description    get record types map by sObjectType and Developer names
     * @param          sobjectType 
     * @param          list of developerNames
     * @return         record type Id
     * 
     */
    public static map<String,Id> getRecordTypeByDevNames(String sobjectType, Set<String> developerNames) {
        Id recordId = null;
        map<String,Id> mapRecordTypes = new map<String,Id>();
        List<RecordType> recordList = [
			SELECT 	Id,DeveloperName
            FROM 	RecordType
            WHERE 	DeveloperName IN:developerNames
            AND 	SobjectType = :sobjectType
		];
        for( RecordType rt :recordList){
            mapRecordTypes.put(rt.DeveloperName,rt.Id);
        }
        return mapRecordTypes;
    }
    /**
     * @description    get record type Id by sObjectType and Developer name
     * @param          sobjectType 
     * @param          developerName
     * @return         record type Id
     * 
     */
    public static Id getRecordTypeByDevName(String sobjectType, String developerName) {
        Id recordId = null;
        List<RecordType> recordList = [
			SELECT 	Id
            FROM 	RecordType
            WHERE 	DeveloperName = :developerName
            AND 	SobjectType = :sobjectType
		];
        if(!recordList.isEmpty()){
            recordId = recordList[0].Id;
        }
        return recordId;
    }
    
    /**
     * @description		insert a record into the technical object "Log" (external system related issues)
     * @param			className : the name of the class that catched the exception/issue
     * @param			methodName : the name of the class method that catched the exception/issue
     * @param			type : one of the values -> Success/Warning/Error
     * @param			category : the category of the issue (Database, Call Out, ...)
     * @param			description : a free text describing the issue
     * @param			request : the callout request
     * @param			response : the callout response
     * @param			remoteSystem : the remote system name (Netline, Rocade, ...)
     * @return			Boolean : true if the record is inserted succesfully
     */
    public static Log__c writeLog(String className, String methodName, String type, String category, String description, String request, String response, String remoteSystem, Boolean doInsert) {
        Log__c logEntry = new Log__c(
            // required fields
            ClassName__c = className,
            MethodName__c = methodName,
            Type__c = type,
            Category__c = category,
            // other fields
            Description__c = description,
            Request__c = request,
            Response__c = response,
            RemoteSystem__c = remoteSystem
        );
        
		if (doInsert) {
			insert logEntry;
        }
		
        return logEntry;
    }
    
    /**
     * @description		insert a record into the technical object "Log" (internal issues)
     * @param			className : the name of the class that catched the exception/issue
     * @param			methodName : the name of the class method that catched the exception/issue
     * @param			type : one of the values -> Success/Warning/Error
     * @param			category : the category of the issue (Database, Call Out, ...)
     * @param			description : a free text describing the issue
     * @param			objectName : the api name of the issue realted SObject
     * @param			recordId : the external id of the issue related record, otherwise the SF id of the record
     * @return         	Boolean : true if the record is inserted succesfully
     */
    public static Log__c writeLog(String className, String methodName, String type, String category, String description, String objectName, String recordId, Boolean doInsert) {
        Log__c logEntry = new Log__c(
            // required fields
            ClassName__c = className,
            MethodName__c = methodName,
            Type__c = type,
            Category__c = category,
            // other fields
            Description__c = description,
            RelatedObjectName__c = objectName,
            RelatedRecordIDorExternalID__c = recordId
        );
        
		if (doInsert) {
			insert logEntry;
        }
		
        return logEntry;
    }
    
    /**
     * @description		Format a string date from the format DDMMMYY to the Date format
     * @param			year : a String represneting the Date year: YY
     * @param			month : a String representing the Date month: MMM
     * @param			day : a String representing the Date day: DD
     * @return         	Date : the formatted date
     */
    public static Date formatDate(String year, String month, String day) {
        Map<String, Integer> monthsMap = new Map<String, Integer>{
            'JAN' => 1, 'FEV' => 2, 'FEB' => 2, 'MAR' => 3, 'AVR' => 4, 'APR' => 4,
            'MAI' => 5, 'MAY' => 5, 'JUN' => 6, 'JUL' => 7, 'AOU' => 8, 'AUG' => 8,
            'SEP' => 9, 'OCT' => 10, 'NOV' => 11, 'DEC' => 12
        };
		Integer theYear = (Date.today().year()/100)*100 + Integer.valueOf(year);
        Date formattedDate = Date.newInstance(theYear, monthsMap.get(month), Integer.valueOf(day));
        return formattedDate;
    }
    
    /**
     * @description		Format a string date from the format DD
     * @param			day : a String representing the Date day: DD
     * @return         	Date : the formatted date
     */
    public static Date formatDate(String day) {
        Date formattedDate = Date.newInstance(Date.today().year(), Date.today().month(), Integer.valueOf(day));
        return formattedDate;
    }
    
    /**
     * @description		Format a string date from the format YYMMDD
     * @param			CTOTDate : a String representing the Date: YYMMDD
     * @return         	Date : the formatted date
     */
    public static Date formatCTOTDate(String CTOTDate) {
        Integer theYear = (Date.today().year()/100)*100 + Integer.valueOf(CTOTDate.substring(0,2));
        Date formattedDate = Date.newInstance(theYear, Integer.valueOf(CTOTDate.substring(2,4)), Integer.valueOf(CTOTDate.substring(4)));
        return formattedDate;
    }
    
    /**
     * @description		Format a date from Date to a String(YYYYMMDD)
     * @param			theDate : a Date representing the Date
     * @return         	String : the formatted date as YYYYMMDD
     */
    public static String formatDate(Date theDate) {
        String formattedDate = String.valueOf(theDate.year())+String.valueOf(theDate.month()).leftPad(2,'0')+String.valueOf(theDate.day()).leftPad(2,'0');
        return formattedDate;
    }
    
    /**
     * @description		Format a string time from the format DDHHMM or HHMM to the Time format (DD will be ignored)
     * @param			dayTime : a String represneting the day and time in one of the formats DDHHMM(Ex: 311045) or HHMM(1045)
     * @return         	Time : the formatted time
     */
    public static Time formatTime(String dayTime) {
        dayTime = dayTime.right(4);
        Time formattedTime = Time.newInstance(Integer.valueOf(dayTime.left(2)), Integer.valueOf(dayTime.right(2)), 0, 0);
        return formattedTime;
    }

 
    /**
    * @description	method used to get minutes between two DateTimes 
    * @param	firstDate: dateTime
    * @param	secondDate: dateTime
    * @return	Long: number of minutes
    */
    public static Long minutesBetween(DateTime firstDate,DateTime secondDate){
        Long dt1Long = firstDate.getTime();
        Long dt2Long = secondDate.getTime();
        Long milliseconds = dt1Long - dt2Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        return minutes;
    }
    
    /**
    * @desc     getPickListValuesIntoList: used to get the picklist field options in list
    * @param    objectApiName: the Object API Name
    * @param    fieldApiName: the Field API Name
    * @return   List<string>: the list of picklist values  
    */
    public static List<String> getPickListValuesIntoList(string objectApiName, string fieldApiName ){
        try{            
            List<String> pickListValuesList= new List<String>();           
            SObjectType objectType = Schema.getGlobalDescribe().get(objectApiName);
            List<Schema.PicklistEntry> ple = objectType.getDescribe().fields.getMap().get(fieldApiName).getDescribe().getPicklistValues();            
            for( Schema.PicklistEntry pickListVal : ple){
                pickListValuesList.add(pickListVal.getValue());
            }     
            return pickListValuesList;
        }catch (Exception e) {
            throw new AuraHandledException('Something went wrong while getting the picklist values: '+ e.getMessage());    
        }
    }
        
	public static String convertMinutes(Long timeMinutes){        
        String t = '';
        if(timeMinutes <= 0 || timeMinutes == null){
            t = '0';
        }else{       
            integer j = (integer)timeMinutes/(24*60);
            String jj = '';
            integer modulo = (integer)math.mod(timeMinutes,(24*60)) ;
            integer h = modulo / 60;
            String hh = '';
            integer m = (integer)math.mod(modulo , 60) ;
            String mm = '';
            if(j != 0 ){
                jj = j + 'j';
            }if(h != 0 ){
                hh = h + 'h';
            }if(m != 0 ){
                mm = m +'min';
            }
            t = jj + hh + mm;
        }
        return t;
    }
    
    /**
    * @description		Format a string date from the format YYYYMMDD to YYYY-MM-DD
    * @param    inputStingDate : the input String YYYYMMDD
    * @param    outputStingDate : the output STRING YYYY-MM-DD
    */
    public static String InputStringOutDate(String inputStringDate) {
        String inputStingDate;
        String outputStingDate = inputStringDate.substring(0,4)+ '-' + inputStringDate.substring(4,6)+ '-' + inputStringDate.substring(6,8);
        return outputStingDate;       
    }
}