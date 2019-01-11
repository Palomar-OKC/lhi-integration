public class AnswerFileBuilder {
    private LASOCreator creator;
    private Id vpoCaseId;
    private LASOData caseData;
    private hd_XmlFactory answerBuilder;
    private Client__c client;

    public AnswerFileBuilder(Id inVpoCaseId, LASOCreator inCreator) {
        creator = inCreator;
        vpoCaseId = inVpoCaseId;
        caseData = new LASOData(vpoCaseId);
        answerBuilder = new hd_XmlFactory();
    }

    public string SendCaseToLASO() {
        client = caseData.getClient();
        
        Map<String, String> loginInfo = creator.GetLoginInfo(client);
        String answerString = BuildAnswerFile();
        List<String> status = creator.SaveDocument(answerString);

        CreateResultRecord(loginInfo, status, answerString);

        return String.join(status, '|');
    }

    private void CreateResultRecord(Map<String, String> loginInfo, List<String> statuses, String answerString) {
        insert new LASOResult__c(
            LinkToVPO__c = vpoCaseId,
            UserName__c = loginInfo.get('username'),
            Password__c = loginInfo.get('password'),
            AnswerText__c = answerString,
            Status__c = String.Join(statuses, '|')
        );
    }

    private string BuildAnswerFile() {
        answerBuilder.AddAnswerNode('Imported data MC', 'Palomar');

        AddAbuserFields();
        AddClientFields();
        AddInvolvedFields();
        AddVPOFields();
        
        return answerBuilder.getDoc().toXmlString();
    }

    private void AddAbuserFields() {
        Abuser__c abuser = caseData.GetAbuserInfo();
        for (string answer : abuserAnswers.keyset()) {
            answerBuilder.AddAnswerNode(answer, abuser.get(abuserAnswers.get(answer)));
        }

        string relationship = caseData.ConvertRelationship(abuser.Relationship__c);
        answerBuilder.AddAnswerNode('Client relationship MC', relationship);
        answerBuilder.AddAnswerNode('Relationship divorced TF', abuser.Relationship__c == 'Ex-Spouse');
        answerBuilder.AddAnswerNode('Relationship married TF', abuser.Relationship__c == 'Spouse');
        answerBuilder.AddAnswerNode(
            'Relationship parent/child TF', 
            abuser.Relationship__c == 'Parent' || abuser.Relationship__c == 'Child');
        answerBuilder.AddAnswerNode('Relationship previously dated TF', abuser.Relationship__c == 'Ex-Spouse');
        answerBuilder.AddAnswerNode('Relationship live tog TF', abuser.Relationship__c == 'Roommate');
        answerBuilder.AddAnswerNode('Relationship by blood TF', abuser.Relationship__c == 'Other Family Member');
    }

    private void AddClientFields() {
        for (string answer : clientAnswers.keyset()) {
            answerBuilder.AddAnswerNode(answer, client.get(clientAnswers.get(answer)));
        }
    }

    private void AddInvolvedFields() {
        List<String> names = new List<String>();
        List<String> genders = new List<String>();
        List<String> races = new List<String>();
        List<DateTime> dobs = new List<DateTime>();
        List<Boolean> harmed = new List<Boolean>();
        List<Boolean> harassed = new List<Boolean>();
        List<Boolean> threatened = new List<Boolean>();
        List<Boolean> stalked = new List<Boolean>();

        for (Child_Involved__c child : caseData.GetChildrenInvolved()) {
            names.add(child.Contact__r.Name);
            genders.add(child.Contact__r.Gender__c);
            races.add(child.Contact__r.Race_Ethnicity__c);
            dobs.add(child.Contact__r.Birthdate);
            harmed.add(child.VPO_has_been_harmed__c);
            harassed.add(child.VPO_has_been_harassed__c);
            threatened.add(child.VPO_has_been_threatened__c);
            stalked.add(child.VPO_has_been_stalked__c);
        }

        for (Petitioner_Invovled__c petitioner : caseData.GetInvolvedPetitioners()) {
            names.add(petitioner.Contact__r.Name);
            genders.add(petitioner.Contact__r.Gender__c);
            races.add(petitioner.Contact__r.Race_Ethnicity__c);
            dobs.add(petitioner.Contact__r.Birthdate);
            harmed.add(petitioner.VPO_has_been_harmed__c);
            harassed.add(petitioner.VPO_has_been_harassed__c);
            threatened.add(petitioner.VPO_has_been_threatened__c);
            stalked.add(petitioner.VPO_has_been_stalked__c);
        }

        answerBuilder.AddAnswerNode('Actions of defendant harassed names TE', names, true);
        answerBuilder.AddAnswerNode('Actions of defendant case harm names TE', names, true);
        answerBuilder.AddAnswerNode('Actions of defendant stalked names TE', names, true);
        answerBuilder.AddAnswerNode('Actions of defendant threatened harm names TE', names, true);
        answerBuilder.AddAnswerNode('Child race MC', races, true);
        answerBuilder.AddAnswerNode('Child gender MC', genders, true);
        answerBuilder.AddAnswerNode('Child birthdate DA', dobs, true);
        answerBuilder.AddAnswerNode('Child name TE', names, true);
        answerBuilder.AddAnswerNode('Action of defendant raped TF', harmed, true);
        answerBuilder.AddAnswerNode('Actions defendant harassed TF', harassed, true);
        answerBuilder.AddAnswerNode('Actions of defendance threatened harm TF', threatened, true);
        answerBuilder.AddAnswerNode('Actions of defendant stalked TF', stalked, true);
    }

    private void AddVPOFields() {
        VPO__c vpo = caseData.GetCase();

        answerBuilder.AddAnswerNode('Court county MC', vpo.Court_Case__r.DistrictCourtCounty__c);
        
        string day;
        string hour;
        string month;
        string year;
        string timepart;
        if (vpo.LeaveBy__c != null) {
            day = String.valueOf(vpo.LeaveBy__c.dayGmt());
            hour = String.valueOf(vpo.LeaveBy__c.hour());
            month = String.valueOf(vpo.LeaveBy__c.monthGmt());
            timepart = String.valueOf(vpo.LeaveBy__c.time());
            year = String.valueOf(vpo.LeaveBy__c.yearGmt());
        }
        
        answerBuilder.AddAnswerNode('Relief defendant leave day MC', day);
        answerBuilder.AddAnswerNode('Relief defendant leave hour MC', hour);
        answerBuilder.AddAnswerNode('Relief defendant leave month MC', month);
        answerBuilder.AddAnswerNode('Relief defendant leave time DA', vpo.LeaveBy__c);
        answerBuilder.AddAnswerNode('Relief defendant leave time MC', timepart);
        answerBuilder.AddAnswerNode('Relief defendant leave time TE', timepart);
        answerBuilder.AddAnswerNode('Relief defendant leave year MC', year);

        for (string answer : vpoAnswers.keyset()) {
            answerBuilder.AddAnswerNode(answer, vpo.get(vpoAnswers.get(answer)));
        }        
    }

    private final Map<String, String> vpoAnswers = new Map<String, String> {
        'Emergency TF' => 'Emergency__c',
        'Notice other agencies TE' => 'LawEnforcementCopies__c',
        'Relief contact TF' => 'NoContact__c',
        'Relief harming TF' => 'NoInjury__c',
        'Relief threatening TF' => 'NoIntimidation__c',
        'Relief leave TF' => 'LeaveResidence__c',
        'Relief defendant leave address TE' => 'LeaveAddress__c',
        'Relief defendant leave city TE' => 'LeaveCity__c',
        'Relief help defendant leave TF' => 'DefendantAccompaniment__c',
        'Relief help plaintiff leave address TE' => 'AccompanyAddress__c',
        'Relief help plaintiff leave city TE' => 'AccompanyCity__c',
        'Relief minor leave address TE' => 'LeaveAddress__c',
        'Relief minor leave city TE' => 'LeaveCity__c',
        'Relief modify visits TF' => 'VisitationModification__c',
        'Relief counseling TF' => 'RequestCounseling__c',
        'Relief animals TF' => 'ProtectAnimals__c',
        'Relief GPS TF' => 'GPSMonitoring__c',
        'Relief xfer utilities TF' => 'TransferUtilities__c',
        'Relief xfer utility accounts TE' => 'UtilitiesToTransfer__c',
        'Relief firearms TF' => 'RemoveWeapons__c',
        'Relief defendant surrender weapons CO' => 'SurrenderWeaponsTo__c',
        'Relief attys fees TF' => 'AttorneyFees__c',
        'Relief other TE' => 'AdditionalRelief__c',
        'Defendant criminal filed TF' => 'CriminalChargesFiled__c',
        'Defendant criminal details TE' => 'CriminalCaseDetails__c'
    };

    private final Map<String, String> clientAnswers = new Map<String, String> {
        'Client address1 TE' => 'Address__c',
        'Client address mailing TE' => 'MailingAddress__c',
        'Client birthdate DA' => 'DOB__c',
        'Client city physical TE' => 'City__c',
        'Client city mailing TE' => 'MailingCity__c',
        'Client county MC' => 'CountyPick__c',
        'Client cell phone TE' => 'SafePhoneNumber__c',
        'Client gender MC' => 'Gender__c',
        'Client name first TE' => 'FirstName__c',
        'Client name last TE' => 'LastName__c',
        'Client name middle TE' => 'MiddleName__c',
        'Client name suffix MC' => 'Suffix__c',
        'Client race MC' => 'RaceEthnicity__c',
        'Client state mailing MC' => 'MailingStatePick__c',
        'Client state physical MC' => 'PhysicalStatePick__c',
        'Client zipcode mailing TE' => 'MailingZip__c',
        'Client zipcode physical TE' => 'ZipCode__c',
        'Client prop rent own MC' => 'OwnRent__c',
        'Names on lease or mortgage TE' => 'PropertyDetails__c'
    };

    private final Map<String, String> abuserAnswers = new Map<String, String> {
        'Defendant address1 TE' => 'PhysicalAddress__c',
        'Defendant address mailing TE' => 'MailingAddress__c',
        'Defendant birthdate DA' => 'DOB__c',
        'Defendant city mailing TE' => 'MailingCity__c',
        'Defendant city physical TE' => 'PhysicalCity__c',
        'Defendant convicted TF' => 'CriminalConvictions__c',
        'Defendant county MC' => 'County__c',
        'Defendant distinguishing features TE' => 'ScarsMarksTattoos__c',
        'Defendant employer address1 TE' => 'WorkAddress__c',
        'Defendant employer hours TE' => 'WorkSchedule__c',
        'Defendant eye color MC' => 'EyeColorPick__c',
        'Defendant facial hair MC' => 'FacialHair__c',
        'Defendant gender MC' => 'Gender__c',
        'Defendant glasses MC' => 'Glasses__c',
        'Defendant hair length MC' => 'HairLength__c',
        'Defendant hair MC' => 'HairColorPick__c',
        'Defendant height TE' => 'Height__c',
        'Defendant med cond TE' => 'MedicalConditions__c',
        'Defendant name first TE' => 'FirstName__c',
        'Defendant name last TE' => 'LastName__c',
        'Defendant name middle TE' => 'MiddleName__c',
        'Defendant name suffix MC' => 'Suffix__c',
        'Defendant cell phone TE' => 'CellPhone__c',
        'Defendant probation TF' => 'Probation_Parole__c',
        'Defendant race MC' => 'RaceEthnicity__c',
        'Defendant state physical MC' => 'PhysicalStatePick__c',
        'Defendant employer state MC' => 'WorkState__c',
        'Defendant employer city TE' => 'WorkCity__c',
        'Defendant state mailing MC' => 'MailingStatePick__c',
        'Defendant teeth MC' => 'MissingTeeth__c',
        'Defendant vehicle color TE' => 'CarColor__c',
        'Defendant vehicle make TE' => 'CarMake__c',
        'Defendant vehicle model TE' => 'CarModel__c',
        'Defendant vehicle type TE' => 'CarStyle__c',
        'Defendant vehicle year TE' => 'CarYear__c',
        'Defendant weight TE' => 'Weight__c',
        'Defendant zipcode physical TE' => 'PhysicalZip__c',
        'Weapons MC' => 'Weapon__c',
        'Weapons type TE' => 'WeaponType__c',
        'Defendant email TE' => 'Email__c',
        'Defendant employer name TE' => 'EmployerName__c',
        'Defendant work phone TE' => 'WorkPhone__c',
        'Defendant employer zipcode TE' => 'Work_Zip_Code__c',
        'Defendant zipcode mailing TE' => 'MailingZip__c'
    };
}