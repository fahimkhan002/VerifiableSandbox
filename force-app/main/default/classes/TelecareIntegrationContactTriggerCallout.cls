public class TelecareIntegrationContactTriggerCallout implements Queueable, Database.AllowsCallouts {
    
                                    // AFTER_INSERT CALLOUT 
    
    protected list<contact> contList;
    protected contact contct;
    
    Contact_Integration_Data__mdt getEndpoint = [Select id, DeveloperName, Value__c From Contact_Integration_Data__mdt where DeveloperName = 'Endpoint' ];
    protected Final String EndpointValue = getEndpoint.Value__c;
        
    public TelecareIntegrationContactTriggerCallout( list<Contact> contList, contact contct ){
        
        this.contList = contList;
        this.contct = contct;
    }
    
    public void execute( QueueableContext QContext ){
        
        list<TelecareJSONWrapperClass.ContactWrapper> ContactPayload = generateContactJSON( contList );
        system.debug(ContactPayload);
        
        for(TelecareJSONWrapperClass.ContactWrapper JsonPayload : ContactPayload){
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(EndpointValue);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');           
            System.debug(JsonPayload);
            request.setBody(JSON.serializePretty(JsonPayload, false));
            request.setTimeout(60000);
            
            
            HttpResponse response = http.send(request);
            system.debug(request);
            
                // Handle the response as needed
                if (response.getStatusCode() == 200) {
                    // Successful response handling
                    System.debug('POST request successful. Response: ' + response.getBody());
                    
                    map<string, object> responseMap =  (map<string, object>) Json.deserializeUntyped(response.getBody());
                    system.debug(responseMap); 
                    
                    if(responseMap.get('status')==0){
                        String IdData = (String) responseMap.get('data');
                        system.debug(IdData);
                                        
                        Contact contactToUpdate = [
                            SELECT Id, TelecareId__c 
                            FROM Contact
                            WHERE Id = :contct.Id
                            LIMIT 1
                        ];
                        
                        if (contactToUpdate != null) {
                            contactToUpdate.TelecareId__c  = IdData;
                            update contactToUpdate;
                        }
                    }
                    
                    if(responseMap.get('status')==-1){
                        /*
                        System.debug('POST request failed. Status code: ' + responseMap.get('status'));
                        System.debug('Response body: ' + response.getBody());
                        map<string, object> ErrorResponseMap =  (map<string, object>) Json.deserializeUntyped(response.getBody());
                        system.debug(ErrorResponseMap);
                         
                        Telecare_Error_Log__c TELogs = new Telecare_Error_Log__c();
                        TELogs.Error_Message__c = (String)ErrorResponseMap.get('msg');
                        TELogs.NPI_Number_Error__c = String.valueof(ErrorResponseMap.get('data'));
                        TELogs.Status_Code__c = String.valueof(ErrorResponseMap.get('status'));
                        TELogs.Description__c = response.getBody();
                        TELogs.NPI_Number_Error__c = (String)ErrorResponseMap.get('msg'); 
                        TELogs.Record_Id__c = contct.Id;                              
                        
                        System.debug('Getting the data as follows '+ TELogs);
                        
                        try {
                            INSERT TELogs;
                        } catch (Exception e) {
                            System.debug('Error inserting TELogs: ' + e.getMessage());
                        }    
                        */
                    }
    
                
                } else {
                // Error handling
                System.debug('POST request failed. Status code: ' + response.getStatusCode());
                System.debug('Response body: ' + response.getBody());
                map<string, object> ElseErrorResponseMap =  (map<string, object>) Json.deserializeUntyped(response.getBody());
                /*
                Telecare_Error_Log__c TELogs = new Telecare_Error_Log__c();
                TELogs.Error_Message__c = response.getBody();
                TELogs.NPI_Number_Error__c = response.getBody();
                TELogs.Status_Code__c = String.valueOf(response.getStatusCode());
                TELogs.Description__c = response.getBody();
                
                INSERT TELogs;    */
                throw new CalloutException(response.getBody());            
                
                }
            
        }
        
       
    
    }    
        
        
        
    
    
    private list<TelecareJSONWrapperClass.ContactWrapper> generateContactJSON( list<Contact> contList ){
        
        list<TelecareJSONWrapperClass.ContactWrapper> ConDataInstanceList = new list<TelecareJSONWrapperClass.ContactWrapper>();
        
        for(contact con : contList){            
            ConDataInstanceList.add(generateContactJSONWrapper(con));                        
        }
        system.debug(ConDataInstanceList);
        return ConDataInstanceList;
    }
     
    
    private TelecareJSONWrapperClass.ContactWrapper generateContactJSONWrapper( Contact con ){

        TelecareJSONWrapperClass.ContactWrapper ConDataInstance = new TelecareJSONWrapperClass.ContactWrapper();
                    
            ConDataInstance.Email = con.Email;
            ConDataInstance.FirstName = con.FirstName;
            ConDataInstance.LastName = con.LastName;
            ConDataInstance.Gender = 'TestGender';
            ConDataInstance.NPINumber = con.NPI_Number__c;
            ConDataInstance.MobilePhone = con.MobilePhone;
            ConDataInstance.AddressBlock = 'Example'; //con.MailingStreet+ ' '+con.MailingCity+ ' '+con.MailingState+ ' '+con.MailingPostalCode+ ' '+con.MailingCountry;
            ConDataInstance.IsActive = true;
            ConDataInstance.ContractDate = DateTime.now();
            system.debug(ConDataInstance);
        
            return ConDataInstance;
    }
    
    
    
    
    
    
}