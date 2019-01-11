public class FluentTester {
    private Id latestClientId;
    private Id latestCaseId;
    private Id latestIntakeId;
    private Id latestAbuserId;
    private Id latestCourtCaseId;
    private Id latestVPOId;
    private Id latestContactId;
    private Id latestChildInvolvedId;
    private Id latestPetitionerInvolvedId;

    public FluentTester() {}

    public FluentTester CreateClient() {
        this.GetClient();
        return this;
    }

    public FluentTester CreateClient(Client__c client) {
        this.GetClient(client);
        return this;
    }

    public Client__c GetClient(Client__c client) {
        insert client;
        latestClientId = client.Id;
        return client;
    }

    public Client__c GetClient() {
        Client__c client = new Client__c(
            FirstName__c = 'first',
            LastName__c = 'last',
            DOB__c = Date.newInstance(1990, 1, 1),
            City__c = 'Tulsa',
            CountyPick__c = 'Tulsa',
            Gender__c = 'Male',
            MiddleName__c = 'middle',
            PhysicalStatePick__c = 'Oklahoma',
            RaceEthnicity__c = 'Asian',
            SafeEmail__c = 'palomar@palomar.palomar',
            SafePhoneNumber__c = '1234567890',
            ZipCode__c = '12345'
        );
        insert client;
        latestClientId = client.Id;
        return client;
    }

    private Id getLatestClientId() {
        return latestClientId == null
            ? this.GetClient().Id
            : latestClientId;
    }

    public FluentTester CreateCase() {
        this.GetCase();
        return this;
    }

    public FluentTester CreateCase(Case__c pcase) {
        this.GetCase(pcase);
        return this;
    }

    public Case__c GetCase(Case__c pcase) {        
        pcase.LinkToClient__c = getLatestClientId();
        
        insert pcase;
        latestCaseId = pcase.Id;
        return pcase;
    }

    public Case__c GetCase() {
        Case__c pcase = new Case__c(
            LinkToClient__c = getLatestClientId()
        );
        insert pcase;
        latestCaseId = pcase.Id;
        return pcase;
    }

    private Id getLatestCaseId() {
        return latestCaseId == null
            ? this.GetCase().Id
            : latestCaseId;
    }

    public FluentTester CreateIntake() {
        this.GetIntake();
        return this;
    }

    public FluentTester CreateIntake(Intake__c intake) {
        this.GetIntake(intake);
        return this;
    }

    public Intake__c GetIntake(Intake__c intake) {
        intake.LinkToCase__c = getLatestCaseId();

        insert intake;
        latestIntakeId = intake.Id;
        return intake;
    }

    public Intake__c GetIntake() {
        Intake__c intake = new Intake__c(
            LinkToCase__c = getLatestCaseId(),
            ClientIdentifiedNeeds__c = 'Computer Lab'
        );
        insert intake;
        latestIntakeId = intake.Id;
        return intake;
    }

    private Id getLatestIntakeId() {
        return latestIntakeId == null
            ? this.GetIntake().Id
            : latestIntakeId;
    }

    public FluentTester CreateAbuser() {
        this.GetAbuser();
        return this;
    }

    public FluentTester CreateAbuser(Abuser__c abuser) {
        this.GetAbuser(abuser);
        return this;
    }

    public Abuser__c GetAbuser(Abuser__c abuser) {
        abuser.LinkToIntake__c = getLatestIntakeId();

        insert abuser;
        latestAbuserId = abuser.Id;
        return abuser;
    }

    public Abuser__c GetAbuser() {
        Abuser__c abuser = new Abuser__c(
            LinkToIntake__c = getLatestIntakeId(),
            DOB__c = Date.newInstance(1990, 1, 1),
            EyeColorPick__c = 'Blue',
            FirstName__c = 'abuser',
            Gender__c = 'Male',
            Height__c = 'test height',
            IdentifyingFeatures__c = 'test features',
            LastName__c = 'last',
            MiddleName__c = 'midd',
            RaceEthnicity__c = 'Asian',
            Relationship__c = 'Spouse',
            Weight__c = '100'
        );
        insert abuser;
        latestAbuserId = abuser.Id;
        return abuser;
    }

    public FluentTester CreateCourtCase() {
        this.GetCourtCase();
        return this;
    }

    public FluentTester CreateCourtCase(Court_Case__c courtCase) {
        this.GetCourtCase(courtCase);
        return this;
    }

    public Court_Case__c GetCourtCase(Court_Case__c courtCase) {
        courtCase.Case__c = getLatestCaseId();

        insert courtCase;
        latestCourtCaseId = courtCase.Id;
        return courtCase;
    }

    public Court_Case__c GetCourtCase() {
        Court_Case__c courtCase = new Court_Case__c(
            Case__c = getLatestCaseId()
        );
        insert courtCase;
        latestCourtCaseId = courtCase.Id;
        return courtCase;
    }

    private Id getLatestCourtCaseId() {
        return latestCourtCaseId == null
            ? this.GetCourtCase().Id
            : latestCourtCaseId;
    }

    public FluentTester CreateVPO() {
        this.GetVPO();
        return this;
    }

    public FluentTester CreateVPO(VPO__c vpo) {
        this.GetVPO(vpo);
        return this;
    }

    public VPO__c GetVPO(VPO__c vpo) {
        vpo.Court_Case__c = getLatestCourtCaseId();
        insert vpo;
        latestVPOId = vpo.Id;
        return vpo;
    }

    public VPO__c GetVPO() {
        VPO__c vpo = new VPO__c(
            Court_Case__c = getLatestCourtCaseId(),
            Name = 'Test VPO'
        );
        insert vpo;
        latestVPOId = vpo.Id;
        return vpo;
    }

    public FluentTester CreateContact() {
        this.GetContact();
        return this;
    }

    public FluentTester CreateContact(Contact c) {
        this.GetContact(c);
        return this;
    }

    public Contact GetContact(Contact c) {
        insert c;
        latestContactId = c.Id;
        return c;
    }

    public Contact GetContact() {
        Contact c = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Birthdate = Date.newInstance(1990, 1, 1),
            Gender__c = 'Male'
        );
        insert c;
        latestContactId = c.Id;
        return c;
    }

    private Id getLatestContactId() {
        return latestContactId == null
            ? this.GetContact().Id
            : latestContactId;
    }

    public FluentTester CreateChildInvolved() {
        this.GetChildInvolved();
        return this;
    }

    public FluentTester CreateChildInvolved(Child_Involved__c child) {
        this.GetChildInvolved(child);
        return this;
    }

    public Child_Involved__c GetChildInvolved(Child_Involved__c child) {
        child.Contact__c = getLatestContactId();
        child.Court_Case__c = getLatestCourtCaseId();

        insert child;
        latestChildInvolvedId = child.Id;
        return child;
    }

    public Child_Involved__c GetChildInvolved() {
        Child_Involved__c child = new Child_Involved__c(
            Contact__c = getLatestContactId(),
            Court_Case__c = getLatestCourtCaseId()
        );
        insert child;
        latestChildInvolvedId = child.Id;
        return child;
    }

    private Id getLatestChildInvolvedId() {
        return latestChildInvolvedId == null
            ? this.GetChildInvolved().Id
            : latestChildInvolvedId;
    }

    public FluentTester CreatePetitionerInvolved() {
        this.GetChildInvolved();
        return this;
    }

    public FluentTester CreatePetitionerInvolved(Petitioner_Invovled__c petitioner) {
        this.GetPetitionerInvolved(petitioner);
        return this;
    }

    public Petitioner_Invovled__c GetPetitionerInvolved(Petitioner_Invovled__c petitioner) {
        petitioner.Contact__c = getLatestContactId();
        petitioner.Court_Case__c = getLatestCourtCaseId();

        insert petitioner;
        latestPetitionerInvolvedId = petitioner.Id;
        return petitioner;
    }

    public Petitioner_Invovled__c GetPetitionerInvolved() {
        Petitioner_Invovled__c petitioner = new Petitioner_Invovled__c(
            Contact__c = getLatestContactId(),
            Court_Case__c = getLatestCourtCaseId()
        );
        insert petitioner;
        latestPetitionerInvolvedId = petitioner.Id;
        return petitioner;
    }

    private Id getLatestPetitionerInvolvedId() {
        return latestPetitionerInvolvedId == null
            ? this.GetPetitionerInvolved().Id
            : latestPetitionerInvolvedId;
    }
}