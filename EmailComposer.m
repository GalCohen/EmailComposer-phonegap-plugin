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


#define RETURN_CODE_EMAIL_CANCELLED 0
#define RETURN_CODE_EMAIL_SAVED 1
#define RETURN_CODE_EMAIL_SENT 2
#define RETURN_CODE_EMAIL_FAILED 3
#define RETURN_CODE_EMAIL_NOTSENT 4

#import "EmailComposer.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface EmailComposer ()

-(void) showEmailComposerWithParameters:(NSDictionary*)parameters;
-(void) returnWithCode:(int)code;
-(NSString *) getMimeTypeFromFileExtension:(NSString *)extension;

@end

@implementation EmailComposer

// UNCOMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
//- (void) showEmailComposer:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [options valueForKey:@"toRecipients"], @"toRecipients",
//                                [options valueForKey:@"ccRecipients"], @"ccRecipients",
//                                [options valueForKey:@"bccRecipients"], @"bccRecipients",
//                                [options valueForKey:@"subject"], @"subject",
//                                [options valueForKey:@"body"], @"body",
//                                [options valueForKey:@"bIsHTML"], @"bIsHTML",
//                                [options valueForKey:@"attachments"], @"attachments",
//                                nil];
//    [self showEmailComposerWithParameters:parameters];
//}

// COMMENT THIS METHOD if you want to use the plugin with versions of cordova < 2.2.0
- (void) showEmailComposer:(CDVInvokedUrlCommand*)command {
    NSDictionary *parameters = [command.arguments objectAtIndex:0];
    [self showEmailComposerWithParameters:parameters];
}

-(void) showEmailComposerWithParameters:(NSDictionary*)parameters {
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.mailComposeDelegate = self;
    
	// set subject
    @try {
        NSString* subject = [parameters objectForKey:@"subject"];
        if (subject) {
            [mailComposer setSubject:subject];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EmailComposer - Cannot set subject; error: %@", exception);
    }
    
    // set body
    @try {
        NSString* body = [parameters objectForKey:@"body"];
        BOOL isHTML = [[parameters objectForKey:@"bIsHTML"] boolValue];
        if(body) {
            [mailComposer setMessageBody:body isHTML:isHTML];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EmailComposer - Cannot set body; error: %@", exception);
    }
    
	// Set recipients
    @try {
        NSArray* toRecipientsArray = [parameters objectForKey:@"toRecipients"];
        if(toRecipientsArray) {
            [mailComposer setToRecipients:toRecipientsArray];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EmailComposer - Cannot set TO recipients; error: %@", exception);
    }
    
    @try {
        NSArray* ccRecipientsArray = [parameters objectForKey:@"ccRecipients"];
        if(ccRecipientsArray) {
            [mailComposer setCcRecipients:ccRecipientsArray];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EmailComposer - Cannot set CC recipients; error: %@", exception);
    }
    
    @try {
        NSArray* bccRecipientsArray = [parameters objectForKey:@"bccRecipients"];
        if(bccRecipientsArray) {
            [mailComposer setBccRecipients:bccRecipientsArray];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EmailComposer - Cannot set BCC recipients; error: %@", exception);
    }
    
	@try {
        int counter = 1;
        NSArray *attachmentPaths = [parameters objectForKey:@"attachments"];
        if (attachmentPaths) {
            for (NSString* path in attachmentPaths) {
                @try {
                    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
                    [mailComposer addAttachmentData:data mimeType:[self getMimeTypeFromFileExtension:[path pathExtension]] fileName:[NSString stringWithFormat:@"attachment%d.%@", counter, [path pathExtension]]];
                    counter++;
                }
                @catch (NSException *exception) {
                    NSLog(@"Cannot attach file at path %@; error: %@", path, exception);
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EmailComposer - Cannot set attachments; error: %@", exception);
    }
    
    if (mailComposer != nil) {
        [self.viewController presentModalViewController:mailComposer animated:YES];
    } else {
        [self returnWithCode:RETURN_CODE_EMAIL_NOTSENT];
    }
    [mailComposer release];
}


// Dismisses the email composition interface when users tap Cancel or Send.
// Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
	int webviewResult = 0;
    
    switch (result) {
        case MFMailComposeResultCancelled:
			webviewResult = RETURN_CODE_EMAIL_CANCELLED;
            break;
        case MFMailComposeResultSaved:
			webviewResult = RETURN_CODE_EMAIL_SAVED;
            break;
        case MFMailComposeResultSent:
			webviewResult =RETURN_CODE_EMAIL_SENT;
            break;
        case MFMailComposeResultFailed:
            webviewResult = RETURN_CODE_EMAIL_FAILED;
            break;
        default:
			webviewResult = RETURN_CODE_EMAIL_NOTSENT;
            break;
    }
    
    [controller dismissModalViewControllerAnimated:YES];
    [self returnWithCode:webviewResult];
}

// Call the callback with the specified code
-(void) returnWithCode:(int)code {
    [self writeJavascript:[NSString stringWithFormat:@"window.plugins.emailComposer._didFinishWithResult(%d);", code]];
}

// Retrieve the mime type from the file extension
-(NSString *) getMimeTypeFromFileExtension:(NSString *)extension {
    if (!extension)
        return nil;
    CFStringRef pathExtension, type;
    // Get the UTI from the file's extension
    pathExtension = (CFStringRef)extension;
    type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    
    // Converting UTI to a mime type
    return (NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
}

@end