//https://github.com/apexlarson/LimitsProfiler
//https://test.salesforce.com/packaging/installPackage.apexp?p0=04t41000002RXGo
//  Visualforce page /apex/limitsprofiler
//  Configure - Profiler Type: Profilers.BulkInsertProfiler
// May need to disable Standard Contact Duplicate Rule
public with sharing class Profilers
{
    public class SerializationProfiler extends LimitsProfiler
    {
        final List<String> data;
        public SerializationProfiler()
        {
            data = new List<String>();
            for (Integer i = 0; i < 1000; i++)
                data.add('a'.repeat(1000));
        }
        public override void execute()
        {
            String payload = JSON.serialize(data);
        }
    }

    public class CloneProfiler extends LimitsProfiler
    {
        final Contact data;
        public CloneProfiler()
        {
            data = new Contact();
            
        }
        public override void execute()
        {
            sObject theBase = data.getSObjectType().newSObject();
            for (Integer i = 0; i < 1000; i++) {
                sObject cleanObj = theBase.clone();
            }
        }
    }
   
    public class UpdateProfiler extends LimitsProfiler
    {
        private List<String> fieldsToCheck;
       
        Contact c;
        public UpdateProfiler()
        {
           
           
        }
        public override void setup() {
            c = new Contact();
            c.LastName = 'Foo';
            insert c;
           
            fieldsToCheck = new List<String>{'LastName','FirstName','Salutation','OtherStreet','OtherCity','OtherState','OtherPostalCode','OtherCountry','OtherLatitude','OtherLongitude','MailingStreet','MailingCity','MailingState','MailingPostalCode','MailingCountry','MailingLatitude','MailingLongitude','Phone','Fax','MobilePhone','HomePhone','OtherPhone','AssistantPhone','ReportsToId','Title','Department','AssistantName','LeadSource','Birthdate','Description','EmailBouncedReason','EmailBouncedDate', 'Email'};
        }
       
        public override void execute()
        {
            System.assertNotEquals(null, fieldsToCheck);
            ESAPI.accessController().updateAsUser(c, fieldsToCheck);
        }
    }
   
    public class BulkInsertProfiler extends LimitsProfiler
    {
        private List<String> fieldsToCheck;

        transient Savepoint sp = null;
       
        List<Contact> c;
        public BulkInsertProfiler()
        {  
        }
       
        public override void setup() {
            sp = Database.setSavepoint();

            c = new List<Contact>();
            for(integer i = 0; i<200;i++) {
                c.add(sampleContact(i));
            }
            //c = new Map<Id, Contact>(cl);
           
            fieldsToCheck = new List<String>{'LastName','FirstName','Salutation','OtherStreet','OtherCity','OtherState','OtherPostalCode','OtherCountry','OtherLatitude','OtherLongitude','MailingStreet','MailingCity','MailingState','MailingPostalCode','MailingCountry','MailingLatitude','MailingLongitude','Phone','Fax','MobilePhone','HomePhone','OtherPhone','AssistantPhone','ReportsToId','Title','Department','AssistantName','LeadSource','Birthdate','Description','EmailBouncedReason','EmailBouncedDate', 'Email'};
        }
       
        public override void execute()
        {
            System.assertNotEquals(null, fieldsToCheck);
            ESAPI.accessController().insertAsUser(c, fieldsToCheck);
        }

        public override void tearDown() {
            Database.rollback(sp);

            //integer remainingDML = Limits.getLimitDMLRows() - Limits.getDMLStatements() - 1000;
            //delete [Select Id from Contact where Email = 'ContactEmail@example.com' limit :remainingDML];
        }
    }

    public class BulkUpdateProfiler extends LimitsProfiler
    {
        private List<String> fieldsToCheck;
       
        transient Savepoint sp = null;

        List<Contact> c;
        public BulkUpdateProfiler()
        {  
        }
       
        public override void setup() {

            sp = Database.setSavepoint();

            c = new List<Contact>();
            for(integer i = 0; i<200;i++) {
                c.add(sampleContact(i));
            }
            //c = new Map<Id, Contact>(cl);
            
            insert c;

            fieldsToCheck = new List<String>{'LastName','FirstName','Salutation','OtherStreet','OtherCity','OtherState','OtherPostalCode','OtherCountry','OtherLatitude','OtherLongitude','MailingStreet','MailingCity','MailingState','MailingPostalCode','MailingCountry','MailingLatitude','MailingLongitude','Phone','Fax','MobilePhone','HomePhone','OtherPhone','AssistantPhone','ReportsToId','Title','Department','AssistantName','LeadSource','Birthdate','Description','EmailBouncedReason','EmailBouncedDate', 'Email'};
        }
       
        public override void execute()
        {
            System.assertNotEquals(null, fieldsToCheck);
            ESAPI.accessController().updateAsUser(new Map<Id, Contact>(c), fieldsToCheck);
        }

        public override void tearDown() {
            Database.rollback(sp);

            //integer remainingDML = Limits.getLimitDMLRows() - Limits.getDMLStatements() - 1000;
            //delete [Select Id from Contact where Email = 'ContactEmail@example.com' limit :remainingDML];
        }
    }
       
    public static Contact sampleContact(integer i) {
        Contact c = new Contact();
        c.LastName='Foo' + i;
        c.FirstName='Bar' + i;
        c.Salutation='Zer';
        c.Birthdate=Date.newInstance(2019, 10, 17);
        c.Department='Testing';
        c.OtherStreet = 'OtherStreet';
        c.OtherCity = 'OtherCity';
        c.OtherState = 'OtherState';
        c.OtherPostalCode = 'OtherPostalCode';
        c.OtherCountry = 'OtherCountry';
        c.OtherLatitude = 1;
        c.OtherLongitude = 1;
        c.MailingStreet = 'MailingStreet';
        c.MailingCity = 'MailingCity';
        c.MailingState = 'MailingState';
        c.MailingPostalCode = 'MailingPostalCode';
        c.MailingCountry = 'MailingCountry';
        c.MailingLatitude = 1;
        c.MailingLongitude = 1;
        c.Phone = 'Phone' + i;
        c.Fax = 'Fax';
        c.MobilePhone = 'MobilePhone';
        c.HomePhone = 'HomePhone';
        c.OtherPhone = 'OtherPhone';
        c.AssistantPhone = 'AssistantPhone';
        
        c.Title = 'Title';
        c.Department = 'Department';
        c.AssistantName = 'AssistantName';
        c.LeadSource = 'LeadSource';
        c.Birthdate = DateTime.now().Date();
        c.Description = 'Description';
        c.EmailBouncedReason = 'EmailBouncedReason';
        c.EmailBouncedDate = DateTime.now();
        c.Email = 'ContactEmail@example.com';
        
        c.ReportsToId = null;

        
        return c;
    }
}