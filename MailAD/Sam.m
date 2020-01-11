//
//  Sam.m
//  MailAD
//
//  Created by Алексей on 5/27/19.
//  Copyright © 2019 Алексей. All rights reserved.
//

#import <Foundation/Foundation.h>

Class Hand;

- (void)loadAccountWithUsername:(NSString *)username
password:(NSString *)password
hostname:(NSString *)hostname
oauth2Token:(NSString *)oauth2Token
{
    self.imapSession = [[MCOIMAPSession alloc] init];
    self.imapSession.hostname = hostname;
    self.imapSession.port = 993;
    self.imapSession.username = username;
    self.imapSession.password = password;
    if (oauth2Token != nil) {
        self.imapSession.OAuth2Token = oauth2Token;
        self.imapSession.authType = MCOAuthTypeXOAuth2;
    }
    self.imapSession.connectionType = MCOConnectionTypeTLS;
    MasterViewController * __weak weakSelf = self;
    self.imapSession.connectionLogger = ^(void * connectionID, MCOConnectionLogType type, NSData * data) {
        @synchronized(weakSelf) {
            if (type != MCOConnectionLogTypeSentPrivate) {
                //                NSLog(@"event logged:%p %i withData: %@", connectionID, type, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            }
        }
    };

    // Reset the inbox
    self.messages = nil;
    self.totalNumberOfInboxMessages = -1;
    self.isLoading = NO;
    self.messagePreviews = [NSMutableDictionary dictionary];
    [self.tableView reloadData];

    NSLog(@"checking account");
    self.imapCheckOp = [self.imapSession checkAccountOperation];
    [self.imapCheckOp start:^(NSError *error) {
        MasterViewController *strongSelf = weakSelf;
        NSLog(@"finished checking account.");
        if (error == nil) {
            [strongSelf loadLastNMessages:NUMBER_OF_MESSAGES_TO_LOAD];
        } else {
            NSLog(@"error loading account: %@", error);
        }

        strongSelf.imapCheckOp = nil;
    }];
}

- (void)loadLastNMessages:(NSUInteger)nMessages
{
    self.isLoading = YES;

    MCOIMAPMessagesRequestKind requestKind = (MCOIMAPMessagesRequestKind)
    (MCOIMAPMessagesRequestKindHeaders | MCOIMAPMessagesRequestKindStructure |
     MCOIMAPMessagesRequestKindInternalDate | MCOIMAPMessagesRequestKindHeaderSubject |
     MCOIMAPMessagesRequestKindFlags);

    NSString *inboxFolder = @"INBOX";
    MCOIMAPFolderInfoOperation *inboxFolderInfo = [self.imapSession folderInfoOperation:inboxFolder];

    [inboxFolderInfo start:^(NSError *error, MCOIMAPFolderInfo *info)
     {
         BOOL totalNumberOfMessagesDidChange =
         self.totalNumberOfInboxMessages != [info messageCount];

         self.totalNumberOfInboxMessages = [info messageCount];

         NSUInteger numberOfMessagesToLoad =
         MIN(self.totalNumberOfInboxMessages, nMessages);

         if (numberOfMessagesToLoad == 0)
         {
             self.isLoading = NO;
             return;
         }

         MCORange fetchRange;

         // If total number of messages did not change since last fetch,
         // assume nothing was deleted since our last fetch and just
         // fetch what we don't have
         if (!totalNumberOfMessagesDidChange && self.messages.count)
         {
             numberOfMessagesToLoad -= self.messages.count;

             fetchRange =
             MCORangeMake(self.totalNumberOfInboxMessages -
                          self.messages.count -
                          (numberOfMessagesToLoad - 1),
                          (numberOfMessagesToLoad - 1));
         }

         // Else just fetch the last N messages
         else
         {
             fetchRange =
             MCORangeMake(self.totalNumberOfInboxMessages -
                          (numberOfMessagesToLoad - 1),
                          (numberOfMessagesToLoad - 1));
         }

         self.imapMessagesFetchOp =
         [self.imapSession fetchMessagesByNumberOperationWithFolder:inboxFolder
                                                        requestKind:requestKind
                                                            numbers:
          [MCOIndexSet indexSetWithRange:fetchRange]];

         [self.imapMessagesFetchOp setProgress:^(unsigned int progress) {
             NSLog(@"Progress: %u of %u", progress, numberOfMessagesToLoad);
         }];

         __weak MasterViewController *weakSelf = self;
         [self.imapMessagesFetchOp start:
          ^(NSError *error, NSArray *messages, MCOIndexSet *vanishedMessages)
          {
              MasterViewController *strongSelf = weakSelf;
              NSLog(@"fetched all messages.");

              self.isLoading = NO;

              NSSortDescriptor *sort =
              [NSSortDescriptor sortDescriptorWithKey:@"header.date" ascending:NO];

              NSMutableArray *combinedMessages =
              [NSMutableArray arrayWithArray:messages];
              [combinedMessages addObjectsFromArray:strongSelf.messages];

              strongSelf.messages =
              [combinedMessages sortedArrayUsingDescriptors:@[sort]];
              [strongSelf.tableView reloadData];
          }];
     }];
}

 
