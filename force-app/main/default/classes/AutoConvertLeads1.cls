Public class AutoConvertLeads1 
{        @InvocableMethod(label = 'Auto Convert Leads')
        public static void LeadAssign(List<Requests> requestList) {
           
        LeadStatus CLeadStatus= [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true Limit 1];    
        List<Database.LeadConvert> MassLeadconvert = new List<Database.LeadConvert>();   
            
        List<Database.LeadConvertResult> leadConvrtResult = new List<Database.LeadConvertResult>();
         for (Requests req: requestList){             
            Database.LeadConvert Leadconvert = new Database.LeadConvert();    
            Leadconvert.setLeadId(req.LeadId);
            Leadconvert.setAccountId(req.AccountId);                            
            Leadconvert.setConvertedStatus(CleadStatus.MasterLabel);             
            Leadconvert.setDoNotCreateOpportunity(TRUE); //Remove this line if you want to create an opportunity from Lead Conversion  
            MassLeadconvert.add(Leadconvert);    
        }                  
        if (!MassLeadconvert.isEmpty())
        {            
            leadConvrtResult = Database.convertLead(MassLeadconvert);       
        }
            
              // Retrieve the converted contacts using the leadConvrtResult variable
                    List<Id> convertedContactIds = new List<Id>();
                    for (Database.LeadConvertResult result : leadConvrtResult) {
                        if (result.isSuccess()) {
                            convertedContactIds.add(result.getContactId());
                        }
                    }
                    List<Contact> convertedContacts = [SELECT Id, RecordTypeId FROM Contact WHERE Id IN :convertedContactIds];
        
        
         
            // Set the Contact Record Type for the converted Contact records
            // Id contactRecordTypeId = '012XXXXXXXXXXXX';
            String contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Physician').getRecordTypeId();
        
            for (Contact contact : convertedContacts) {
                contact.RecordTypeId = contactRecordTypeId;
            }
        
            update convertedContacts;
            
            
            
    } 
    
      public class Requests {
       @InvocableVariable(label = 'LeadId' required = true)
       public id LeadId;
       
       @InvocableVariable(label = 'AccountId' required = false)
       public Id AccountId;
    
}
}