public class CreateOnboardingForm {
            
    // CV Format options = 'doc;docx;pdf;png;img'. Remove any that you would not like
    public static String FILE_UPLOAD_FORMATS = 'doc;docx;pdf;png;img';
    
    public static verifiable_ext__VFY_Verifiable_Form__c onboardingForm;
    public static Map <String,Id> recordTypeMap = new Map<String,Id>();
    public static List<verifiable_ext__VFY_Verifiable_Field__c> fieldsToInsert;
    
    public static void createForm(){
        // Name for the entire form
        String FORM_NAME = 'Standard Intake Questionnaire';

        List<verifiable_ext__VFY_Verifiable_Form__c> listForms = [SELECT Id FROM verifiable_ext__VFY_Verifiable_Form__c WHERE Name = :FORM_NAME];
        if (listForms.size() > 0) return;
        
        // Create list to store fields for insert at the end of the script
        fieldsToInsert = new List<verifiable_ext__VFY_Verifiable_Field__c>();
        
        // Query and store Section Record Type Id's for use in the Create Section methods
        List<RecordType> rt_list = [SELECT Id,Name FROM RecordType WHERE SobjectType='verifiable_ext__VFY_Verifiable_Section__c'];
        
        for (RecordType iter : rt_list ) {
            recordTypeMap.put(iter.Name, iter.id);
        }
        
        /* Create Main Onboarding Form */
        onboardingForm = new verifiable_ext__VFY_Verifiable_Form__c();
        onboardingForm.name = FORM_NAME;
        onboardingForm.verifiable_ext__VFY_Object__c = 'Contact';
        onboardingForm.verifiable_ext__VFY_Active__c = true;
        
        insert onboardingForm;
        
        
        
        // Initiating variables be reused as arguments for the createRecordListSection method
        String name_arg;
        String title_arg;
        String numOfColumns_arg;
        String description_arg;
        Boolean fileUpload_arg;
        Double order_arg;
        String recordTypeName_arg;
        String listObject_arg;
        String listObjParentField_arg;
        
        
        /* Create Section 1  - Get Started*/
        /********************/
        name_arg = 'Get Started';
        title_arg = 'Get Started';
        numOfColumns_arg = '2';
        description_arg = '<p>Please provide the following information.</p>';
        fileUpload_arg = false;
        order_arg = 1;
        recordTypeName_arg = 'Record';
        listObject_arg = null;
        listObjParentField_arg = null;
        
        verifiable_ext__VFY_Verifiable_Section__c getStartedSection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('Email', 'Email', 1, false, getStartedSection.id);
        createField('Phone', 'Phone', 2, false, getStartedSection.id);
        createField('First Name', 'FirstName', 3, false, getStartedSection.id);
        createField('Last Name', 'LastName', 4, true, getStartedSection.id);
        createField('NPI', 'NPI_Number__c', 6, false, getStartedSection.id);
        createField('Date of Birth', 'Birthdate', 7, false, getStartedSection.id);
        
        
        /* Create Section 2 - CAQH */
        /********************/
        name_arg = 'CAQH';
        title_arg = 'CAQH';
        numOfColumns_arg = '2';
        description_arg = '<p>CAQH Info</p><p><br></p><p>Please note: If you provide your CAQH login info, you do not need to fill out any additional info past this page. </p>';
        fileUpload_arg = false;
        order_arg = 2;
        recordTypeName_arg = 'Record';
        
        verifiable_ext__VFY_Verifiable_Section__c CAQH_Section = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('CAQH Username', 'CAQH_Username__c', 1, false, CAQH_Section.id);
        createField('CAQH Password', 'CAQH_Password__c', 2, false, CAQH_Section.id);
        createField('CAQH ID', 'CAQH_ID__c', 3, false, CAQH_Section.id);
        
        
        /* Create Section 3 - Basic Information  */
        /****************************************/
        name_arg = 'Basic Information';
        title_arg = 'Basic Information';
        numOfColumns_arg = '2';
        description_arg = '<p>Please provide the following information. </p>';
        fileUpload_arg = false;
        order_arg = 3;
        recordTypeName_arg = 'Record';
        
        verifiable_ext__VFY_Verifiable_Section__c basicInfoSection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('Social Security Number', 'Social_Security_Number__c', 1, false, basicInfoSection.id);
        createField('Languages Spoken', 'Languages__c', 2, false, basicInfoSection.id);
        createField('Street Address', 'MailingStreet', 3, false, basicInfoSection.id);
        createField('City', 'MailingCity', 4, false, basicInfoSection.id);
        createField('State', 'MailingState', 5, false, basicInfoSection.id);
        createField('Zip Code', 'MailingPostalCode', 6, false, basicInfoSection.id);
        
        
        
        /* Create Section 4 - Basic Information  */
        /****************************************/
        name_arg = 'Licenses';
        title_arg = 'Licenses';
        numOfColumns_arg = '2';
        description_arg = '<p>Please provide relevant license info. </p>';
        fileUpload_arg = false;
        order_arg = 4;
        recordTypeName_arg = 'Record';
        listObject_arg = null;
        listObjParentField_arg = null;
        
        verifiable_ext__VFY_Verifiable_Section__c licenseSection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('License State', 'Jurisdiction_State__c', 1, false, licenseSection.id);
        createField('License Number', 'License_Number__c', 2, false, licenseSection.id);
        createField('License Type', 'License_Type_ID__c', 3, false, licenseSection.id);
        createField('Primary License', 'Primary_License__c', 4, false, licenseSection.id);
        
        
        /* Create Section 5 - DEA Registration  */
        /****************************************/
        name_arg = 'DEA Registration';
        title_arg = 'DEA Registration';
        numOfColumns_arg = '2';
        description_arg = '<p>DEA Registration Number</p>';
        fileUpload_arg = false;
        order_arg = 5;
        recordTypeName_arg = 'Record';
        listObject_arg = null;
        listObjParentField_arg = null;
        
        verifiable_ext__VFY_Verifiable_Section__c DEA_Section = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('DEA Registration Number', 'Name', 1, false, DEA_Section.id);
        
        
        /* Create Section 6 - Specialties  */
        /****************************************/
        name_arg = 'Specialties';
        title_arg = 'Specialties';
        numOfColumns_arg = '2';
        description_arg = '<p>Please enter your Board Certification information.</p>';
        fileUpload_arg = false;
        order_arg = 6;
        recordTypeName_arg = 'List';
        listObject_arg = 'Board_Certification__c';
        listObjParentField_arg = 'Provider__c';
        
        verifiable_ext__VFY_Verifiable_Section__c boardCertSection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('Board Certification Number', 'Certification_Number__c', 1, false, boardCertSection.id);
        createField('Board Certification Name', 'Name', 2, false, boardCertSection.id);
        createField('Primary License?', 'IsPrimary__c', 3, false, boardCertSection.id);
        
        
        
        /* Create Section 7 - Education & Experience  */
        /****************************************/
        name_arg = 'Education & Experience';
        title_arg = 'Education & Experience';
        numOfColumns_arg = '2';
        description_arg = '<p>Education information</p>';
        fileUpload_arg = false;
        order_arg = 7;
        recordTypeName_arg = 'List';
        listObject_arg = 'verifiable__Education__c';
        listObjParentField_arg = 'verifiable__Provider__c';
        
        verifiable_ext__VFY_Verifiable_Section__c educationSection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('Education Type', 'verifiable__GraduateType__c', 1, false, educationSection.id);
        createField('Degree Awarded', 'verifiable__Degree__c', 2, false, educationSection.id);
        createField('Start Date', 'verifiable__StartDate__c', 3, false, educationSection.id);
        createField('End Date', 'verifiable__EndDate__c', 4, false, educationSection.id);
        createField('Graduated', 'verifiable__Completed__c', 5, false, educationSection.id);
        createField('I have an ECFMG number', 'verifiable__EcfmgNumber__c', 6, false, educationSection.id);
        createField('ECFMG Issue Date', 'verifiable__EcfmgIssueDate__c', 7, false, educationSection.id);
        
        
        /* Create Section 8 - Training  */
        /****************************************/
        name_arg = 'Training';
        title_arg = 'Training';
        numOfColumns_arg = '2';
        description_arg = '<p>Training Info</p>';
        fileUpload_arg = false;
        order_arg = 8;
        recordTypeName_arg = 'List';
        listObject_arg = 'verifiable__Training__c';
        listObjParentField_arg = 'verifiable__Provider__c';
        
        verifiable_ext__VFY_Verifiable_Section__c trainingSection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('Training Type', 'verifiable__TrainingType__c', 1, false, trainingSection.id);
        createField('Institution Name', 'Name', 2, false, trainingSection.id);
        createField('School Name', 'verifiable__SchoolName__c', 3, false, trainingSection.id);
        createField('Start Date', 'verifiable__StartDate__c', 4, false, trainingSection.id);
        createField('End Date', 'verifiable__EndDate__c', 5, false, trainingSection.id);
        createField('Completed?', 'verifiable__Completed__c', 6, false, trainingSection.id);
        
        
        
        
        /* Create Section 9 - Work History  */
        /****************************************/
        name_arg = 'Work History';
        title_arg = 'Work History';
        numOfColumns_arg = '2';
        description_arg = '<p>Please provide work history information.</p>';
        fileUpload_arg = false;
        order_arg = 9;
        recordTypeName_arg = 'List';
        listObject_arg = 'verifiable__WorkHistory__c';
        listObjParentField_arg = 'verifiable__Provider__c';
        
        verifiable_ext__VFY_Verifiable_Section__c workHistorySection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('Type', 'verifiable__Type__c', 1, false, workHistorySection.id);
        createField('WorkHistory Name', 'Name', 2, false, workHistorySection.id);
        createField('Job Title', 'verifiable__JobTitle__c', 3, false, workHistorySection.id);
        createField('Start Date', 'verifiable__StartDate__c', 4, false, workHistorySection.id);
        createField('Is Current Employer?', 'verifiable__IsCurrentEmployer__c', 5, false, workHistorySection.id);
        createField('Address Line 1', 'verifiable__AddressLine1__c', 6, false, workHistorySection.id);
        createField('Address Line 2', 'verifiable__AddressLine2__c', 7, false, workHistorySection.id);
        createField('City', 'verifiable__AddressCity__c', 8, false, workHistorySection.id);
        createField('State', 'verifiable__AddressState__c', 9, false, workHistorySection.id);
        createField('Address Zip', 'verifiable__AddressZip__c', 10, false, workHistorySection.id);
        createField('Departure Reason', 'verifiable__DepartureReason__c', 11, false, workHistorySection.id);
        
        
        
        /* Create Section 10 - CV Upload Section  */
        /****************************************/
        name_arg = 'CV';
        title_arg = 'CV';
        description_arg = '<p>Please upload your CV</p>';
        order_arg = 10;
        
        //String name, String title, String numOfColumns, String description, Double order
        verifiable_ext__VFY_Verifiable_Section__c CV_Section = createFileSection(name_arg,title_arg,description_arg,order_arg);
        
        
        
        /* Create Section 11 - Liability Insurance  */
        /****************************************/
        name_arg = 'Liability Insurance';
        title_arg = 'Liability Insurance';
        numOfColumns_arg = '2';
        description_arg = '<p>Please provide the following information.</p>';
        fileUpload_arg = true;
        order_arg = 11;
        recordTypeName_arg = 'List';
        listObject_arg = 'verifiable__LiabilityInsurance__c';
        listObjParentField_arg = 'verifiable__Provider__c';
        
        verifiable_ext__VFY_Verifiable_Section__c liabilityInsuranceSection = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg, listObject_arg, listObjParentField_arg);
        
        // Create fields for Section
        createField('Coverage Type', 'verifiable__CoverageType__c', 1, false, liabilityInsuranceSection.id);
        createField('Carrier Name', 'Name', 2, false, liabilityInsuranceSection.id);
        createField('Policy Number', 'verifiable__PolicyNumber__c', 3, false, liabilityInsuranceSection.id);
        createField('Is Self Insured', 'verifiable__IsSelfInsured__c', 4, false, liabilityInsuranceSection.id);
        createField('Original Effective Date', 'verifiable__OriginalEffectiveDate__c', 5, false, liabilityInsuranceSection.id);
        createField('Current Effective Date', 'verifiable__CurrentEffectiveDate__c', 6, false, liabilityInsuranceSection.id);
        createField('Current Expiration Date', 'verifiable__CurrentExpirationDate__c', 7, false, liabilityInsuranceSection.id);
        createField('Unlimited Coverage?', 'verifiable__isUnlimitedCoverage__c', 8, false, liabilityInsuranceSection.id);
        createField('Includes Tail Coverage?', 'verifiable__PolicyIncludesTailCoverage__c', 9, false, liabilityInsuranceSection.id);
        createField('Occurrence Coverage Amount', 'verifiable__OccurrenceCoverageAmount__c', 10, false, liabilityInsuranceSection.id);
        createField('Aggregate Coverage Amount', 'verifiable__AverageCoverageAmount__c', 11, false, liabilityInsuranceSection.id);
        
        
        
        
        /* Insert all fields created above from all sections (Record/List/File Sections) */
        /*****************************************************/
        insert fieldsToInsert;
        
        /* Create Section 12 - Questions  */
        /****************************************/
        name_arg = 'Disclosure Questions';
        title_arg = 'Disclosure Questions';
        description_arg = '<p>Please answer the following questions.</p>';
        order_arg = 12;
        
        verifiable_ext__VFY_Verifiable_Section__c questionSection = createQuestionSection(name_arg, title_arg, description_arg, order_arg);
        
        // List of questions for record creation
        // ask Andrei about lines that start with with "Illegal Misconduct Within" and 'Felony: Have you....', "Misdemeanor in the Past Ten Years"
        List<String> questionList = new List<String>{
            'License Limitations: Has your license, registration or certification to practice in your profession, ever been voluntarily or involuntarily relinquished, denied, suspended, revoked, restricted, or have you ever been subject to a fine, reprimand, consent order, probation or any conditions or limitations by any state or professional licensing, registration or certification board?',
            'License Challenge: Has there been any challenge to your licensure, registration or certification?',
            'Clinical Privileges Limitations: Have your clinical privileges or medical staff membership at any hospital or healthcare institution, voluntarily or involuntarily, ever been denied, suspended, revoked, restricted, denied renewal or subject to probationary or to other disciplinary conditions (for reasons other than non-completion of medical record when quality of care was not adversely affected) or have proceedings toward any of those ends been instituted or recommended by any hospital or healthcare institution, medical staff or committee, or governing board?',
            'Privileges While Under Investigation: Have you voluntarily or involuntarily surrendered, limited your privileges or not reapplied for privileges while under investigation?',
            'Terminated or Not Renewed for Cause: Have you ever been terminated for cause or not renewed for cause from participation, or been subject to any disciplinary action, by any managed care organizations (including HMOs, PPOs, or provider organizations such as IPAs, PHOs)?',
            'Training Program Discipline: Were you ever placed on probation, disciplined, formally reprimanded, suspended or asked to resign during an internship, residency, fellowship, preceptorship or other clinical education program? If you are currently in a training program, have you been placed on probation, disciplined, formally reprimanded, suspended or asked to resign?',
            'Training Program While Under Investigation: Have you ever, while under investigation or to avoid an investigation, voluntarily withdrawn or prematurely terminated your status as a student or employee in any internship, residency, fellowship, preceptorship, or other clinical education program?',
            'Board Certification Revoked: Have any of your board certifications or eligibility ever been revoked?',
            'Board Certification While Under Investigation: Have you ever chosen not to re-certify or voluntarily surrendered your board certification(s) while under investigation?',
            'DEA/CDS Limitations: Have your Federal DEA and/or State Controlled Dangerous Substances (CDS) certificate(s) or authorization(s) ever been challenged, denied, suspended, revoked, restricted, denied renewal, or voluntarily or involuntarily relinquished?',
            'Medicare or Medicaid Limitations: Have you ever been disciplined, excluded from, debarred, suspended, reprimanded, sanctioned, censured, disqualified or otherwise restricted in regard to participation in the Medicare or Medicaid program, or in regard to other federal or state governmental healthcare plans or programs?',
            'Subject of an Investigation: Are you currently the subject of an investigation by any hospital, licensing authority, DEA or CDS authorizing entities, education or training program, Medicare or Medicaid program, or any other private, federal or state health program or a defendant in any civil action that is reasonably related to your qualifications, competence, functions, or duties as a medical professional for alleged fraud, an act of violence, child abuse or a sexual offense or sexual misconduct?',
            'Reported to NPDB/HIPDB: To your knowledge, has information pertaining to you ever been reported to the National Practitioner Data Bank or Healthcare Integrity and Protection Data Bank?',
            'Sanctions: Have you ever received sanctions from or are you currently the subject of investigation by any regulatory agencies (e.g., CLIA, OSHA, etc.)?',
            'Illegal Misconduct Within the Last Ten Years: Have you ever been convicted of, pled guilty to, pled nolo contendere to, sanctioned, reprimanded, restricted, disciplined or resigned in exchange for no investigation or adverse action within the last ten years for sexual harassment or other illegal misconduct?',
            'Military Agency Limitations: Are you currently being investigated or have you ever been sanctioned, reprimanded, or cautioned by a military hospital, facility, or agency, or voluntarily terminated or resigned while under investigation or in exchange for no investigation by a hospital or healthcare facility of any military agency?',
            'Liability Coverage Limitations: Has your professional liability coverage ever been cancelled, restricted, declined or not renewed by the carrier based on your individual liability history.',
            'Surcharge or High-risk: Have you ever been assessed a surcharge, or rated in a high-risk class for your specialty, by your professional liability insurance carrier, based on your individual liability history?',
            'Professional Liability Actions Within the Past Ten Years: Have you had any professional liability actions (pending, settled, arbitrated, mediated or litigated) within the past 10 years?* If yes, provide information for each case',
            'Felony: Have you ever been convicted of, pled guilty to, or pled nolo contendere to any felony?',
            'Misdemeanor in the Past Ten Years: In the past ten years have you been convicted of, pled guilty to, or pled nolo contendere to any misdemeanor (excluding minor traffic violations) or been found liable or responsible for any civil offense that is reasonably related to your qualifications, competence, functions, or duties as a medical professional, or for fraud, an act of violence, child abuse or a sexual offense or sexual misconduct?',
            'Court Martialed: Have you ever been court martialed for actions related to your duties as a medical professional?',
            'Illegal Drugs: Are you currently engaged in the illegal use of drugs?* (\'Currently\' means sufficiently recent to justify a reasonable belief that the use of drugs may have an ongoing impact on one\'s ability to practice medicine. It is not limited to the day of, or within a matter of days or weeks before the date of application, rather that it has occurred recently enough to indicate the individual is actively engaged in such conduct. \'Illegal use of drugs\' refers to drugs whose possession or distribution is unlawful under the Controlled Substances Act, 21 U.S.C. § 812.22.It \'does not include the use of a drug taken under supervision by a licensed health care professional, or other uses authorized by the Controlled Substances Act or other provision of Federal law.\'The term does include, however, the unlawful use of prescription controlled substances.)',
            'Chemical Substances: Do you use any chemical substances that would in any way impair or limit your ability to practice medicine and perform the functions of your job with reasonable skill and safety?',
            'Pose a Risk: Do you have any reason to believe that you would pose a risk to the safety or well being of your patients?',
            'Unable to Perform Essential Functions: Are you unable to perform the essential functions of a practitioner in your area of practice even with reasonable accommodation?'};
        
        Integer questionNumner = 1;
        List<verifiable_ext__VFY_Verifiable_Question__c> questionRecordList = new List<verifiable_ext__VFY_Verifiable_Question__c>();
        
        for (String iter : questionList) {
            verifiable_ext__VFY_Verifiable_Question__c tmpQuestionRecord = new verifiable_ext__VFY_Verifiable_Question__c();
        
            tmpQuestionRecord.verifiable_ext__VFY_Question__c = iter;
            tmpQuestionRecord.verifiable_ext__VFY_Order__c = questionNumner;
            tmpQuestionRecord.verifiable_ext__VFY_Verifiable_Section__c = questionSection.id;
        
            questionRecordList.add(tmpQuestionRecord);
        
            questionNumner++;
        }
        
        insert questionRecordList;
        
        
        
        
        
        /*
        Template for new section 
        
        name_arg = '';
        title_arg = '';
        numOfColumns_arg = '2';
        description_arg = '<p></p>';
        fileUpload_arg = false;
        order_arg = XXXX;
        recordTypeName_arg = 'List' 'Record';
        listObject_arg = '';
        listObjParentField_arg = '';
        
        verifiable_ext__VFY_Verifiable_Section__c XXXXX_Section = createRecordListSection(name_arg, title_arg, numOfColumns_arg, description_arg, fileUpload_arg, order_arg, recordTypeName_arg);
        
        // Create fields for Section
        createField('', '', 1, false, XXX.id);
        createField('', '', 2, false, XXX.id);
        createField('', '', 3, false, XXX.id);
        createField('', '', 4, false, XXX.id);
        createField('', '', 5, false, XXX.id);
        createField('', '', 6, false, XXX.id);
        createField('', '', 7, false, XXX.id);
        createField('', '', 8, false, XXX.id);
        createField('', '', 9, false, XXX.id);
        createField('', '', 10, false, XXX.id);
        */
    }
    
    // creates a new Form Section record and returns the inserted record. The returned Section Record is used to assign the ID for the Form Field records created under the section
    public static verifiable_ext__VFY_Verifiable_Section__c createRecordListSection(String name, String title, String numOfColumns, String description, Boolean fileUpload, Double order, String recordTypeName, String listObject, String listObjParentField) {
        verifiable_ext__VFY_Verifiable_Section__c tmpSection = new verifiable_ext__VFY_Verifiable_Section__c();
        tmpSection.Name = name;
        tmpSection.verifiable_ext__VFY_Title__c = title;
        tmpSection.verifiable_ext__VFY_Columns__c = numOfColumns;
        tmpSection.verifiable_ext__VFY_Description__c = description;
        tmpSection.verifiable_ext__VFY_File_Upload__c = fileUpload;
        tmpSection.verifiable_ext__VFY_Order__c = order;
        tmpSection.verifiable_ext__VFY_Order_By__c = 'CreatedDate DESC';
        tmpSection.verifiable_ext__VFY_Verifiable_Form__c = onboardingForm.Id;
        tmpSection.verifiable_ext__VFY_Object__c = 'Contact';
        tmpSection.RecordTypeId = recordTypeMap.get(recordTypeName);
        
        if (recordTypeName == 'List') {
            tmpSection.verifiable_ext__VFY_Object__c = listObject;
            tmpSection.verifiable_ext__VFY_Parent_Field_Api_Name__c = listObjParentField;
            
        }
        
        if (fileUpload == true) {
            tmpSection.verifiable_ext__VFY_Accepted_Formats__c = FILE_UPLOAD_FORMATS;
        }
        
        insert tmpSection;
        
        return tmpSection;
        
    }
    
    public static verifiable_ext__VFY_Verifiable_Section__c createFileSection(String name, String title, String description, Double order) {
        
        verifiable_ext__VFY_Verifiable_Section__c tmpSection = new verifiable_ext__VFY_Verifiable_Section__c();
        tmpSection.Name = name;
        tmpSection.verifiable_ext__VFY_Title__c = title;
        tmpSection.verifiable_ext__VFY_Description__c = description;
        tmpSection.verifiable_ext__VFY_Order__c = order;
        tmpSection.verifiable_ext__VFY_Order_By__c = 'CreatedDate DESC';
        tmpSection.verifiable_ext__VFY_Verifiable_Form__c =  onboardingForm.Id;
        tmpSection.verifiable_ext__VFY_Accepted_Formats__c = FILE_UPLOAD_FORMATS;
        tmpSection.RecordTypeId = recordTypeMap.get('File');
        
        insert tmpSection;
        
        return tmpSection;
    }
    
    
    public static verifiable_ext__VFY_Verifiable_Section__c createQuestionSection(String name, String title, String description, Double order) {
        verifiable_ext__VFY_Verifiable_Section__c tmpSection = new verifiable_ext__VFY_Verifiable_Section__c();
        tmpSection.Name = name;
        tmpSection.verifiable_ext__VFY_Title__c = title;
        tmpSection.verifiable_ext__VFY_Description__c = description;
        tmpSection.verifiable_ext__VFY_Order__c = order;
        tmpSection.verifiable_ext__VFY_Order_By__c = 'CreatedDate DESC';
        tmpSection.verifiable_ext__VFY_Verifiable_Form__c =  onboardingForm.Id;
        tmpSection.RecordTypeId = recordTypeMap.get('Question');
        
        insert tmpSection;
        
        return tmpSection;
    }
    
    
    // Method to create fields to be inserted in Form Section
    public static verifiable_ext__VFY_Verifiable_Field__c createField(String name, String apiName, Double order, Boolean required, Id sectionId) {
        verifiable_ext__VFY_Verifiable_Field__c tempField = new verifiable_ext__VFY_Verifiable_Field__c();
        tempField.Name = name;
        tempField.verifiable_ext__VFY_Field_Api_Name__c = apiName;
        tempField.verifiable_ext__VFY_Order__c = order;
        tempField.verifiable_ext__VFY_Required__c = required;
        tempField.verifiable_ext__VFY_Verifiable_Section__c = sectionId;
        fieldsToInsert.add(tempField);
        return tempField;
    }
}