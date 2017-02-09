//
//  ServerManager.m
//  TestForSteelKiwi
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

#import "ServerManager.h"
#import <OctoKit/OctoKit.h>
#import <Security/Security.h>
#import <SAMKeychain/SAMKeychain.h>
#import <SAMKeychain/SAMKeychainQuery.h>
#import "Repository.h"


@implementation ServerManager

#pragma mark - ReturnArrayUserRepositories
- (void) getUserRepositories:(void(^)(NSArray* repositories))success
               onFailure:(void(^)(NSError* error))failure {

    RACSignal* signal = [OCTClient signInToServerUsingWebBrowser:OCTServer.dotComServer
                                                          scopes:OCTClientAuthorizationScopesUser];
    
    [signal subscribeNext:^(OCTClient *authenticatedClient) {
        
        if (authenticatedClient) {
            //[self saveTokenToSecurity:authenticatedClient];
            //NSLog(@"Token = %@", authenticatedClient.token);
        }
        
        RACSignal *request = [authenticatedClient fetchUserRepositories];
        
        [[request collect] subscribeNext:^(id repositories) {
            // Authentication was successful. Do something with the created client.
            NSMutableArray* repoArray = [NSMutableArray array];
            //NSLog(@"Repositories = %@", repositories);
            
            if (repositories) {
                
                for(OCTRepository* repo in repositories) {
                    
                    Repository* repository = [[Repository alloc] init];
                    repository.name = repo.name;
                    repository.descriptionRepository = repo.repoDescription;
                    
                    if (repository) {
                        [repoArray addObject:repository];
                    }
                }
                success(repoArray);
                [self notificationHidenHud];
            } else {
                success(nil);
                [self notificationHidenHud];
            }
        } error:^(NSError *error) {
            NSLog(@"Error = %@", error);
            failure(error);
            [self notificationHidenHud];
        }];
    } error:^(NSError *error) {
        // Authentication failed.
        failure(error);
        [self notificationHidenHud];
    }];
}

- (void) notificationHidenHud {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenHud"
                                                        object:nil];
}

@end
