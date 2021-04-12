/**
* @author         Salesforce TAT Team
* @date           Mai 09, 2019
* @description    TAT Web service Mock 
* @history      
*
**/
@isTest
global class TAT_RocadeLoginHttpCalloutMock implements HttpCalloutMock {

    private static final String RESPONSE_BODY = '<Login_x0028_UserId_x002C__x0020_password_x0029_Result>test</Login_x0028_UserId_x002C__x0020_password_x0029_Result>';
    public static final String RESPONSE_HEADER_CONTENT_TYPE = 'application/json';
	public static final String RESPONSE_HEADER_PARAM_NAME = 'Content-Type';  
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader(RESPONSE_HEADER_PARAM_NAME, RESPONSE_HEADER_CONTENT_TYPE);
        response.setBody(RESPONSE_BODY);
        response.setStatusCode(200);
        return response; 
    }
}