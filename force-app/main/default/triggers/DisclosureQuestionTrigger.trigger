trigger DisclosureQuestionTrigger on verifiable__Disclosure_Question__c (before insert, after insert) {
    
    if (Trigger.isInsert && Trigger.isAfter) {
        DisclosureQuestionTriggerHandler.createProviderDisclosureAnswer(Trigger.new);
    }
}