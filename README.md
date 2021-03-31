# Template: Update Google Sheet to Send Gmail
When There are new attachments in Gmail, save them as a Google Drive file.<b

When there are files attached to emails it is difficult to trackdown them easily. File management purposes become a need
when they are valuable to the enterprise or a specific person and when there is need to reduce waste of time searching for attachments.
For this, there must be a proper way of managing file attachments in an email. This template integrates Gmail with 
Google Drive to achive that task with ease.
 
Whenever you get an email via Gmail with an attachment, this template will save the attachement file in Google Drive. 
By this way we can gurantee that the received attachment is saved in your google drive.

## Use this template to
- Save new Gmail attachments to Google Drive

## What you need
- A Google Cloud Platform Account

## How to set up
- Import the template.
- Allow access to the Gmail.
- Allow access to Google Drive.
- Provide the parent folder if necessary.
- Set up the template and run.

# Developer Guide
<p align="center">
<img src="./docs/images/gmail_new_attachment_to_drive.png?raw=true" alt="Gmail-Drive Integration template overview"/>
</p>

## Supported versions
<table>
  <tr>
   <td>Ballerina Language Version
   </td>
   <td>Swan Lake Alpha2
   </td>
  </tr>
  <tr>
   <td>Java Development Kit (JDK) 
   </td>
   <td>11
   </td>
  </tr>
  <tr>
   <td>Gmail API
   </td>
   <td>v1
   </td>
  </tr>
  <tr>
   <td>Google Drive API
   </td>
   <td>v3
   </td>
  </tr>
</table>

## Pre-requisites
* Download and install [Ballerina](https://ballerinalang.org/downloads/).
* A Google Cloud Platform Account
* Ballerina connectors for Gmail and Google Drive which will be automatically downloaded when building the application for the first time.

## Account Configuration
### Configuration of Google Drive account and Gmail account
Create a Google account and create a connected app by visiting [Google cloud platform APIs and Services](https://console.cloud.google.com/apis/dashboard). 

1. Click `Library` from the left side bar.
2. In the search bar enter Gmail/Google Drive
3. Then select Gmail/Google Drive API and click `Enable` button.
4. Complete OAuth Consent Screen setup.
5. Click `Credential` tab from left side bar. In the displaying window click `Create Credentials` button
6. Select OAuth client Id.
7. Fill the required field. Add https://developers.google.com/oauthplayground to the Redirect URI field.
8. Get client ID and client secret. Put it on the `Config.toml` file.
9. Visit https://developers.google.com/oauthplayground/ 
    Go to settings (Top right corner) -> Tick 'Use your own OAuth credentials' and insert Oauth client ID and client secret. 
    Click close.
10. Then,Complete step 1 (Select and Authorize APIs)
11. Make sure you select https://mail.google.com/, https://www.googleapis.com/auth/drive, & https://www.googleapis.com/auth/drive OAuth scopes.
12. Click `Authorize APIs` and You will be in step 2.
13. Exchange Auth code for tokens.
14. Copy `access token` and `refresh token`. Put it on the `Config.toml` file under Google Sheet configuration.
15. Obtain the relevant refresh URLs for each API and include them in the `Config.toml` file.

### Create push topic and subscription
To use Gmail Listener connector, a topic and a subscription should be configured.

1. Enable Cloud Pub/Sub API for your project which is created in [Google API Console](https://console.developers.google.com).
2. Go to [Google Cloud Pub/Sub API management console](https://console.cloud.google.com/cloudpubsub/topic/list)  and create a topic([You can follow the instructions here](https://cloud.google.com/pubsub/docs/quickstart-console) and a subscription to that topic. The subscription should be a pull subscription in this case ([Find mode details here](https://cloud.google.com/pubsub/docs/subscriber))).
3. For the push subscription , an endpoint URL should be given to push the notification. This URL is the URL where the gmail listener service runs. This should be in `https`  format. (If the service runs in localhost, then ngrok can be used to get an `https` URL).
4. Grant publish right on your topic. [To do this, see the instructions here](https://developers.google.com/gmail/api/guides/push#grant_publish_rights_on_your_topic).

5. Once you have done the above steps, get your topic name (It will be in the format of `projects/<YOUR_PROJECT_NAME>topics/<YOUR_TOPIC_NAME>`) from your console and give it to the `Config.toml` file as `topicName`.

## Config.toml 
```
[<ORG_NAME>.gmail_new_attachment_to_drive]
port = <PORT>
topicName = "<TOPIC_NAME>"
parentFolder = "<PARENT_FOLDER>"

[<ORG_NAME>.gmail_new_attachment_to_drive.driveOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "<DRIVE_REFRESH_URL>"
refreshToken = "<REFRESH_TOKEN>"

[<ORG_NAME>.gmail_new_attachment_to_drive.gmailOauthConfig]
clientId = "<CLIENT_ID>"
clientSecret = "<CLIENT_SECRET>"
refreshUrl = "<GMAIL_REFRESH_URL>"
refreshToken = "<REFRESH_TOKEN>"
```
## Running the template
1. First you need to build the integration template and create the executable binary. Run the following command from the 
   root directory of the integration template. 
`$ bal build`. 

2. Then you can run the integration binary with the following command. 
`$ target/bin/gmail_new_attachment_to_drive-0.1.0.jar`. 

Successful listener startup will print following in the console.
```
time = 2021-03-31 13:14:59,554 level = INFO  module = ballerinax/googleapis_gmail.listener message = "Starting History ID: 1421158" 
[ballerina/http] started HTTP/WS listener 0.0.0.0:8080
time = 2021-03-31 13:15:00,533 level = ERROR module = ballerinax/googleapis_gmail message = "Error occurred while getting history list" error = "{ballerina/lang.map}KeyNotFound" 
time = 2021-03-31 13:15:00,538 level = INFO  module = ballerinax/googleapis_gmail.listener message = "Next History ID = 1421160" 
```
**Note :** The `"{ballerina/lang.map}KeyNotFound"` error will not affect the usability of the template

3. Now you can aend a new email with an attachment and observe if integration template runtime has 
   logged the status of the response.

4. You can check the Google Drive verify if a new file is created. 
