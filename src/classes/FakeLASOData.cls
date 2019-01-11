public class FakeLASOData implements LASOCreator {
    public List<String> AnswerResult { get; set; }
    public Map<String, String> LoginResult { get; set; }
    public string sentAnswer { get; set; }
    public Client__c sentClient { get; set; }

    public FakeLASOData() { }

    public List<String> SaveDocument(String answerFile) {
        sentAnswer = answerFile;
        return AnswerResult == null ? new List<String>() : AnswerResult;
    }

    public Map<String, String> GetLoginInfo(Client__c client) {
        sentClient = client;
        return LoginResult == null ? new Map<String, String>() : LoginResult;
    }
}