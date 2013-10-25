
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