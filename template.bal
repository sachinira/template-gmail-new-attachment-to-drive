import ballerina/http;
import ballerina/log;
import ballerinax/googleapis_drive as drive;
import ballerinax/googleapis_gmail as gmail;
import ballerinax/googleapis_gmail.'listener as gmailListener;

// Event Trigger class
public class EventTrigger {
    public isolated function onNewSheetCreatedEvent(string fileId) {}

    public isolated function onSheetDeletedEvent(string fileId) {}

    public isolated function onFileUpdateEvent(string fileId) {}
}

// Google Drive client configuration
configurable http:OAuth2DirectTokenConfig & readonly driveOauthConfig = ?;

// Gmail client configuration
configurable http:OAuth2DirectTokenConfig & readonly gmailOauthConfig = ?;
configurable int & readonly port = ?;
configurable string & readonly topicName = ?;//////////

// Initialize Google Drive client 
drive:Configuration driveClientConfiguration = {
    clientConfig: driveOauthConfig
};

// Initialize Gmail client 
gmail:GmailConfiguration gmailClientConfiguration = {
    oauthClientConfig: gmailOauthConfig
};

// Create Google drive client
drive:Client driveClient = check new (driveClientConfiguration);

//  Create Gmail client.
gmail:Client gmailClient = new (gmailClientConfiguration);

// Create Gmail listener client.
listener gmailListener:Listener gmailEventListener = new(port, gmailClient, topicName);

service / on gmailEventListener {
    resource function post web(http:Caller caller, http:Request req) {
        var payload = req.getJsonPayload();
        var response = gmailEventListener.onMailboxChanges(caller , req);
        if(response is gmail:MailboxHistoryPage) {
            var triggerResponse = gmailEventListener.onNewAttachment(response);
            if(triggerResponse is gmail:MessageBodyPart[]) {
                if (triggerResponse.length()>0){
                    foreach var attachment in triggerResponse {
                        //log:print("Attachment Size: "+attachment.size);

                        drive:File|error fileResponse = driveClient->createFile(attachment.body);

                        if (fileResponse is drive:File) {
                            string id = fileResponse?.id.toString();
                            log:print(id);
                            log:print("Successfully added the file to the Google Drive");
                        } else {
                            log:printError(fileResponse.message());
                        }
                    }
                }
            }
        }
    }     
}
