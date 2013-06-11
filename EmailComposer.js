/**
 *
 * Email Composer plugin for PhoneGap/Cordova
 * window.plugins.emailComposer
 *
 * Unified and updated API to be cross-platform by Gal Cohen in 2013.
 * galcohen26@gmail.com
 * https://github.com/GalCohen
 *
 * Original code from:
 * android: https://github.com/phonegap/phonegap-plugins/tree/master/Android/EmailComposerWithAttachments
 * ios https://github.com/phonegap/phonegap-plugins/tree/5cf45fcade4989668e95a6d34630d2021c45291a/iOS/SMSComposer
 * js: https://github.com/phonegap/phonegap-plugins/blob/5cf45fcade4989668e95a6d34630d2021c45291a/iOS/SMSComposer/SMSComposer.js
 *
 */


/*
 * Temporary Scope to contain the plugin.
 */
(function() {
     /* Get local ref to global PhoneGap/Cordova/cordova object for exec function.
      - This increases the compatibility of the plugin. */
     var cordovaRef = window.PhoneGap || window.Cordova || window.cordova; // old to new fallbacks
     
    function EmailComposer() {
        this.resultCallback = null; // Function
    }

    EmailComposer.ComposeResultType = {
        Cancelled:0,
        Saved:1,
        Sent:2,
        Failed:3,
        NotSent:4
    }

    // showEmailComposer : all args optional
    EmailComposer.prototype.showEmailComposer = function(subject, body, toRecipients, ccRecipients, bccRecipients, bIsHTML, attachments) {
        var args = {};
        args.subject = subject ? subject : "";
        args.body = body ? body : "";
        args.toRecipients = toRecipients ? toRecipients : [];
        args.ccRecipients = ccRecipients ? ccRecipients : [];
        args.bccRecipients = bccRecipients ? bccRecipients : [];
        args.bIsHTML = bIsHTML ? true : false;
        args.attachments = attachments ? attachments : [];
        cordovaRef.exec(null, null, "EmailComposer", "showEmailComposer", [args]);
    }

    EmailComposer.prototype.showEmailComposerWithCallback = function(callback, subject, body, toRecipients, ccRecipients, bccRecipients, isHTML, attachments) {
        this.resultCallback = callback;
        this.showEmailComposer.apply(this, [subject, body, toRecipients, ccRecipients, bccRecipients, isHTML, attachments]);
    }

    EmailComposer.prototype._didFinishWithResult = function(res) {
        this.resultCallback(res);
    }

    cordovaRef.addConstructor(function() {
           if (!window.plugins) {
                window.plugins = {};
           }
                                           
            if (!window.plugins.emailComposer) {
               window.plugins.emailComposer = new EmailComposer();
                console.log("**************************** Email Composer ready *************************");
            }
        });
})();/* End of Temporary Scope. */