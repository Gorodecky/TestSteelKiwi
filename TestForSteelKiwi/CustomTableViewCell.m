//
//  CustomTableViewCell.m
//  TestForSteelKiwi
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "Repository.h"

@interface CustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel* nameRepositoryLable;
@property (weak, nonatomic) IBOutlet UILabel* descriptionRepositoryLable;

@end

@implementation CustomTableViewCell

- (void) createCelWithRepository:(Repository*)repository {
    
    self.nameRepositoryLable.text = repository.name;
    self.descriptionRepositoryLable.text = repository.descriptionRepository;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
