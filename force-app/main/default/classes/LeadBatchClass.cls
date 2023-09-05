public class LeadBatchClass implements Database.Batchable<Sobject> {

    public database.QueryLocator start(Database.BatchableContext bc){
        
    return database.getQueryLocator('SELECT Id, FirstName, LastName, Email, Company, Status,  testCheckPoint__c FROM Lead ');
        
    }
    
    public void execute(Database.BatchableContext bc, list<Lead> subLeadlstFromStartMethod){
         
        list<lead> leadsList = new list<lead>();
        for ( Lead lead : subLeadlstFromStartMethod ){
            lead.testCheckPoint__c = True;
            leadsList.Add(lead);
        }
        Update leadsList;
    
    }
    
    public void finish(Database.BatchableContext bc){
        
    system.debug('The operations are completed');
        
    }

}