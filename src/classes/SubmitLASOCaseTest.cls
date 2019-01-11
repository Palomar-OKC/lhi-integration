@isTest
public class SubmitLASOCaseTest {
    public static testmethod void CallsLASO() {
        insert new LHIEndpoint__c(Name = 'Default', Domain__c = 'test');
        FluentTester vault = new FluentTester();
        Case__c casen = vault.GetCase();
        insert new InformedConsent__c(LinkToCase__c=casen.Id);
        VPO__c vpo = vault.getVPO();

        Test.startTest();        
        ssos_UserActionsMock mock = Init();
        string result = SubmitLASOCase.Submit(vpo.Id);
        Test.stopTest();

        System.assertEquals('Success', result, 'result='+result);
        System.assert(mock != null);
    }

    public static testmethod void DoesNotCallLASOWithoutConsent() {
        insert new LHIEndpoint__c(Name = 'Default', Domain__c = 'test');
        FluentTester vault = new FluentTester();
        VPO__c vpo = vault.getVPO();

        Test.startTest();        
        ssos_UserActionsMock mock = Init();
        string result = SubmitLASOCase.Submit(vpo.Id);
        Test.stopTest();

        System.assertEquals('Cannot Submit without valid Informed Consent on file', result);
    }

    public static testmethod void DoesNotCallLASOWithExpiredConsent() {
        insert new LHIEndpoint__c(Name = 'Default', Domain__c = 'test');
        FluentTester vault = new FluentTester();
        Case__c casen = vault.GetCase();
        insert new InformedConsent__c(
            LinkToCase__c=casen.Id,
            DateExpires__c = System.today().addDays(-1)
            );
        VPO__c vpo = vault.getVPO();

        Test.startTest();        
        ssos_UserActionsMock mock = Init();
        string result = SubmitLASOCase.Submit(vpo.Id);
        Test.stopTest();

        System.assertEquals('Cannot Submit without valid Informed Consent on file', result);
    }

    public static testmethod void GetsResults() {
        FluentTester vault = new FluentTester();        
        VPO__c vpo = vault.getVPO();
        insert new LASOResult__c(
            LinkToVPO__c = vpo.Id,
            UserName__c = 'user',
            Password__c = 'pass',
            Status__c = 'status'
        );

        List<LASOResult__c> results = SubmitLASOCase.GetResults(vpo.Id);

        System.assertEquals(1, results.size());
        System.assertEquals('user', results[0].UserName__c);
        System.assertEquals('pass', results[0].Password__c);
        System.assertEquals('status', results[0].Status__c);
    }

    private static ssos_UserActionsMock Init() {
        
        ssos_UserActionsMock mock = new ssos_UserActionsMock();
        Test.setMock(WebServiceMock.class, mock);
        
        return mock;
    }
}