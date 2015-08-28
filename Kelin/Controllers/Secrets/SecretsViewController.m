//
//  SecretsViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 30.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SecretsViewController.h"

#import "JGProgressHUD.h"
#import <Parse/Parse.h>
#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"
#import "UIView+AYUtils.h"

@interface SecretsViewController ()

@property (nonatomic) NSArray *secrets;
@property (nonatomic) JGProgressHUD *HUD;

@end

@implementation SecretsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self action:@selector(downloadData) forControlEvents:UIControlEventValueChanged];
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    self.HUD.textLabel.text = @"Келiн собирает секреты";
    [self.HUD showInView:self.view];
    [self downloadData];
}

#pragma mark Private

- (void)downloadData {
    PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if ([self.HUD isVisible]) {
                [self.HUD dismissAnimated:YES];
            }
            self.secrets = [objects mutableCopy];
        } else {
#warning Show an error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.secrets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    cell.textLabel.text = self.secrets[indexPath.row][@"story"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    return [self.secrets[indexPath.row][@"story"]
                        boundingRectWithSize:CGSizeMake(self.view.width - 40, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{ NSParagraphStyleAttributeName:paragraphStyle.copy,
                                      NSFontAttributeName : [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]] }
                        context:nil].size.height + 40;
}

@end
