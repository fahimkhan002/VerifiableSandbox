@isTest
public class DisclosureQuestionTriggerHandlerTest {
	
    @isTest static void createProviderDisclosureAnswerTest() {
        verifiable__Disclosure_Question__c dqRecord = new verifiable__Disclosure_Question__c();
        
        
        String data_JSON = '[{"Response":"No","Needs_Review__c":false,"Answer__c":"","Description":"","Name":"Chemical Substances: Do you use any chemical substances that would in any way impair or limit your ability to practice medicine and perform the functions of your job with reasonable skill and safety?"},{"Response":"Yes","Needs_Review__c":true,"Answer__c":"asdfasdf","Description":"","Name":"Pose a Risk: Do you have any reason to believe that you would pose a risk to the safety or well being of your patients?"},{"Response":"Yes","Needs_Review__c":true,"Answer__c":"asdf","Description":"","Name":"Unable to Perform Essential Functions: Are you unable to perform the essential functions of a practitioner in your area of practice even with reasonable accommodation?"}]'; 
        dqRecord.verifiable_ext__VFY_Data__c = data_JSON;
        dqRecord.Name = 'test question set';
        
		List<verifiable__Disclosure_Question__c> dqList = new List<verifiable__Disclosure_Question__c>();
        dqList.add(dqRecord);
        
        DisclosureQuestionTriggerHandler.createProviderDisclosureAnswer(dqList);
        
    }
}