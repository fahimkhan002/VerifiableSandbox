@isTest
private class TestRecEventImplementation {

    static testMethod void testRecEventImplementation() {
        
        RecEventProdInactive__c cs = new RecEventProdInactive__c();
        cs.name = 'CheckActiveForTrigger';
        cs.isActive__c = true; 
        insert cs;
        
        // Create a test lead
        Lead lead = new Lead();
        lead.FirstName = 'John';
        lead.LastName = 'Doe';
        lead.Email = 'johndoe@example.com';
        lead.Status = 'Open';
        lead.Company = 'TeleSpecialists, LLC';
        insert lead;
        
        // Update the lead to trigger the RecEventImplementation trigger
        lead.Recruiter_Screen_Date__c = Date.today();
        lead.Scheduled_Screen_Date__c = Date.today();

        update lead;
        
        // Verify that a Recruitment Event was created
        List<Recruitment_Event__c> recEvents = [SELECT Id, Lead__c FROM Recruitment_Event__c WHERE Lead__c = :lead.Id];
        System.assertEquals(1, recEvents.size(), 'A recruitment event should have been created');
        System.assertEquals(lead.Id, recEvents[0].Lead__c, 'The recruitment event should be associated with the lead');
    }
}