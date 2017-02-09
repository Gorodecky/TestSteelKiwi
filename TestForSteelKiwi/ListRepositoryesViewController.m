//
//  ListRepositoryesViewController.m
//  TestForSteelKiwi
//
//  Created by Mac on 06.02.17.
//  Copyright © 2017 Horodecky Vitaliy. All rights reserved.
//

#import "ListRepositoryesViewController.h"
#import "ServerManager.h"
#import "CustomTableViewCell.h"
#import <SVProgressHUD/SVProgressHUD.h>


@interface ListRepositoryesViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSArray* arrayRepositoryes;

@end

@implementation ListRepositoryesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissHidenHud)
                                                 name:@"hidenHud" object:nil];
    [SVProgressHUD show];
    ServerManager* man = [[ServerManager alloc] init];
    
    [man getUserRepositories:^(NSArray *repositories) {
        if (repositories.count > 0) {
            self.arrayRepositoryes = repositories;
            [self.tableView reloadData];
            
            [SVProgressHUD dismiss];
            
        } else {
            [SVProgressHUD showWithStatus:@"Repository is empty!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            NSLog(@" масив пустой");
        }
    } onFailure:^(NSError *error) {
        [SVProgressHUD showWithStatus:@"Error!!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        NSLog(@"error = %@", error);
    }];
    
    // Do any additional setup after loading the view.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayRepositoryes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    Repository* repo = self.arrayRepositoryes[indexPath.row];
    
    [cell createCelWithRepository:repo];
    
    return cell;
}

- (void)dismissHidenHud {
    [SVProgressHUD dismiss];
}

@end
