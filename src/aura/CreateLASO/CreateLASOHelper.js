({
    _defaultRecord : {
        Id: "none",
        UserName__c: "No",
        Password__c: "Records",
        Status__c: "Returned",
        CreatedDate: null
    },

    GetResultRecords : function(cmp) {
        var self = this;
        this._serverCallPromise(cmp, "c.GetResults", {recordId : cmp.get("v.recordId") })
            .then($A.getCallback(function(x) {
                if (x.length > 0) {
                    cmp.set("v.results", x);
                }
                else {
                    cmp.set("v.results", [self._defaultRecord]);
                }
            }))
            .catch($A.getCallback(function() {
                cmp.set("v.results", [self._defaultRecord]);
            }));
    },

    SubmitToLASO : function(cmp) {
        var self = this;
        this._serverCallPromise(cmp, "c.Submit", { recordId : cmp.get("v.recordId") })
            .then($A.getCallback(function(x) {
                cmp.find("submitBtn").set("v.disabled", false);
                if (x.includes("Success")) {
                    self.toastSuccess("LASO Reports receiving Case successfully", "Successful Form Post");
                }
                else {
                    self.toastError(x);
                }
                self.GetResultRecords(cmp);
            }))
            .catch($A.getCallback(function() {
                cmp.find("submitBtn").set("v.disabled", false);
            }));
    },

    _serverCallPromise: function(cmp, methodName, args) {
        var self = this;
        var remoteMethod = cmp.get(methodName);
        remoteMethod.setParams(args);
        var promise = new Promise(function(resolve, reject) {
            remoteMethod.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    resolve(response.getReturnValue());
                }
                else {
                    var errors = response.getError();
                    reject(errors);
                    self.toastError("Unexpected communications error");
                }
            });
        });
        $A.enqueueAction(remoteMethod);

        return promise;
    },

    toastSuccess: function(text, title) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": text,
            "title": title || undefined,
            "duration": 900,
            "type": "success"
        });
        toastEvent.fire();
    },

    toastError: function(text) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": text,
            "duration": 900,
            "type": "error"
        });
        toastEvent.fire();
    }
});