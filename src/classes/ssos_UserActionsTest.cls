@isTest
public class ssos_UserActionsTest {
    private static ssos_UserActions.BasicHttpBinding_Iservice init() {
        insert new LHIEndpoint__c( Name = 'Default', Domain__c = 'end');
        Test.setMock(WebServiceMock.class, new ssos_UserActionsMock());
        ssos_Arrays.ArrayOfstring notused = new ssos_Arrays.ArrayOfstring();
        return new ssos_UserActions.BasicHttpBinding_Iservice();
    }
    
    public static testmethod void ValidateLogoffToken() {
        ssos_UserActions.BasicHttpBinding_Iservice serv = init();

        Test.startTest();
        Boolean result = serv.ValidateLogoffToken('test');
        Test.stopTest();
    }

    public static testmethod void GenerateLoginToken() {
        ssos_UserActions.BasicHttpBinding_Iservice serv = init();

        Test.startTest();
        ssos_AnswerFile.Result result = serv.GenerateLoginToken(new ssos_AnswerFile.User_x());
        Test.stopTest();
    }

    public static testmethod void ChangePassword() {
        ssos_UserActions.BasicHttpBinding_Iservice serv = init();

        Test.startTest();
        ssos_AnswerFile.Result result = serv.ChangePassword(new ssos_AnswerFile.ChangePassword());
        Test.stopTest();
    }

    public static testmethod void DecryptLoginToken() {
        ssos_UserActions.BasicHttpBinding_Iservice serv = init();

        Test.startTest();
        ssos_AnswerFile.User_x result = serv.DecryptLoginToken('test');
        Test.stopTest();
    }

    public static testmethod void SaveAnswer() {
        ssos_UserActions.BasicHttpBinding_Iservice serv = init();

        Test.startTest();
        ssos_AnswerFile.Result result = serv.SaveAnswer(new ssos_AnswerFile.User_x());
        Test.stopTest();
    }

    public static testmethod void GenerateLogoffToken() {
        ssos_UserActions.BasicHttpBinding_Iservice serv = init();

        Test.startTest();
        ssos_AnswerFile.Result result = serv.GenerateLogoffToken('test');
        Test.stopTest();
    }
}