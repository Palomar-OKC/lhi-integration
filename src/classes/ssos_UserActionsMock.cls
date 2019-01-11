@isTest
global class ssos_UserActionsMock implements WebServiceMock {
    public ssos_UserActions.SaveAnswer_element incoming;    

    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName, 
        String responseNS,
        String responseName,
        String responseType)
    {
        object resp;
        ssos_Arrays.ArrayOfString msg = new ssos_Arrays.ArrayOfString();
        msg.string_x = new List<String> { 'Success' };
        ssos_AnswerFile.Result result = new ssos_AnswerFile.Result();
        result.Success = true;
        result.Message = msg;
        if (soapAction == 'http://tempuri.org/IService/ValidateLogoffToken'){
            ssos_UserActions.ValidateLogoffTokenResponse_element el = 
                new ssos_UserActions.ValidateLogoffTokenResponse_element();
            el.ValidateLogoffTokenResult = true;
            resp = el;

        } else if (soapAction == 'http://tempuri.org/IService/GenerateLoginToken') {
            ssos_UserActions.GenerateLoginTokenResponse_element el =
                new ssos_UserActions.GenerateLoginTokenResponse_element();
            el.GenerateLoginTokenResult = result;
            resp = el;

        } else if (soapAction == 'http://tempuri.org/IService/ChangePassword') {
            ssos_UserActions.ChangePasswordResponse_element el =
                new ssos_UserActions.ChangePasswordResponse_element();
            el.ChangePasswordResult = result;
            resp = el;

        } else if (soapAction == 'http://tempuri.org/IService/DecryptLoginToken') {
            ssos_UserActions.DecryptLoginTokenResponse_element el =
                new ssos_UserActions.DecryptLoginTokenResponse_element();
            el.DecryptLoginTokenResult = new ssos_AnswerFile.User_x();
            resp = el;

        } else if (soapAction == 'http://tempuri.org/IService/SaveAnswer') {
            ssos_UserActions.SaveAnswerResponse_element el =
                new ssos_UserActions.SaveAnswerResponse_element();
            el.SaveAnswerResult = result;
            resp = el;

            incoming = (ssos_UserActions.SaveAnswer_element)request;

        } else if (soapAction == 'http://tempuri.org/IService/GenerateLogoffToken') {
            ssos_UserActions.GenerateLogoffTokenResponse_element el =
                new ssos_UserActions.GenerateLogoffTokenResponse_element();
            el.GenerateLogoffTokenResult = result;
            resp = el;
        }
        response.put('response_x', resp);
    }
}