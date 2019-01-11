({
    doInit : function(cmp, evt, helper) {
        cmp.set("v.columns", [
            {label: "User Name", fieldName: "UserName__c", type: "text"},
            {label: "Password", fieldName: "Password__c", type: "text"},
            {label: "Request Status", fieldName: "Status__c", type: "text"},
            {label: "Sent", fieldName: "CreatedDate", type: "date"}
        ]);
        helper.GetResultRecords(cmp);
    },

    handleClick : function(cmp, evt, helper) {
        var btn = cmp.find("submitBtn");
        btn.set("v.disabled", true);
        cmp.set("v.label", "Sending...");
        helper.SubmitToLASO(cmp);
    }
});