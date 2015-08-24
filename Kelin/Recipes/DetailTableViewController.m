//
//  DetailTableViewController.m
//  K
//
//  Created by Didara Pernebayeva on 13.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "DetailTableViewController.h"

#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"

@interface DetailTableViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *basicInformationLabel;

@end

@implementation DetailTableViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.info[0][@"intro"];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.imageView.image = self.info[1];
    self.basicInformationLabel.text = self.info [2][@"firstInformation"];
    self.basicInformationLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"ИНГРЕДИЕНТЫ";
    } else {
        return @"ПРИГОТОВЛЕНИЕ";
    }
}
  
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    cell.textLabel.numberOfLines = 0;
    if (indexPath.section == 0){
        cell.textLabel.text = self.info[3][@"ingridients"];
    } else {
        cell.textLabel.text= self.info[4][@"cook"];
    }
    return cell;
}

@end
