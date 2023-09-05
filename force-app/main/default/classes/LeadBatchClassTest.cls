@isTest
private class LeadBatchClassTest {
    
    @isTest
    static void testBatchClass() {
        // Create test leads
         
        
        RecEventProdInactive__c cs = new RecEventProdInactive__c();
        cs.name = 'CheckActiveForTrigger';
        cs.isActive__c = true; 
        insert cs;
        
        List<Lead> testLeads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            Lead l = new Lead();
            l.FirstName = 'Test ' + i;
            l.LastName = 'Lead';
            l.Email = 'test' + i + '@example.com';
            l.Company = 'Test Company ' + i;
            l.Status = 'Open';
            testLeads.add(l);
        }
        insert testLeads;
        
        // Run batch job
        Test.startTest();
        LeadBatchClass batch = new LeadBatchClass();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify that test checkpoint field was updated for all leads
        List<Lead> updatedLeads = [SELECT Id, testCheckPoint__c FROM Lead];
        System.assertEquals(testLeads.size(), updatedLeads.size());
        for (Lead l : updatedLeads) {
            System.assertEquals(true, l.testCheckPoint__c);
        }
    }
}