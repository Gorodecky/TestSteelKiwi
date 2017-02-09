//
//  ServerManager.h
//  TestForSteelKiwi
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject

- (void) getUserRepositories:(void(^)(NSArray* repositories))success
         onFailure:(void(^)(NSError* error))failure;

@end
