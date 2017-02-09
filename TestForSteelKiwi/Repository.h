//
//  Repository.h
//  TestForSteelKiwi
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OctoKit/OctoKit.h>

@interface Repository : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* descriptionRepository;

- (id)initWithServerResponse:(NSDictionary*)responseobject;

@end
