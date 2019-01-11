public class SubmitLASOCase {
    @AuraEnabled
    public static string Submit(ID recordId){
        VPO__c vpo = [select Court_Case__r.Case__c from VPO__c where Id = :recordId];
        return new AnswerFileBuilder(recordId, new CallLASO()).SendCaseToLASO();
    }

    @AuraEnabled
    public static List<LASOResult__c> GetResults(Id recordId) {
        return [select id, UserName__c, Password__c, Status__c, CreatedDate
            from LASOResult__c
            where LinkToVPO__c = :recordId
            order by CreatedDate desc];
    }
}