/**
 * Email Composer plugin for PhoneGap/Cordova
 * window.plugins.emailComposer
 *
 * Unified and updated API to be cross-platform by Gal Cohen in 2013.
 * galcohen26@gmail.com
 * https://github.com/GalCohen
 *
 * Originally created by Guido Sabatini in 2012.
 * Original code from:
 * android: https://github.com/phonegap/phonegap-plugins/tree/master/Android/EmailComposerWithAttachments
 * ios https://github.com/phonegap/phonegap-plugins/tree/5cf45fcade4989668e95a6d34630d2021c45291a/iOS/SMSComposer
 * js: https://github.com/phonegap/phonegap-plugins/blob/5cf45fcade4989668e95a6d34630d2021c45291a/iOS/SMSComposer/SMSComposer.js
 *
 */

//  EmailComposer.h
//
//  Version 2.1


#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Cordova/CDVPlugin.h>


@interface EmailComposer : CDVPlugin <MFMailComposeViewControllerDelegate> {
    
    
}

// UNCOMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
//- (void) showEmailComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

// COMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
- (void) showEmailComposer:(CDVInvokedUrlCommand*)command;

@end