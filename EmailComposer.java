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


package org.apache.cordova;

import java.io.File;
import java.util.ArrayList;

import org.apache.cordova.api.CallbackContext;
import org.apache.cordova.api.CordovaPlugin;
import org.apache.cordova.api.LOG;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.net.Uri;
import android.text.Html;

public class EmailComposer extends CordovaPlugin {

	@Override
	public boolean execute(String action, JSONArray args,
			CallbackContext callbackContext) throws JSONException {
		System.out.println(args.toString());
		if ("showEmailComposer".equals(action)) {

			try {
				JSONObject parameters = args.getJSONObject(0);
				if (parameters != null) {
					sendEmail(parameters);
				}
			} catch (Exception e) {

			}
			callbackContext.success();
			return true;
		}
		return false; // Returning false results in a "MethodNotFound" error.
	}

	private void sendEmail(JSONObject parameters) {

		final Intent emailIntent = new Intent(
				android.content.Intent.ACTION_SEND_MULTIPLE);

		// String callback = parameters.getString("callback");
		System.out.println(parameters.toString());

		boolean isHTML = false;
		try {
			isHTML = parameters.getBoolean("bIsHTML");
		} catch (Exception e) {
			LOG.e("EmailComposer",
					"Error handling isHTML param: " + e.toString());
		}

		if (isHTML) {
			emailIntent.setType("text/html");
		} else {
			emailIntent.setType("text/plain");
		}

		// setting subject
		try {
			String subject = parameters.getString("subject");
			if (subject != null && subject.length() > 0) {
				emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT,
						subject);
			}
		} catch (Exception e) {
			LOG.e("EmailComposer",
					"Error handling subject param: " + e.toString());
		}

		// setting body
		try {
			String body = parameters.getString("body");
			if (body != null && body.length() > 0) {
				if (isHTML) {
					emailIntent.putExtra(android.content.Intent.EXTRA_TEXT,
							Html.fromHtml(body));
				} else {
					emailIntent.putExtra(android.content.Intent.EXTRA_TEXT,
							body);
				}
			}
		} catch (Exception e) {
			LOG.e("EmailComposer", "Error handling body param: " + e.toString());
		}

		// setting TO recipients
		try {
			JSONArray toRecipients = parameters.getJSONArray("toRecipients");
			if (toRecipients != null && toRecipients.length() > 0) {
				String[] to = new String[toRecipients.length()];
				for (int i = 0; i < toRecipients.length(); i++) {
					to[i] = toRecipients.getString(i);
				}
				emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, to);
			}
		} catch (Exception e) {
			LOG.e("EmailComposer",
					"Error handling toRecipients param: " + e.toString());
		}

		// setting CC recipients
		try {
			JSONArray ccRecipients = parameters.getJSONArray("ccRecipients");
			if (ccRecipients != null && ccRecipients.length() > 0) {
				String[] cc = new String[ccRecipients.length()];
				for (int i = 0; i < ccRecipients.length(); i++) {
					cc[i] = ccRecipients.getString(i);
				}
				emailIntent.putExtra(android.content.Intent.EXTRA_CC, cc);
			}
		} catch (Exception e) {
			LOG.e("EmailComposer",
					"Error handling ccRecipients param: " + e.toString());
		}

		// setting BCC recipients
		try {
			JSONArray bccRecipients = parameters.getJSONArray("bccRecipients");
			if (bccRecipients != null && bccRecipients.length() > 0) {
				String[] bcc = new String[bccRecipients.length()];
				for (int i = 0; i < bccRecipients.length(); i++) {
					bcc[i] = bccRecipients.getString(i);
				}
				emailIntent.putExtra(android.content.Intent.EXTRA_BCC, bcc);
			}
		} catch (Exception e) {
			LOG.e("EmailComposer",
					"Error handling bccRecipients param: " + e.toString());
		}

		// setting attachments
		try {
			JSONArray attachments = parameters.getJSONArray("attachments");
			if (attachments != null && attachments.length() > 0) {
				ArrayList<Uri> uris = new ArrayList<Uri>();
				// convert from paths to Android friendly Parcelable Uri's
				for (int i = 0; i < attachments.length(); i++) {
					try {
						File file = new File(attachments.getString(i));
						if (file.exists()) {
							Uri uri = Uri.fromFile(file);
							uris.add(uri);
						}
					} catch (Exception e) {
						LOG.e("EmailComposer", "Error adding an attachment: "
								+ e.toString());
					}
				}
				if (uris.size() > 0) {
					emailIntent.putParcelableArrayListExtra(
							Intent.EXTRA_STREAM, uris);
				}
			}
		} catch (Exception e) {
			LOG.e("EmailComposer",
					"Error handling attachments param: " + e.toString());
		}

		this.cordova.startActivityForResult(this, emailIntent, 0);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent intent) {
		// TODO handle callback
		super.onActivityResult(requestCode, resultCode, intent);
		LOG.e("EmailComposer", "ResultCode: " + resultCode);
		// IT DOESN'T SEEM TO HANDLE RESULT CODES
	}

}