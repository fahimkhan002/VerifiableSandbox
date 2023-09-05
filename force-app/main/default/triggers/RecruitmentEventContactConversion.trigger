trigger RecruitmentEventContactConversion on Recruitment_Event__c ( BEFORE INSERT, AFTER INSERT, BEFORE UPDATE, AFTER UPDATE, BEFORE DELETE, AFTER DELETE, AFTER UNDELETE ) {

    
    if(trigger.isAfter && trigger.isUpdate){          
        // Code to Get the IDs of those Recruitment events that needs to be Converted to Physician contact. 
        Set<Id> recEventId = new Set<Id>();          
        for( Recruitment_Event__c recEventNew : trigger.new ){
            
            Recruitment_Event__c recEventOld = trigger.oldmap.get(recEventNew.id);
            if( recEventOld.Signed_Contract_Date__c == null && recEventNew.Signed_Contract_Date__c != null && recEventNew.Recruitment_Event_Status__c != 'Converted' ){
                
                
               recEventId.add(recEventNew.Id);
                
            }           
            
        }
        
      
                 
        // Getting the 'TeleSpecialists, LLC' Account Id    
        Account AccountName = [Select Name FROM Account WHERE Name = 'TeleSpecialists, LLC' Limit 1 ];
        string AccountId = AccountName.Id;  
        // The contacts List that will be created from Each Recruitment_Event__c    
        list<Contact> conList = new list<Contact>();
        // Getting the Physician RecordTypeId
        String contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Physician').getRecordTypeId(); 
        // The List of Recruitment_Event__c That are updated to Signed contract Date
        list<Recruitment_Event__c> RecUpdatedList = [ SELECT Id, LastName__c, FirstName__c, Salutation__c, Email__c, MobilePhone__c, Lead__c, Signed_Contract_Date__c, Offered_Date__c  FROM Recruitment_Event__c WHERE Id IN: recEventId ];        
             
            
            
        List<Lead> UpdatedLeads = new list<Lead>();
        
        List<ContentDocumentLink> contentDocumentLinksToInsert = new List<ContentDocumentLink>();
        list<Recruitment_Event__c> recEvIdStatuses = new list<Recruitment_Event__c>();
        
        
        //Queries for content document transfer.
        Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, Hiding_Sections__c FROM Lead WHERE Id IN (SELECT Lead__c FROM Recruitment_Event__c WHERE Id IN :RecUpdatedList)]);
                     
        // Video link to resolve the error below = https://www.youtube.com/watch?v=7ngN_MWF_Bo              
        Set<Id> contentDocIdList = leadMap.keySet();                      
        List<ContentDocumentLink> contentDocLinksList = [ SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN (SELECT Id FROM Lead WHERE id in : contentDocIdList ) ];       
        Map<Id, List<ContentDocumentLink>> contentDocumentLinksMap = new Map<Id, List<ContentDocumentLink>>();

        for ( ContentDocumentLink contentDocumentLink : contentDocLinksList ) {
            if (!contentDocumentLinksMap.containsKey(contentDocumentLink.LinkedEntityId)) {
                contentDocumentLinksMap.put(contentDocumentLink.LinkedEntityId, new List<ContentDocumentLink>());
            }
            contentDocumentLinksMap.get(contentDocumentLink.LinkedEntityId).add(contentDocumentLink);
        }
        
        
        // Main loop to run over Every recruitment Event record
        for(Recruitment_Event__c recEvId : RecUpdatedList){
                                                  
            
            //Updating the recEvId Status to converted. 
            recEvId.Recruitment_Event_Status__c = 'Converted'; 
            recEvIdStatuses.add(recEvId);
                 
            // New Contact Creation when the signed Contract Date is Not Null
            Contact Con = new Contact();
            con.RecordTypeId = contactRecordTypeId; 
            con.AccountId = AccountId;
            con.RecruitmentEventId__c = recEvId.id;
            con.LastName = recEvId.LastName__c;  
            con.FirstName = recEvId.FirstName__c;
            con.Salutation = recEvId.Salutation__c;
            con.MobilePhone = recEvId.MobilePhone__c;
            con.Email = recEvId.Email__c;
            con.Signed_Contract_Date__c = recEvId.Signed_Contract_Date__c;
            con.Offered_Date__c = recEvId.Offered_Date__c;
            conList.add(con);
            system.debug(conList.size());
            
            // Get Lead and its ContentDocuments
            Lead leadRecord = leadMap.get(recEvId.Lead__c);
            leadRecord.Hiding_Sections__c = true;
            leadRecord.Status = 'Recruitment Event Converted';
            UpdatedLeads.add(leadRecord);
            
            List<ContentDocumentLink> leadContentDocumentLinks = contentDocumentLinksMap.get(leadRecord.Id);
            if (leadContentDocumentLinks != null) {
                for (ContentDocumentLink contentDocumentLink : leadContentDocumentLinks) {
                    ContentDocumentLink newContentDocumentLink = new ContentDocumentLink();
                    newContentDocumentLink.ContentDocumentId = contentDocumentLink.ContentDocumentId;
                    newContentDocumentLink.LinkedEntityId = con.Id;
                    newContentDocumentLink.ShareType = 'V';
                    contentDocumentLinksToInsert.add(newContentDocumentLink);
                }
            }
                                                       
        }
        
      
        
        
            
        List<Database.SaveResult> ContactInsertResults = Database.INSERT(conList); 
        List<Id> convertedContactIds = new List<Id>();    
        for (Database.SaveResult result : ContactInsertResults) {
             if (result.isSuccess()) {
               convertedContactIds.add(result.getId());
           } else {
               System.debug('Error inserting contact: ' + result.getErrors()[0].getMessage());
           }
        }
        
        UPDATE recEvIdStatuses; 
        UPDATE UpdatedLeads;
        
        if (!contentDocumentLinksToInsert.isEmpty()) {
            for (ContentDocumentLink contentDocumentLink : contentDocumentLinksToInsert) {
                contentDocumentLink.LinkedEntityId = conList[0].Id; // Assigning LinkedEntityId
            }
            insert contentDocumentLinksToInsert;
        }
                          
    }       
    
    
    
       
    
    
    
    
     if (Trigger.isBefore && Trigger.isUpdate ) {
        
            List<Lead> AllLeads = [SELECT Id, Hiding_Sections__c FROM Lead]; 
            System.debug('AllLeads size: ' + AllLeads.size());
            Set<Id> UpdatedHidSecLeads = new Set<Id>();      
            for( Recruitment_Event__c recEventNew : trigger.new ){
                    for (Lead lead : AllLeads) {
                        if (lead.Id == recEventNew.Lead__c && lead.Hiding_Sections__c == True) {
                                                        
                            UpdatedHidSecLeads.add(lead.Id);
                             
                        }
                    }            
                                      
            }
            
            list<Lead> LeadsRestricted = [ Select Id From lead WHERE Id IN : UpdatedHidSecLeads ];
        
            List<Recruitment_Event__c> RecEventRstd = [ SELECT Id, Lead__c FROM Recruitment_Event__c WHERE Lead__c IN : UpdatedHidSecLeads ];
            List<String> errors = new List<String>();
            
           
            

            for ( Recruitment_Event__c R : RecEventRstd ) {
                 // Throw an error if someone tries to update the record
                 errors.add('Some recruitment event has already been converted to Physician Contact for this lead. Therefore, you cannot Update any Recruitment event related to this lead anymore. ');
                 System.debug('RO: ' + errors);
                
            } 
         
            if (!errors.isEmpty()) {
            Trigger.new[0].addError(errors[0]);
           }
                                            
    }  

    
     if (Trigger.isBefore && Trigger.isInsert) {
            List<Lead> AllLeads = [SELECT Id, Hiding_Sections__c FROM Lead]; 
            System.debug('AllLeads size: ' + AllLeads.size());
            Set<Id> UpdatedHidSecLeads = new Set<Id>();      
            for( Recruitment_Event__c recEventNew : trigger.new ){
                    for (Lead lead : AllLeads) {
                        if (lead.Id == recEventNew.Lead__c && lead.Hiding_Sections__c == True) {
                                                        
                            UpdatedHidSecLeads.add(lead.Id);
                             
                        }
                    }            
                                      
            }
        
            List<Recruitment_Event__c> RecEventRstd = [ SELECT Id, Lead__c FROM Recruitment_Event__c WHERE Lead__c IN : UpdatedHidSecLeads ];
            List<String> errors = new List<String>();

            for ( Recruitment_Event__c R : RecEventRstd ) {
                 // Throw an error if someone tries to update the record
                 errors.add('Some recruitment event has already been converted for this lead. Therefore, you cannot create another recruitment event for this Lead. Please note that there are certain restrictions in place that you need to follow.');
                 System.debug('RO: ' + errors);
                
            } 
         
            if (!errors.isEmpty()) {
            Trigger.new[0].addError(errors[0]);
           }
    } 
         
        /*
         Note that the addError() method can only be called on records in the 
         Trigger.new list during a before insert trigger event, which is why we're adding the error to the first record in the list.
        */
      
}