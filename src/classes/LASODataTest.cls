@isTest
public class LASODataTest {
    public static testmethod void PullsCaseInfo() {
        VPO__c vpo = new FluentTester().GetVPO();

        LASOData testee = new LASOData(vpo.Id);
        VPO__c result = testee.GetCase();

        System.assertEquals(vpo.Name, result.Name);
    }

    public static testmethod void GetsClientInfo() {
        FluentTester vault = new FluentTester();
        Client__c client = vault.GetClient();
        VPO__c vpo = vault.GetVPO();

        LASOData testee = new LASOData(vpo.Id);
        Client__c result = testee.GetClient();

        System.assertEquals(client.FirstName__c, result.FirstName__c);
        System.assertEquals(client.LastName__c, result.LastName__c);
        System.assertEquals(client.City__c, result.City__c);
        System.assertEquals(client.CountyPick__c, result.CountyPick__c);
        System.assertEquals(client.CurrentAddress__c, result.CurrentAddress__c);
        System.assertEquals(client.Gender__c, result.Gender__c);
        System.assertEquals(client.MiddleName__c, result.MiddleName__c);
        System.assertEquals(client.PhysicalStatePick__c, result.PhysicalStatePick__c);
        System.assertEquals(client.RaceEthnicity__c, result.RaceEthnicity__c);
        System.assertEquals(client.SafeEmail__c, result.SafeEmail__c);
        System.assertEquals(client.SafePhoneNumber__c, result.SafePhoneNumber__c);
        System.assertEquals(client.ZipCode__c, result.ZipCode__c);
        System.assertEquals(Date.newInstance(1990, 1, 1), result.DOB__c);
        System.assertEquals(client.Id, result.Id);
    }

    public static testmethod void GetsAbuserInfo() {
        FluentTester vault = new FluentTester();
        Abuser__c abuser = vault
            .CreateClient()
            .CreateCase()
            .CreateIntake()
            .GetAbuser();   
        VPO__c vpo = vault
            .CreateCourtCase()
            .GetVPO();
        /*Court_Case__c court = getCourtCase(new Case__c());
        VPO__c vpo = getVPO(court);
        Abuser__c abuser = getAbuser(getIntake(new Case__c(Id = court.Case__c)));*/

        LASOData testee = new LASOData(vpo.Id);
        Abuser__c result = testee.GetAbuserInfo();

        System.assertEquals(abuser.DOB__c, result.DOB__c);
        System.assertEquals(abuser.EyeColorPick__c, result.EyeColorPick__c);
        System.assertEquals(abuser.FirstName__c, result.FirstName__c);
        System.assertEquals(abuser.Gender__c, result.Gender__c);
        System.assertEquals(abuser.Height__c, result.Height__c);
        System.assertEquals(abuser.LastName__c, result.LastName__c);
        System.assertEquals(abuser.MiddleName__c, result.MiddleName__c);
        System.assertEquals(abuser.RaceEthnicity__c, result.RaceEthnicity__c);
        System.assertEquals(abuser.Relationship__c, result.Relationship__c);
        System.assertEquals(abuser.Weight__c, result.Weight__c);
        System.assertEquals(abuser.Id, result.Id);
    }

    public static testmethod void GetsLatestAbuser() {
        FluentTester vault = new FluentTester();
        Abuser__c latest = vault
            .CreateAbuser()
            .CreateAbuser()
            .GetAbuser();
        VPO__c vpo = vault.GetVPO();

        Test.setCreatedDate(latest.Id, Date.Today().addDays(1));

        LASOData testee = new LASOData(vpo.Id);
        Abuser__c result = testee.GetAbuserInfo();

        System.assertEquals(latest.Id, result.Id);
    }

    public static testmethod void UsesLatestIntake() {
        FluentTester vault = new FluentTester();
        Abuser__c abuser = vault
            .CreateIntake()
            .CreateAbuser()
            .CreateIntake()
            .GetAbuser();
        VPO__c vpo = vault.GetVPO();

        Test.setCreatedDate(abuser.LinkToIntake__c, Date.Today().addDays(1));
        
        LASOData testee = new LASOData(vpo.Id);
        Abuser__c result = testee.GetAbuserInfo();

        System.assertEquals(abuser.Id, result.Id);
    }

    public static testmethod void GetsAllChildrenInvolved() {
        FluentTester vault = new FluentTester();
        Child_Involved__c child1 = vault.CreateContact(new Contact(FirstName = 'First', LastName = 'One'))
            .GetChildInvolved();
        Child_Involved__c child2 = vault.CreateContact(new Contact(FirstName = 'Another', LastName = 'Two'))
            .GetChildInvolved();
        VPO__c vpo = vault.GetVPO();

        LASOData testee = new LASOData(vpo.Id);

        Map<Id, Child_Involved__c> allChildren = 
            new Map<Id, Child_Involved__c>(testee.GetChildrenInvolved());

        System.assertEquals(2, allChildren.keyset().size());
        System.assert(allChildren.keyset().contains(child1.Id));
        System.assert(allChildren.keyset().contains(child2.Id));

        Child_Involved__c first = allChildren.get(child1.Id);
        Child_Involved__c second = allChildren.get(child2.Id);
        System.assertEquals('First One', first.Contact__r.Name);
        System.assertEquals('Another Two', second.Contact__r.Name);
    }

    public static testmethod void GetsAllPetitionersInvolved() {
        FluentTester vault = new FluentTester();
        Petitioner_Invovled__c pet1 = vault.CreateContact(new Contact(FirstName = 'First', LastName = 'One'))
            .GetPetitionerInvolved();
        Petitioner_Invovled__c pet2 = vault.CreateContact(new Contact(FirstName = 'Another', LastName = 'Two'))
            .GetPetitionerInvolved();
        VPO__c vpo = vault.GetVPO();

        LASOData testee = new LASOData(vpo.Id);

        Map<Id, Petitioner_Invovled__c> allPets = 
            new Map<Id, Petitioner_Invovled__c>(testee.GetInvolvedPetitioners());

        System.assertEquals(2, allPets.keyset().size());
        System.assert(allPets.keyset().contains(pet1.Id));
        System.assert(allPets.keyset().contains(pet2.Id));

        Petitioner_Invovled__c first = allPets.get(pet1.Id);
        Petitioner_Invovled__c second = allPets.get(pet2.Id);
        System.assertEquals('First One', first.Contact__r.Name);
        System.assertEquals('Another Two', second.Contact__r.Name);
    }

    public static testmethod void GetsCorrectRelationship() {
        Map<String, String> relationships = new Map<String, String>{
            'Spouse' => 'Relationship married',
            'Ex-Spouse' => 'Relationship divorced',
            'Boyfriend' => '--',
            'Girlfriend' => '--',
            'Ex-Partner' => 'Relationship previously dated',
            'Stranger' => '--',
            'Roommate' => 'Relationship live tog',
            'Parent' => 'Relationship parent/child',
            'Child' => 'Relationship parent/child',
            'Acquaintance' => '--',
            'Classmate/Colleague' => '--',
            'Other Family Member' => 'Relationship by blood'
        };

        FluentTester vault = new FluentTester();
        VPO__c vpo = vault.GetVPO();
        LASOData testee = new LASOData(vpo.Id);

        for (string relationship : relationships.keyset()) {
            System.assertEquals(
                relationships.get(relationship), 
                testee.ConvertRelationship(relationship));
        }
    }
}