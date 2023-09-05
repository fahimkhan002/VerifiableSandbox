trigger TelecareIntegrationContactTrigger on Contact (AFTER INSERT, AFTER UPDATE) {

    String ConRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Physician').getRecordTypeId();
   
    Switch On Trigger.OperationType{
        
        When AFTER_INSERT{
            
            list<Contact> ContList = new list<Contact>();
            
            For(Contact con : Trigger.new){
                if( con.RecordTypeId == ConRecTypeId && con.Email != Null ){
                    ContList.add(con);
                }
            }
              
            TelecareIntegrationContactTriggerHandler.AFTER_INSERT( ContList, ContList[0] );
            //TelecareIntegrationContactTriggerHandler.AFTER_INSERT( trigger.new, trigger.new[0] );
            
        }
        
        When AFTER_UPDATE{
            
            
        }
    }
    
    
    
    
    
}