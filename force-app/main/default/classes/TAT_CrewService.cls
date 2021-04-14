/**
* @author         Salesforce TAT Team
* @date           Apr 14, 2021
* @description    The Service - generated using WSDL2Apex - is reponsible of retrieving crews from JCL 
* @history        
*/
public class TAT_CrewService {
    public class getCrewData_element {
        public TAT_CrewBean.FlightCrewInput flightCrewInput;
        private String[] flightCrewInput_type_info = new String[]{'flightCrewInput','http://service',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://service','true','true'};
        private String[] field_order_type_info = new String[]{'flightCrewInput'};
    }
    public class getCrewRosterResponse_element {
        public TAT_CrewBean.FlightCrewOutput return_x;
        private String[] return_x_type_info = new String[]{'return','http://service',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://service','true','true'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class getCrewOnBoard_element {
        public TAT_CrewBean.FlightCrewInput flightCrewInput;
        private String[] flightCrewInput_type_info = new String[]{'flightCrewInput','http://service',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://service','true','true'};
        private String[] field_order_type_info = new String[]{'flightCrewInput'};
    }
    public class getCrewOnBoardResponse_element {
        public TAT_CrewBean.FlightCrewOutput return_x;
        private String[] return_x_type_info = new String[]{'return','http://service',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://service','true','true'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class getCrewDataResponse_element {
        public TAT_CrewBean.FlightCrewOutput return_x;
        private String[] return_x_type_info = new String[]{'return','http://service',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://service','true','true'};
        private String[] field_order_type_info = new String[]{'return_x'};
    }
    public class getCrewRoster_element {
        public TAT_CrewBean.FlightCrewInput flightCrewInput;
        private String[] flightCrewInput_type_info = new String[]{'flightCrewInput','http://service',null,'0','1','true'};
        private String[] apex_schema_type_info = new String[]{'http://service','true','true'};
        private String[] field_order_type_info = new String[]{'flightCrewInput'};
    }
    public class CrewInfoServiceImplHttpSoap11Endpoint {
        public String endpoint_x = 'http://tatws.royalairmaroc.com/FlightCrewInfo/services/CrewInfoServiceImpl.CrewInfoServiceImplHttpSoap11Endpoint/';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://beans/xsd', 'TAT_CrewBean', 'http://service', 'TAT_CrewService'};
        public TAT_CrewBean.FlightCrewOutput getCrewRoster(TAT_CrewBean.FlightCrewInput flightCrewInput) {
            TAT_CrewService.getCrewRoster_element request_x = new TAT_CrewService.getCrewRoster_element();
            request_x.flightCrewInput = flightCrewInput;
            TAT_CrewService.getCrewRosterResponse_element response_x;
            Map<String, TAT_CrewService.getCrewRosterResponse_element> response_map_x = new Map<String, TAT_CrewService.getCrewRosterResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:getCrewRoster',
              'http://service',
              'getCrewRoster',
              'http://service',
              'getCrewRosterResponse',
              'TAT_CrewService.getCrewRosterResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        public TAT_CrewBean.FlightCrewOutput getCrewOnBoard(TAT_CrewBean.FlightCrewInput flightCrewInput) {
            TAT_CrewService.getCrewOnBoard_element request_x = new TAT_CrewService.getCrewOnBoard_element();
            request_x.flightCrewInput = flightCrewInput;
            TAT_CrewService.getCrewOnBoardResponse_element response_x;
            Map<String, TAT_CrewService.getCrewOnBoardResponse_element> response_map_x = new Map<String, TAT_CrewService.getCrewOnBoardResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:getCrewOnBoard',
              'http://service',
              'getCrewOnBoard',
              'http://service',
              'getCrewOnBoardResponse',
              'TAT_CrewService.getCrewOnBoardResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
        public TAT_CrewBean.FlightCrewOutput getCrewData(TAT_CrewBean.FlightCrewInput flightCrewInput) {
            TAT_CrewService.getCrewData_element request_x = new TAT_CrewService.getCrewData_element();
            request_x.flightCrewInput = flightCrewInput;
            TAT_CrewService.getCrewDataResponse_element response_x;
            Map<String, TAT_CrewService.getCrewDataResponse_element> response_map_x = new Map<String, TAT_CrewService.getCrewDataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'urn:getCrewData',
              'http://service',
              'getCrewData',
              'http://service',
              'getCrewDataResponse',
              'TAT_CrewService.getCrewDataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.return_x;
        }
    }
}