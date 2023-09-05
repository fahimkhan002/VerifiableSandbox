trigger RecEventImplementation on Lead (AFTER UPDATE) {

    
    
   map<string, RecEventProdInactive__c> checkActive = RecEventProdInactive__c.getAll();
    
    if(checkActive.get('CheckActiveForTrigger').isActive__c){
       
        if( trigger.isAfter && trigger.isUpdate){
             
        String LeadRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Recruiting').getRecordTypeId();
     
        
        list<Recruitment_Event__c> recEvList = new list<Recruitment_Event__c>();
        
        for( Lead lead : Trigger.new ){
            if( lead.Recruiter_Screen_Date__c != null || lead.In_Patient_Experience__c != null 
               || lead.Grade_Explanation_other__c != null || lead.Grade_Detail__c != null || lead.Synopsis_Of_Opportunity__c != null 
               || lead.States__c != null || lead.communication_score__c != null || lead.Citizenship_Status__c != null || lead.Thrombolytic_Experience__c != null
               || lead.Physician_Reads_EEGs__c != null
               && lead.IsConverted != true && lead.Status != 'Converted' && lead.RecordTypeId == LeadRecordTypeId ){
                
                Recruitment_Event__c recEv = new Recruitment_Event__c();
                
                //NoSection Fields   
                recEv.Title__c = lead.Title;
                recEv.CreatedById = lead.CreatedById;
                
                //Information Section Data
                recEv.HasOptedOutOfEmail__c = lead.HasOptedOutOfEmail;
                recEv.Salutation__c = lead.Salutation;
                recEv.FirstName__c = lead.FirstName;
                recEv.LastName__c = lead.LastName;
                recEv.Lead__c = lead.Id;
                recEv.Specialty__c = lead.Specialty__c;
                recEv.OwnerId = lead.OwnerId;
                recEv.Notes_Lead_info__c = lead.Notes_Lead_info__c;
                recEv.MobilePhone__c = lead.MobilePhone; 
                recEv.Email__c = lead.Email;
                   
                   
                //Recruiter Screen Date   
                recEv.Recruiter_Screen_Date__c = lead.Recruiter_Screen_Date__c;
                recEv.Board_Certified__c = lead.Board_Certified__c;
                recEv.Fellowship_Subspeciality__c = lead.Fellowship_Subspeciality__c;
                recEv.Daily_Volumes__c = lead.Daily_Volumes__c;
                recEv.Grade__c = lead.Grade__c;
                recEv.Grade_Detail__c = lead.Grade_Detail__c;
                recEv.Grade_Explanation_other__c = lead.Grade_Explanation_other__c;
                recEv.Synopsis_Of_Opportunity__c = lead.Synopsis_Of_Opportunity__c;
               	recEv.In_Patient_Experience__c = lead.In_Patient_Experience__c;
                recEv.States__c = lead.States__c;
                recEv.Communication_Score__c = lead.Communication_Score__c;
                recEv.Citizenship_Status__c = lead.Citizenship_Status__c;
                recEv.Thrombolytic_Experience__c = lead.Thrombolytic_Experience__c;
                recEv.Physician_Reads_EEGs__c = lead.Physician_Reads_EEGs__c;
                recEv.Sales_Lead__c = lead.Sales_Lead__c;
                recEv.Sales_Summary__c = lead.Sales_Summary__c;
               	recEv.Scheduled_Screen_Date__c = lead.Scheduled_Screen_Date__c;
                   
                   
                //Partner Section
                recEv.Partner_Screen__c = lead.Partner_Screen__c;
                //recEv.Partner_Screen_Submitted__c = lead.Partner_Screen_Submitted__c;
                   
                   
                //Interview Section   
                recEv.Interview_Email_1__c = lead.Interview_Email_1__c;
                recEv.Interview_Email_2__c = lead.Interview_Email_2__c;
                recEv.Interview_Email_3__c = lead.Interview_Email_3__c;
                recEv.Interview_Email_4__c = lead.Interview_Email_4__c;                                              
                recEv.Interview_Date__c = lead.Interview_Date__c;
                recEv.Physician_Paused_Prior_Interview__c = lead.Physician_Paused_Prior_Interview__c;
                recEv.Interview_Notes__c = lead.Interview_Notes__c;
                            
                
  				//Post Interview
  				recEv.PSA_Option__c = lead.PSA_Option__c;
                recEv.EN_Monthly_Shifts__c = lead.EN_Monthly_Shifts__c;
                recEv.TNH_Monthly_Shifts__c = lead.TNH_Monthly_Shifts__c;
                recEv.PSA_Review_Email_1__c = lead.PSA_Review_Email_1__c;
                recEv.PSA_Review_Email_2__c = lead.PSA_Review_Email_2__c;
                recEv.PSA_Review_Email_3__c = lead.PSA_Review_Email_3__c;
                recEv.PSA_Review_Email_4__c = lead.PSA_Review_Email_4__c;
                recEv.Post_PSA_Review_F_U__c= lead.Post_PSA_Review_F_U__c;
                recEv.Post_PSA_Review_F_U_2__c = lead.Post_PSA_Review_F_U_2__c;
                recEv.Post_PSA_Review_F_U_3__c= lead.Post_PSA_Review_F_U_3__c;
                recEv.Physician_Paused_Post_interview__c = lead.Physician_Paused_Post_interview__c;
                recEv.Offered_Date__c = lead.Offered_Date__c;
                recEv.PSA_Sent_From_Legal__c = lead.PSA_Sent_From_Legal__c;
                recEv.PSA_Review_Date__c = lead.PSA_Review_Date__c;
                recEv.Signed_Contract_Date__c = lead.Signed_Contract_Date__c;
				recEv.Maintain_Contact__c = lead.Maintain_Contact__c;
                recEv.Reasons_For_Execution_Failure__c = lead.Reasons_For_Execution_Failure__c;
                recEv.Reason_For_Execution_Failure_other__c = lead.Reason_For_Execution_Failure_other__c;   
               	recEv.Notes__c = lead.Notes__c;
                
               
                ///Status Check
                if ( lead.Status == 'Nurture' || lead.Status == 'Un-Qualified'  ) {
                     recEv.Recruitment_Event_Status__c = lead.Status;
                }else {
                    recEv.Recruitment_Event_Status__c = '';
                }

                
                recEvList.add(recEv);
 
                   
            }
        } 
        
        
        List<Database.SaveResult> RecEventInsertResults = Database.INSERT(recEvList); 
        List<Id> InsertRecEventIds = new List<Id>();    
        for (Database.SaveResult result : RecEventInsertResults) {
             if (result.isSuccess()) {
               InsertRecEventIds.add(result.getId());
               System.debug( InsertRecEventIds );
           } else {
               System.debug('Error inserting RecEvents: ' + result.getErrors()[0].getMessage());
           }
        }
        
      
    }
        

        
    }         
}