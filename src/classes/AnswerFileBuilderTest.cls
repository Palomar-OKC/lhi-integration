@isTest
public class AnswerFileBuilderTest {
    public static testmethod void SendsClientAndCaseToLASO() {
        FluentTester vault = new FluentTester();

        Client__c client = vault.getClient();
        VPO__c vpo = vault.getVPO();

        FakeLASOData fake = SetupFake();        
        
        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();

        System.assertEquals(client.Id, fake.sentClient.Id);
    }

    public static testmethod void CreatesResultRecord() {
        FluentTester vault = new FluentTester();

        Client__c client = vault.getClient();
        VPO__c vpo = vault.getVPO();

        FakeLASOData fake = SetupFake();

        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();

        LASOResult__c result = 
            [select id, LinkToVPO__c, UserName__c, Password__c,
                AnswerText__c, Status__c
            from LASOResult__c LIMIT 1];

        System.assertEquals(vpo.Id, result.LinkToVPO__c);
        System.assertEquals('user', result.UserName__c);
        System.assertEquals('pass', result.Password__c);
        System.assertEquals('Success', result.Status__c);
        System.assertEquals(fake.sentAnswer, result.AnswerText__c);
        System.assert(fake.sentAnswer.contains('Imported data MC'));
    }

    public static testmethod void AnswerFileContainsAllAbuserFields() {
        FluentTester vault = new FluentTester();
        Abuser__c abuser = new Abuser__c(
            FirstName__c = 'first',
            LastName__c = 'last',
            Suffix__c = 'II',
            MiddleName__c = 'middle',
            DOB__c = Date.newInstance(2000, 1, 1),
            County__c = 'Tulsa',
            Gender__c = 'Male',            
            PhysicalStatePick__c = 'Oklahoma',
            PhysicalCity__c = 'physicalcity',
            PhysicalAddress__c = 'physaddress',
            PhysicalZip__c = 'pzip',
            WorkAddress__c = 'workaddress',
            WorkState__c = 'Arkansas',
            WorkCity__c = 'Oklahoma City',
            Work_Zip_Code__c = 12345,
            RaceEthnicity__c = 'Other',
            Relationship__c = 'Spouse',
            MailingAddress__c = 'mailingaddy',
            MailingCity__c = 'mailingcity',            
            MailingStatePick__c = 'Texas',
            MailingZip__c = 'mzip',
            EmployerName__c = 'employername',
            WorkPhone__c = 'workphone',
            Email__c = 'email@email.email',
            WeaponType__c = 'weapontype',
            Weapon__c = 'Yes',
            Weight__c = 'weight',
            CarStyle__c = 'carstyle',
            CarModel__c = 'carmodel',
            CarMake__c = 'carmake',
            CarColor__c = 'carcolor',
            CarYear__c = 'caryear',
            MissingTeeth__c = 'Missing teeth are not visible',
            Probation_Parole__c = true,
            CellPhone__c = 'cellphone',
            MedicalConditions__c = 'Crutches',
            Height__c = 'height',
            HairColorPick__c = 'Bald',
            HairLength__c = 'Short hair',
            Glasses__c = 'Sometimes',
            FacialHair__c = 'None',
            EyeColorPick__c = 'Blue',
            WorkSchedule__c = 'workschedule',
            ScarsMarksTattoos__c = 'scarsmarkstattoos',
            CriminalConvictions__c = true
        );

        VPO__c vpo = vault.CreateAbuser(abuser).GetVPO();

        FakeLASOData fake = SetupFake();

        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();
        
        System.assert(fake.sentAnswer.contains(abuser.FirstName__c));
        System.assert(fake.sentAnswer.contains(abuser.LastName__c));
        System.assert(fake.sentAnswer.contains(abuser.Suffix__c));
        System.assert(fake.sentAnswer.contains(abuser.MiddleName__c));
        System.assert(fake.sentAnswer.contains(abuser.County__c));
        System.assert(fake.sentAnswer.contains(abuser.Gender__c));
        System.assert(fake.sentAnswer.contains(abuser.PhysicalStatePick__c));
        System.assert(fake.sentAnswer.contains(abuser.PhysicalCity__c));
        System.assert(fake.sentAnswer.contains(abuser.PhysicalAddress__c));
        System.assert(fake.sentAnswer.contains(abuser.PhysicalZip__c));
        System.assert(fake.sentAnswer.contains(abuser.WorkAddress__c));
        System.assert(fake.sentAnswer.contains(abuser.WorkState__c));
        System.assert(fake.sentAnswer.contains(abuser.WorkCity__c));
        System.assert(fake.sentAnswer.contains(String.valueOf(abuser.Work_Zip_Code__c)));
        System.assert(fake.sentAnswer.contains(abuser.RaceEthnicity__c));
        System.assert(fake.sentAnswer.contains('Relationship married')); //Spouse
        System.assert(fake.sentAnswer.contains(abuser.MailingAddress__c));
        System.assert(fake.sentAnswer.contains(abuser.MailingCity__c));
        System.assert(fake.sentAnswer.contains(abuser.MailingStatePick__c));
        System.assert(fake.sentAnswer.contains(abuser.MailingZip__c));
        System.assert(fake.sentAnswer.contains(abuser.EmployerName__c));
        System.assert(fake.sentAnswer.contains(abuser.WorkPhone__c));
        System.assert(fake.sentAnswer.contains(abuser.Email__c));
        System.assert(fake.sentAnswer.contains(abuser.WeaponType__c));
        System.assert(fake.sentAnswer.contains(abuser.Weapon__c));
        System.assert(fake.sentAnswer.contains(abuser.Weight__c));
        System.assert(fake.sentAnswer.contains(abuser.CarStyle__c));
        System.assert(fake.sentAnswer.contains(abuser.CarModel__c));
        System.assert(fake.sentAnswer.contains(abuser.CarMake__c));
        System.assert(fake.sentAnswer.contains(abuser.CarColor__c));
        System.assert(fake.sentAnswer.contains(abuser.CarYear__c));
        System.assert(fake.sentAnswer.contains(abuser.MissingTeeth__c));
        System.assert(fake.sentAnswer.contains(abuser.CellPhone__c));
        System.assert(fake.sentAnswer.contains(abuser.Height__c));
        System.assert(fake.sentAnswer.contains(abuser.HairColorPick__c));
        System.assert(fake.sentAnswer.contains(abuser.HairLength__c));
        System.assert(fake.sentAnswer.contains(abuser.Glasses__c));
        System.assert(fake.sentAnswer.contains(abuser.FacialHair__c));
        System.assert(fake.sentAnswer.contains(abuser.EyeColorPick__c));
        System.assert(fake.sentAnswer.contains(abuser.WorkSchedule__c));
        System.assert(fake.sentAnswer.contains(abuser.ScarsMarksTattoos__c));
        System.assert(fake.sentAnswer.contains(
            abuser.DOB__c.month()+'/'+abuser.DOB__c.day()+'/'+abuser.DOB__c.year()));
        System.assert(fake.sentAnswer.contains(getTF('Defendant convicted TF', abuser.CriminalConvictions__c)));
        System.assert(fake.sentAnswer.contains(getTF('Defendant probation TF', abuser.Probation_Parole__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relationship divorced TF', false)));
        System.assert(fake.sentAnswer.contains(getTF('Relationship married TF', true)));
        System.assert(fake.sentAnswer.contains(getTF('Relationship parent/child TF', false)));
        System.assert(fake.sentAnswer.contains(getTF('Relationship previously dated TF', false)));
    }

    public static testmethod void AnswerFileContainsAllClientFields() {
        FluentTester vault = new FluentTester();
        Client__c client = new Client__c(
            FirstName__c = 'first',
            LastName__c = 'last',
            DOB__c = Date.newInstance(2000, 1, 1),
            City__c = 'tulsa',
            CountyPick__c = 'Tulsa',
            Gender__c = 'Male',
            MiddleName__c = 'middle',
            PhysicalStatePick__c = 'Oklahoma',
            RaceEthnicity__c = 'Other',
            SafeEmail__c = 'test@test.com',
            SafePhoneNumber__c = 'phone',
            ZipCode__c = 'zip',
            Address__c = 'addy',
            MailingAddress__c = 'mailingaddy',
            MailingCity__c = 'mailingcity',
            Suffix__c = 'II',
            MailingStatePick__c = 'Oklahoma',
            MailingZip__c = 'mailingzip',
            OwnRent__c = 'Own',
            PropertyDetails__c = 'propdetails'
        );
        VPO__c vpo = vault.CreateClient(client).GetVPO();

        FakeLASOData fake = SetupFake();

        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();

        System.assert(fake.sentAnswer.contains(getTF('Relief attys fees TF', vpo.AttorneyFees__c)));
        System.assert(fake.sentAnswer.contains(client.Address__c));
        System.assert(fake.sentAnswer.contains(
            client.DOB__c.month()+'/'+client.DOB__c.day()+'/'+client.DOB__c.year()));
        System.assert(fake.sentAnswer.contains(client.City__c));
        System.assert(fake.sentAnswer.contains(client.MailingAddress__c));
        System.assert(fake.sentAnswer.contains(client.MailingCity__c));
        System.assert(fake.sentAnswer.contains(client.CountyPick__c));
        System.assert(fake.sentAnswer.contains(client.Gender__c));
        System.assert(fake.sentAnswer.contains(client.FirstName__c));
        System.assert(fake.sentAnswer.contains(client.LastName__c));
        System.assert(fake.sentAnswer.contains(client.MiddleName__c));
        System.assert(fake.sentAnswer.contains(client.SafePhoneNumber__c));
        System.assert(fake.sentAnswer.contains(client.Suffix__c));
        System.assert(fake.sentAnswer.contains(client.RaceEthnicity__c));
        System.assert(fake.sentAnswer.contains(client.MailingStatePick__c));
        System.assert(fake.sentAnswer.contains(client.PhysicalStatePick__c));
        System.assert(fake.sentAnswer.contains(client.MailingZip__c));
        System.assert(fake.sentAnswer.contains(client.ZipCode__c));
        System.assert(fake.sentAnswer.contains(client.OwnRent__c));
        System.assert(fake.sentAnswer.contains(client.PropertyDetails__c));
    }

    public static testmethod void AnswerFileContainsAllContactFields_Child() {
        Contact child = new Contact(
            FirstName = 'First', 
            LastName = 'One',
            birthdate = Date.newInstance(2000,1,1),
            Gender__c = 'Male',
            Race_Ethnicity__c = 'Asian'
        );
        FluentTester vault = new FluentTester();
        Child_Involved__c child1 = vault.CreateContact(child)
            .GetChildInvolved(new Child_Involved__c(
                vpo_has_been_harassed__c = true,
                vpo_has_been_harmed__c = true,
                vpo_has_been_stalked__c = true,
                vpo_has_been_threatened__c = true
            ));
        VPO__c vpo = vault.GetVPO();

        FakeLASOData fake = SetupFake();

        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();
        
        System.assert(fake.sentAnswer.contains('Action of defendant raped TF'));
        System.assert(fake.sentAnswer.contains('Actions defendant harassed TF'));
        System.assert(fake.sentAnswer.contains('Actions of defendance threatened harm TF'));
        System.assert(fake.sentAnswer.contains('Actions of defendant stalked TF'));
        System.assert(fake.sentAnswer.contains(child.Gender__c));
        System.assert(fake.sentAnswer.contains(child.Race_Ethnicity__c));
        System.assert(fake.sentAnswer.contains(
            child.birthdate.month()+'/'+child.birthdate.day()+'/'+child.birthdate.year()));
        System.assert(fake.sentAnswer.contains(child.FirstName + ' ' + child.lastname));
    }

    public static testmethod void AnswerFileContainsAllContactFields_Petitioner() {
        Contact petitioner = new Contact(
            FirstName = 'First', 
            LastName = 'One',
            birthdate = Date.newInstance(2000,1,1),
            Gender__c = 'Male',
            Race_Ethnicity__c = 'Asian'
        );
        FluentTester vault = new FluentTester();
        Petitioner_Invovled__c petitioner1 = vault.CreateContact(petitioner)
            .GetPetitionerInvolved(new Petitioner_Invovled__c(
                vpo_has_been_harassed__c = true,
                vpo_has_been_harmed__c = true,
                vpo_has_been_stalked__c = true,
                vpo_has_been_threatened__c = true
            ));
        VPO__c vpo = vault.GetVPO();

        FakeLASOData fake = SetupFake();

        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();
        
        System.assert(fake.sentAnswer.contains('Action of defendant raped TF'));
        System.assert(fake.sentAnswer.contains('Actions defendant harassed TF'));
        System.assert(fake.sentAnswer.contains('Actions of defendance threatened harm TF'));
        System.assert(fake.sentAnswer.contains('Actions of defendant stalked TF'));
        System.assert(fake.sentAnswer.contains(petitioner.Gender__c));
        System.assert(fake.sentAnswer.contains(petitioner.Race_Ethnicity__c));
        System.assert(fake.sentAnswer.contains(
            petitioner.birthdate.month()+'/'+
            petitioner.birthdate.day()+'/'+
            petitioner.birthdate.year()));
        System.assert(fake.sentAnswer.contains(petitioner.FirstName + ' ' + petitioner.lastname));
    }

    public static testmethod void AnswerFileContainsAllContactFields_PetitionerChild() {
        Contact petitioner = new Contact(
            FirstName = 'First', 
            LastName = 'One',
            birthdate = Date.newInstance(2000,1,1),
            Gender__c = 'Male',
            Race_Ethnicity__c = 'Asian'
        );
        Contact child = new Contact(
            FirstName = 'Second', 
            LastName = 'Person',
            birthdate = Date.newInstance(2010,5,5),
            Gender__c = 'Female',
            Race_Ethnicity__c = 'Other'
        );
        FluentTester vault = new FluentTester();
        Petitioner_Invovled__c petitioner1 = vault.CreateContact(petitioner)
            .GetPetitionerInvolved(new Petitioner_Invovled__c(
                vpo_has_been_harassed__c = true,
                vpo_has_been_harmed__c = true,
                vpo_has_been_stalked__c = true,
                vpo_has_been_threatened__c = true
            ));
        Child_Involved__c child1 = vault.CreateContact(child)
            .GetChildInvolved(new Child_Involved__c(
                vpo_has_been_harassed__c = true,
                vpo_has_been_harmed__c = true,
                vpo_has_been_stalked__c = true,
                vpo_has_been_threatened__c = true
            ));
        VPO__c vpo = vault.GetVPO();

        FakeLASOData fake = SetupFake();

        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();
        
        System.assert(fake.sentAnswer.contains('Action of defendant raped TF'));
        System.assert(fake.sentAnswer.contains('Actions defendant harassed TF'));
        System.assert(fake.sentAnswer.contains('Actions of defendance threatened harm TF'));
        System.assert(fake.sentAnswer.contains('Actions of defendant stalked TF'));
        System.assert(fake.sentAnswer.contains(petitioner.Gender__c));
        System.assert(fake.sentAnswer.contains(petitioner.Race_Ethnicity__c));
        System.assert(fake.sentAnswer.contains(
            petitioner.birthdate.month()+'/'+
            petitioner.birthdate.day()+'/'+
            petitioner.birthdate.year()));
        System.assert(fake.sentAnswer.contains(petitioner.FirstName + ' ' + petitioner.lastname));
        System.assert(fake.sentAnswer.contains(child.Gender__c));
        System.assert(fake.sentAnswer.contains(child.Race_Ethnicity__c));
        System.assert(fake.sentAnswer.contains(
            child.birthdate.month()+'/'+child.birthdate.day()+'/'+child.birthdate.year()));
        System.assert(fake.sentAnswer.contains(child.FirstName + ' ' + child.lastname));
    }

    public static testmethod void AnswerFileContainsAllVPOFields() {
        DateTime leaveBy = DateTime.newInstance(2000, 1, 1, 10,  30, 20);        
        FluentTester vault = new FluentTester();
        vault.CreateCourtCase(new Court_Case__c(DistrictCourtCounty__c = 'Oklahoma'));
        VPO__c vpo = vault.GetVPO(new VPO__c(
            Emergency__c = true,
            LawEnforcementCopies__c = 'law',
            NoContact__c = true,
            NoInjury__c = true,
            NoIntimidation__c = true,
            LeaveResidence__c = true,
            LeaveAddress__c = 'leavea',
            LeaveCity__c = 'leavec',
            LeaveBy__c = leaveBy,
            DefendantAccompaniment__c = true,
            AccompanyAddress__c = 'accompanya',
            AccompanyCity__c = 'accompanyc',
            VisitationModification__c = true,
            RequestCounseling__c = true,
            ProtectAnimals__c = true,
            GPSMonitoring__c = true,
            TransferUtilities__c = true,
            UtilitiesToTransfer__c = 'utilities',
            RemoveWeapons__c = true,
            SurrenderWeaponsTo__c = 'surrender',
            Fees_Costs__c = true,
            AttorneyFees__c = true,
            FeeAmount__c = 100.50,
            AdditionalRelief__c = 'relief',
            CriminalChargesFiled__c = true,
            CriminalCaseDetails__c = 'casedetails'
        ));

        FakeLASOData fake = SetupFake();

        AnswerFileBuilder testee = new AnswerFileBuilder(vpo.Id, fake);
        testee.SendCaseToLASO();
        
        System.assert(fake.sentAnswer.contains(getTF('Emergency TF', vpo.Emergency__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief contact TF', vpo.NoContact__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief harming TF', vpo.NoInjury__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief threatening TF', vpo.NoIntimidation__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief leave TF', vpo.LeaveResidence__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief help defendant leave TF', vpo.DefendantAccompaniment__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief modify visits TF', vpo.VisitationModification__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief counseling TF', vpo.RequestCounseling__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief animals TF', vpo.ProtectAnimals__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief GPS TF', vpo.GPSMonitoring__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief xfer utilities TF', vpo.TransferUtilities__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief firearms TF', vpo.RemoveWeapons__c)));
        System.assert(fake.sentAnswer.contains(getTF('Relief attys fees TF', vpo.AttorneyFees__c)));
        System.assert(fake.sentAnswer.contains(getTF('Defendant criminal filed TF', true)));
        System.assert(fake.sentAnswer.contains(vpo.LawEnforcementCopies__c));
        System.assert(fake.sentAnswer.contains(vpo.CriminalCaseDetails__c));
        System.assert(fake.sentAnswer.contains(vpo.LeaveAddress__c));
        System.assert(fake.sentAnswer.contains(vpo.LeaveCity__c));
        System.assert(fake.sentAnswer.contains(vpo.UtilitiesToTransfer__c));
        System.assert(fake.sentAnswer.contains(vpo.SurrenderWeaponsTo__c));
        System.assert(fake.sentAnswer.contains(vpo.AdditionalRelief__c));
        System.assert(fake.sentAnswer.contains(String.valueOf(leaveBy.day())));
        System.assert(fake.sentAnswer.contains(String.valueOf(leaveBy.hour())));
        System.assert(fake.sentAnswer.contains(String.valueOf(leaveBy.month())));
        System.assert(fake.sentAnswer.contains(leaveBy.monthGmt()+'/'+leaveBy.dayGmt()+'/'+leaveBy.yearGmt()));
        System.assert(fake.sentAnswer.contains(String.valueOf(leaveBy.time())));
        System.assert(fake.sentAnswer.contains(String.valueOf(leaveBy.year())));
    }

    private static FakeLASOData SetupFake() {
        FakeLASOData fake = new FakeLASOData();        
        fake.AnswerResult = new List<String> { 'Success' };
        fake.LoginResult = new Map<String, String> {
            'username' => 'user',
            'password' => 'pass'
        };
        return fake;
    }

    private static string getTF(string name, boolean val) {
        string valStr = val ? 'true' : 'false';
        return '<Answer name="'+name+'"><TFValue>'+valStr+'</TFValue></Answer>';
    }
}