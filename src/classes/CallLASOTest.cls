@isTest
public class CallLASOTest {
    public static testmethod void InitializesClass() {
        insert new LHIEndpoint__c(Name = 'Default', Domain__c = 'test');
        CallLASO testee = new CallLASO();
        testee.GetLoginInfo(new Client__c(
            FirstName__c = 'Test',
            LastName__c = 'Client',            
            DOB__c = Date.newInstance(1990,1,1)
        ));

        ssos_AnswerFile.User_x mocked = Init(testee);

        System.assertEquals('test', mocked.AnswerFile);
    }

    public static testmethod void CreatesUser() {
        insert new LHIEndpoint__c(Name = 'Default', Domain__c = 'test');
        CallLASO testee = new CallLASO();
        testee.GetLoginInfo(new Client__c(
            FirstName__c = 'Test',
            LastName__c = 'Client',
            SafeEmail__c = 'default@default.default',
            DOB__c = Date.newInstance(1990,1,1)
        ));

        ssos_AnswerFile.User_x mocked = Init(testee);

        System.assert(mocked.UserName.contains('tclient'));
        System.assertEquals('Test', mocked.FirstName);
        System.assertEquals('Client', mocked.LastName);
        System.assertEquals('vpo@palomarokc.org', mocked.Email);
        System.assertEquals(37, mocked.StateId);
        System.assertEquals(1, mocked.UserTypeId);
        System.assertEquals(1, mocked.SecurityQuestionId);
        System.assertEquals('Palomar', mocked.SecurityAnswer);
        System.assertEquals(
            Integer.valueOf(LHIEndpoint__c.getValues('Default').TemplateId__c), 
            mocked.TemplateId);
    }

    public static testmethod void ReturnsLASOLoginInfo() {
        insert new LHIEndpoint__c(Name = 'Default', Domain__c = 'test');
        CallLASO testee = new CallLASO();
        Map<String, String> loginInfo = testee.GetLoginInfo(new Client__c(
            FirstName__c = 'Test',
            LastName__c = 'Client',
            DOB__c = Date.newInstance(1990,1,1)
        ));

        System.assert(loginInfo.get('username').contains('tclient'));
        System.assert(loginInfo.get('password').length() >= 8);
    }

    private static ssos_AnswerFile.User_x Init(CallLASO testee) {        
        ssos_UserActionsMock mock = new ssos_UserActionsMock();
        Test.setMock(WebServiceMock.class, mock);        

        Test.startTest();
        List<string> result = testee.SaveDocument('test');
        Test.stopTest();
        
        return mock.incoming.user_x;
    }
}