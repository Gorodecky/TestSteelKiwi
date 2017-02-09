//
//  CustomTableViewCell.h
//  TestForSteelKiwi
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Repository;

@interface CustomTableViewCell : UITableViewCell

- (void) createCelWithRepository:(Repository*)repository;

@end
static  NSString* const kCellIdentifier = @"customCell";
