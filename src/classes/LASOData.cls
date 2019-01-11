public class LASOData {
    private VPO__c vpo;
    private Abuser__c abuser;

    public LASOData(Id vpoCaseId) {
        vpo = [select Id, Name, Court_Case__c, Court_Case__r.Case__c, 
                Court_Case__r.DistrictCourtCounty__c,
                Court_Case__r.Case__r.LinkToClient__c, 
                Court_Case__r.Case__r.LinkToClient__r.FirstName__c,
                Court_Case__r.Case__r.LinkToClient__r.LastName__c, 
                Court_Case__r.Case__r.LinkToClient__r.DOB__c,
                Court_Case__r.Case__r.LinkToClient__r.City__c,
                Court_Case__r.Case__r.LinkToClient__r.CountyPick__c,
                Court_Case__r.Case__r.LinkToClient__r.CurrentAddress__c,
                Court_Case__r.Case__r.LinkToClient__r.Gender__c,
                Court_Case__r.Case__r.LinkToClient__r.MiddleName__c,
                Court_Case__r.Case__r.LinkToClient__r.PhysicalStatePick__c,
                Court_Case__r.Case__r.LinkToClient__r.RaceEthnicity__c,
                Court_Case__r.Case__r.LinkToClient__r.SafeEmail__c, 
                Court_Case__r.Case__r.LinkToClient__r.SafePhoneNumber__c,
                Court_Case__r.Case__r.LinkToClient__r.ZipCode__c,
                Court_Case__r.Case__r.LinkToClient__r.Address__c,
                Court_Case__r.Case__r.LinkToClient__r.MailingAddress__c,
                Court_Case__r.Case__r.LinkToClient__r.MailingCity__c,
                Court_Case__r.Case__r.LinkToClient__r.Suffix__c,
                Court_Case__r.Case__r.LinkToClient__r.MailingStatePick__c,
                Court_Case__r.Case__r.LinkToClient__r.MailingZip__c,
                Court_Case__r.Case__r.LinkToClient__r.OwnRent__c,
                Court_Case__r.Case__r.LinkToClient__r.PropertyDetails__c,
                Emergency__c, LawEnforcementCopies__c, 
                NoContact__c, NoInjury__c, NoIntimidation__c,
                LeaveResidence__c, LeaveAddress__c, 
                LeaveCity__c, 
                LeaveBy__c,
                DefendantAccompaniment__c, AccompanyAddress__c, 
                AccompanyCity__c, CriminalChargesFiled__c, CriminalCaseDetails__c,
                VisitationModification__c, RequestCounseling__c, ProtectAnimals__c, GPSMonitoring__c,
                TransferUtilities__c, UtilitiesToTransfer__c, RemoveWeapons__c, SurrenderWeaponsTo__c,
                Fees_Costs__c, AttorneyFees__c, FeeAmount__c, 
                AdditionalRelief__c
                from VPO__c 
                where Id = :vpoCaseId LIMIT 1];
        abuser = new Abuser__c();
    }

    public VPO__c GetCase() {
        return vpo;
    }

    public Abuser__c GetAbuserInfo() {
        List<Intake__c> intakes = 
            [select Id
            from Intake__c 
            where LinkToCase__c = :vpo.Court_Case__r.Case__c
            order by CreatedDate desc];
        
        if (intakes.size() == 0) {
            return abuser;
        }

        List<Abuser__c> abusers = 
            [select Id, Relationship__c, PhysicalAddress__c, MailingAddress__c, DOB__c,
                MailingCity__c, PhysicalCity__c, CriminalConvictions__c, County__c,
                ScarsMarksTattoos__c, WorkAddress__c, WorkSchedule__c, EyeColorPick__c,
                FacialHair__c, Gender__c, Glasses__c, HairLength__c, HairColorPick__c,
                Height__c, MedicalConditions__c, FirstName__c, LastName__c, MiddleName__c,
                Suffix__c, CellPhone__c, Probation_Parole__c, RaceEthnicity__c, PhysicalStatePick__c,
                WorkState__c, WorkCity__c, Work_Zip_Code__c,
                MailingStatePick__c, MissingTeeth__c, CarColor__c, CarMake__c,
                CarModel__c, CarStyle__c, CarYear__c, Weight__c, PhysicalZip__c,
                Weapon__c, WeaponType__c, Email__c, 
                EmployerName__c, WorkPhone__c, MailingZip__c
            from Abuser__c
            where LinkToIntake__c = :intakes[0].Id
            order by CreatedDate desc];
        
        if (abusers.size() > 0) {
            abuser = abusers[0];
        }

        return abuser;
    }

    public Client__c GetClient() {
        return new Client__c(
            FirstName__c = vpo.Court_Case__r.Case__r.LinkToClient__r.FirstName__c,
            LastName__c = vpo.Court_Case__r.Case__r.LinkToClient__r.LastName__c,
            DOB__c = vpo.Court_Case__r.Case__r.LinkToClient__r.DOB__c,
            City__c = vpo.Court_Case__r.Case__r.LinkToClient__r.City__c,
            CountyPick__c = vpo.Court_Case__r.Case__r.LinkToClient__r.CountyPick__c,
            Gender__c = vpo.Court_Case__r.Case__r.LinkToClient__r.Gender__c,
            MiddleName__c = vpo.Court_Case__r.Case__r.LinkToClient__r.MiddleName__c,
            PhysicalStatePick__c = vpo.Court_Case__r.Case__r.LinkToClient__r.PhysicalStatePick__c, 
            RaceEthnicity__c = vpo.Court_Case__r.Case__r.LinkToClient__r.RaceEthnicity__c,
            SafeEmail__c = vpo.Court_Case__r.Case__r.LinkToClient__r.SafeEmail__c,
            SafePhoneNumber__c = vpo.Court_Case__r.Case__r.LinkToClient__r.SafePhoneNumber__c,
            ZipCode__c = vpo.Court_Case__r.Case__r.LinkToClient__r.ZipCode__c,
            Address__c = vpo.Court_Case__r.Case__r.LinkToClient__r.Address__c,
            MailingAddress__c = vpo.Court_Case__r.Case__r.LinkToClient__r.MailingAddress__c,
            MailingCity__c = vpo.Court_Case__r.Case__r.LinkToClient__r.MailingCity__c,
            Suffix__c = vpo.Court_Case__r.Case__r.LinkToClient__r.Suffix__c,            
            MailingStatePick__c = vpo.Court_Case__r.Case__r.LinkToClient__r.MailingStatePick__c,
            MailingZip__c = vpo.Court_Case__r.Case__r.LinkToClient__r.MailingZip__c,
            OwnRent__c = vpo.Court_Case__r.Case__r.LinkToClient__r.OwnRent__c,
            PropertyDetails__c = vpo.Court_Case__r.Case__r.LinkToClient__r.PropertyDetails__c,
            Id = vpo.Court_Case__r.Case__r.LinkToClient__c
        );
    }

    public String ConvertRelationship(string relationship) {
        if (relationship == 'Spouse') {
            return 'Relationship married';
        } else if (relationship == 'Ex-Spouse') {
            return 'Relationship divorced';
        } else if (relationship == 'Ex-Partner') {
            return 'Relationship previously dated';
        } else if (relationship == 'Roommate') {
            return 'Relationship live tog';
        } else if (relationship == 'Parent' || relationship == 'Child') {
            return 'Relationship parent/child';
        } else if (relationship == 'Other Family Member') {
            return 'Relationship by blood';
        } else {
            return '--';
        }        
    }

    public List<Child_Involved__c> GetChildrenInvolved() {
        return [select Id, Contact__r.Name, Contact__r.Birthdate,
                    Contact__r.Gender__c, Contact__r.Race_Ethnicity__c,
                    VPO_has_been_harassed__c, VPO_has_been_harmed__c,
                    VPO_has_been_stalked__c, VPO_has_been_threatened__c
                from Child_Involved__c
                where Court_Case__c = :vpo.Court_Case__c];
    }

    public List<Petitioner_Invovled__c> GetInvolvedPetitioners() {
        return [select Id, Contact__r.Name, Contact__r.Birthdate,
                    Contact__r.Gender__c, Contact__r.Race_Ethnicity__c,
                    VPO_has_been_harassed__c, VPO_has_been_harmed__c,
                    VPO_has_been_stalked__c, VPO_has_been_threatened__c
                from Petitioner_Invovled__c
                where Court_Case__c = :vpo.Court_Case__c];
    }
}