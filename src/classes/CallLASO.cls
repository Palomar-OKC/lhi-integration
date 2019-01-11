public class CallLASO implements LASOCreator {
    private ssos_UserActions.BasicHttpBinding_IService service;
    private ssos_AnswerFile.User_x user;

    public CallLASO() { }
    
    public Map<String, String> GetLoginInfo(Client__c client) {
        service = new ssos_UserActions.BasicHttpBinding_IService();
        user = createUser(client);

        Map<String, String> loginInfo = new Map<String, String>();
        if (user == null) {
            return loginInfo;
        }

        loginInfo.put('username', user.UserName);
        loginInfo.put('password', user.Password);
        return loginInfo;
    }

    public List<String> SaveDocument(String answerFile) {
        user.AnswerFile = answerFile;
        user.TemplateId = Integer.valueOf(LHIEndpoint__c.getValues('Default').TemplateId__c);
        
        ssos_Arrays.ArrayOfstring ConnectPointId = new ssos_Arrays.ArrayOfstring();
        ConnectPointId.string_x = new List<String> { LHIEndpoint__c.getValues('Default').EventId__c };
        user.EventIds = ConnectPointId;
        
        ssos_AnswerFile.Result result = new ssos_AnswerFile.Result();

        try {
            result = service.SaveAnswer(user);
        } catch (Exception ex) { return new String[] { ex.getMessage() }; }
        
        return result.Message == null ? new String[] {''} : result.Message.string_x;
    }

    private ssos_AnswerFile.User_x createUser(Client__c client) {
        ssos_AnswerFile.User_x userx = new ssos_AnswerFile.User_x();
        
        userx.UserName = 
            client.FirstName__c.substring(0,1).toLowerCase() + 
            client.LastName__c.toLowerCase() + 
            generateRandomString(6, false);

        userx.Password = generatePassword();
        userx.FirstName = client.FirstName__c;
        userx.LastName = client.LastName__c;
        userx.Email = 'vpo@palomarokc.org';
        userx.UserTypeId = 1;
        userx.StateId = 37;
        userx.SecurityQuestionId = 1;
        userx.SecurityAnswer = 'Palomar';

        return userx;
    }

    private string generatePassword() {
        Integer randint = (math.Random() * 10).intValue();
        return generateRandomString(3, false) + String.valueOf(randint) + generateRandomString(3, true) + '!';
    }

    public static String generateRandomString(Integer len, Boolean lower) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return lower ? randStr.toLowerCase() : randStr; 
    }
}