/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2013 Gal Cohen

 * Original code from:
 * https://github.com/guidosabatini -  android: https://github.com/phonegap/phonegap-plugins/tree/master/Android/EmailComposerWithAttachments
 * Randy McMillan - ios and js https://github.com/phonegap/phonegap-plugins/tree/5cf45fcade4989668e95a6d34630d2021c45291a/iOS/SMSComposer
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 *
 * Email Composer plugin for PhoneGap/Cordova
 * window.plugins.emailComposer
 *
 * Unified and updated API to be cross-platform by Gal Cohen in 2013.
 * galcohen26@gmail.com
 * https://github.com/GalCohen
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