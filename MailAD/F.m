//
//  F.m
//  
//
//  Created by Алексей on 5/24/19.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>

class FRONT {

MCOIMAPSession *session = [[MCOIMAPSession alloc] init];
[session setHostname:@"imap.gmail.com"];
[session setPort:993];
[session setUsername:@"ADDRESS@gmail.com"];
[session setPassword:@"123456"];
[session setConnectionType:MCOConnectionTypeTLS];

MCOIMAPMessagesRequestKind requestKind = MCOIMAPMessagesRequestKindHeaders;
NSString *folder = @"INBOX";
MCOIndexSet *uids = [MCOIndexSet indexSetWithRange:MCORangeMake(1, UINT64_MAX)];

MCOIMAPFetchMessagesOperation *fetchOperation = [session fetchMessagesOperationWithFolder:folder requestKind:requestKind uids:uids];

[fetchOperation start:^(NSError * error, NSArray * fetchedMessages, MCOIndexSet * vanishedMessages) {
    //We've finished downloading the messages!

    //Let's check if there was an error:
    if(error) {
        NSLog(@"Error downloading message headers:%@", error);
    }

    //And, let's print out the messages...
    NSLog(@"The post man delivereth:%@", fetchedMessages);
    }];
}
