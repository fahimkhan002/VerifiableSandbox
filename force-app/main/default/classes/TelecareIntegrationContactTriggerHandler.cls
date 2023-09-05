public class TelecareIntegrationContactTriggerHandler {

    public static void AFTER_INSERT( list<Contact> Newcontlist, contact contct){
        
        TelecareIntegrationContactTriggerCallout telecareCallIntnse = new TelecareIntegrationContactTriggerCallout( Newcontlist, contct );
        system.enqueueJob(telecareCallIntnse);
    }
    
    public static void AFTER_UPDATE(){
        // After update operations
    }
    
    
}