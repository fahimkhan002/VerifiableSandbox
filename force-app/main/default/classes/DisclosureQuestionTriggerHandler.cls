public class DisclosureQuestionTriggerHandler {

    public static void createProviderDisclosureAnswer(List<verifiable__Disclosure_Question__c> questionList) {
		
		// List that will be used to insert ProviderDisclosureAnswer Records
		List<Provider_Disclosure_Answer__c> answerList = new List<Provider_Disclosure_Answer__c>();
        
        for (verifiable__Disclosure_Question__c iter : questionList) { 

            // assigns the JSON within the DiscAnswer record to a strnig to be parsed
            String Q_JSON = iter.verifiable_ext__VFY_Data__c;
            
            // Parse entire JSON argument
            JSONParser parser = JSON.createParser(Q_JSON);        
            While (parser.nextToken() != null ) {
                // Start at the array of responses
                if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                     while (parser.nextToken() != null) {
                         // Advance to the start object marker to find next answer record.
                        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                            // Read entire answer json object and put into a Provider_Disclosure_Answer__c record
                            Provider_Disclosure_Answer__c answer = (Provider_Disclosure_Answer__c)parser.readValueAs(Provider_Disclosure_Answer__c.class);
                            // add to insert list if it needs review
                            if (answer.Needs_Review__c == true) {
                                answer.Disclosure_Question__c = iter.Id;
                                answer.Provider__c = iter.verifiable__Provider__c;
                                answer.Question__c = answer.Name;
                                answer.Name = answer.Name.substring(0,80);
                                answer.Response__c = 'Yes';
                                answerList.add(answer);
                            }
                        }
                    }
                }
            } 		
        }  
		insert answerList;
	}
}