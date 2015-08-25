//
//  RecipeDetailsViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 13.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "RecipeDetailsViewController.h"

#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"
#import "UIView+AYUtils.h"

@interface RecipeDetailsViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *basicInformationLabel;

@end

@implementation RecipeDetailsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.recipe[@"intro"];
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.recipe[@"Image"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.imageView.image = image;
        }
    }];
    
    self.basicInformationLabel.text = self.recipe[@"firstInformation"];
    self.basicInformationLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
}

- (void)viewWillLayoutSubviews {
    [self.basicInformationLabel sizeToFit];
    self.basicInformationLabel.superview.height = self.basicInformationLabel.bottom + 10;
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
        cell.textLabel.text = self.recipe[@"ingridients"];
    } else {
        cell.textLabel.text= self.recipe[@"cook"];
    }
    return cell;
}

@end
