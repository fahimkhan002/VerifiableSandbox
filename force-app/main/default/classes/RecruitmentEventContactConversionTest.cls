@isTest
private class RecruitmentEventContactConversionTest {

    @isTest static void testRecruitmentEventConversion() {
        
        RecEventProdInactive__c cs = new RecEventProdInactive__c();
        cs.name = 'CheckActiveForTrigger';
        cs.isActive__c = true; 
        insert cs;
        
        
        // Creating test account
        Account acc = new Account();
        acc.Name = 'TeleSpecialists, LLC';
        acc.Territory__c = 'East';
        insert acc;
        
        // Creating test lead
        Lead leadRec = new Lead();
        leadRec.FirstName = 'John';
        leadRec.LastName = 'Doe';
        leadRec.Company = 'TeleSpecialists, LLC';
        leadRec.Email = 'LeadJohn@tele.com';
        leadRec.Status = 'Lead';
        insert leadRec;       
        // Creating test content document FOr test lead 
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Content';
        cv.PathOnClient = 'test.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        insert cv;
        
        // Creating test content document link
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = leadRec.Id;
        cdl.ShareType = 'V';
        insert cdl;
        
        // Creating test recruitment event
        Recruitment_Event__c recEvent = new Recruitment_Event__c();
        recEvent.LastName__c = 'Doe';
        recEvent.FirstName__c = 'John';
        recEvent.MobilePhone__c = '1234567890';
        recEvent.Email__c = 'RecJohn@tele.com';
        recEvent.Lead__c = leadRec.Id;
        recEvent.Recruiter_Screen_Date__c = Date.today();
        recEvent.Partner_Screen__c = Date.today();
        recEvent.Interview_Date__c = Date.today();
        recEvent.Offered_Date__c = Date.today();
        recEvent.PSA_Review_Date__c = Date.today();
        recEvent.PSA_Sent_From_Legal__c = Date.today();
        recEvent.PSA_Option__c = 'PRN';
        
        insert recEvent;
        
        // Updating recruitment event to test conversion
        recEvent.Signed_Contract_Date__c = Date.today();
        update recEvent;
        
        // Retrieving converted contact
        Contact con = [SELECT Id, RecordTypeId, AccountId, LastName, FirstName FROM Contact WHERE RecruitmentEventId__c = :recEvent.Id];
        System.assertEquals('0125f000000AqEHAA0', con.RecordTypeId);
        //System.assertEquals(acc.Id, con.AccountId);
        System.assertEquals(recEvent.LastName__c, con.LastName);
        System.assertEquals(recEvent.FirstName__c, con.FirstName);
             
        // Retrieving updated lead
        Lead updatedLead = [SELECT Id, Hiding_Sections__c, Status FROM Lead WHERE Id = :leadRec.Id];
        System.assertEquals(true, updatedLead.Hiding_Sections__c);
        System.assertEquals('Recruitment Event Converted', updatedLead.Status);
    
        
        // Retrieving content document link for converted contact
        List<ContentDocumentLink> conContentDocLinks = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :con.Id];
        System.assertEquals(1, conContentDocLinks.size());
        System.assertEquals(con.Id, conContentDocLinks[0].LinkedEntityId);
        System.assertEquals(cdl.ContentDocumentId, conContentDocLinks[0].ContentDocumentId);
    }
}