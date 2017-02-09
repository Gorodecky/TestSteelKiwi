//
//  AppDelegate.m
//  TestForSteelKiwi
//
//  Created by Mac on 01.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

#import "AppDelegate.h"
#import <OctoKit/OctoKit.h>
#import <Security/Security.h>
#import <SAMKeychain/SAMKeychain.h>
#import <SAMKeychain/SAMKeychainQuery.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [OCTClient setClientID:@"b73f3e6b7e775c916189" clientSecret:@"a62114be3a19aec362e3c6d496bb6e227913c6c9"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // For handling a callback URL like my-app://oauth
    
    
    NSString* urlString = URL.absoluteString;
    
    
    if ([urlString rangeOfString:@"tesforsteelkiwi"].location == NSNotFound) {
        return NO;

    } else {
        [OCTClient completeSignInWithCallbackURL:URL];
        NSLog(@"url = %@", URL);
        return YES;
        
    }
}

- (void)inspektionUserToken {
    
    RACSignal* signal = [OCTClient signInToServerUsingWebBrowser:OCTServer.dotComServer
                                                          scopes:OCTClientAuthorizationScopesUser];
    
    [signal subscribeNext:^(OCTClient *authenticatedClient) {
        
        if (authenticatedClient) {
            //[self saveTokenToSecurity:authenticatedClient];
            NSLog(@"Token = %@", authenticatedClient.token);
        
        }
        
        RACSignal *request = [authenticatedClient fetchUserRepositories];
        
        [[request collect] subscribeNext:^(id repositories) {
            
            NSLog(@"Repositories = %@", repositories);
            
            
            //[self addToken];
            
        } error:^(NSError *error) {
            
            NSLog(@"Error = %@", error);
            
        }];
        
        // Authentication was successful. Do something with the created client.
    } error:^(NSError *error) {
        
        
        // Authentication failed.
    }];    // Do any additional setup after loading the view.
}

- (void) addToken {
    
    NSError *error = nil;
    SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
    query.service = kSAMKeychainWhereKey;
    query.account = kSAMKeychainAccountKey;
    
    NSString* password = [SAMKeychain passwordForService:kSAMKeychainWhereKey account:kSAMKeychainAccountKey];
    
    NSData* passwordData = [SAMKeychain passwordDataForService:kSAMKeychainWhereKey account:kSAMKeychainAccountKey];
    
    NSLog(@"Token = %@", password);
    
    NSLog(@"Token with data = %@", [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding]);
    
    if ([query save:&error]) {
        
        NSLog(@"token saved");
    } else {
        
        NSLog(@"Some other error occurred: %@", [error localizedDescription]);
    }

    
}

- (void) saveTokenToSecurity:(OCTClient*)client {
    
    NSString* passwordString = [NSString stringWithFormat:@"%@", client.token];
    //NSString* userName = [NSString stringWithFormat:@"%@", client.user];
    
    NSData* passwordData = [passwordString dataUsingEncoding:NSUTF8StringEncoding];
    
    [SAMKeychain setPasswordData:passwordData forService:kSAMKeychainWhereKey account:kSAMKeychainAccountKey];
    
    if ([SAMKeychain setPassword:[NSString stringWithFormat:@"%@", client.token] forService:kSAMKeychainWhereKey account:kSAMKeychainAccountKey]) {
        NSLog(@"Save token");
            
        } else {
            NSLog(@"error save token");
        }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
