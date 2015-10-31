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
#import <UIScrollView+InfiniteScroll.h>
#import "AppDelegate.h"
#import "SecretTableViewCell.h"
#import "UIColor+AYHooks.h"
#import "UIImage+AYAdditions.h"

#import "NSDate+KZUtils.h"
#import "StoreManager.h"

typedef NS_ENUM(NSInteger, KelinSecretMode) {
    KelinSecretModeAll,
    KelinSecretModeTopSecret
};

@interface SecretsViewController ()

@property (nonatomic) NSMutableArray *secrets;
@property (nonatomic) JGProgressHUD *HUD;
@property (nonatomic) NSInteger currentSkip;

@property (nonatomic) UISegmentedControl *segmentedControl;
@property (nonatomic) KelinSecretMode mode;

@end

@implementation SecretsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self action:@selector(downloadData) forControlEvents:UIControlEventValueChanged];
    
//    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
//    self.HUD.textLabel.text = @"Келiн собирает секреты";
//    [self.HUD showInView:self.view];
    [self downloadData];
    

    
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    
    __weak SecretsViewController *weakSelf = self;
    
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {

        PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
        [query orderByDescending:@"updatedAt"];
        query.limit = 100;
        query.skip = weakSelf.currentSkip;
        
        if(self.mode == KelinSecretModeTopSecret){
            [query whereKey:@"bests" equalTo:@(YES)];
        }
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            weakSelf.currentSkip += 100;
            
            if (!error) {
              
                [weakSelf.secrets addObjectsFromArray:[objects mutableCopy]];
            }
            
            [weakSelf.tableView reloadData];
            
            [tableView finishInfiniteScroll];
        }];
    }];
    
    self.segmentedControl = [UISegmentedControl new];
    self.segmentedControl.frame = CGRectMake(0, 0, 200, 30);
    [self.segmentedControl insertSegmentWithTitle:@"Новые" atIndex:0 animated:NO];
    [self.segmentedControl insertSegmentWithTitle:@"Лучшие" atIndex:1 animated:NO];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self
                              action:@selector(segmentedControlDidChange:)
                    forControlEvents:UIControlEventValueChanged];
    
    
    BOOL topSecretAvailable = [[NSUserDefaults standardUserDefaults] boolForKey:kKelinTopSecretIdentifierKey];
    if(topSecretAvailable){
        self.navigationItem.titleView = self.segmentedControl;
    }
    
}

#pragma mark Private

- (void)downloadData {
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    self.HUD.textLabel.text = @"Келiн собирает секреты";
    [self.HUD showInView:self.view];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
    query.limit = 100;
    //[query whereKey:@"story" containsString:@"@"];
    self.currentSkip = 0;
    
    [query orderByDescending:@"updatedAt"];
    
    if(self.mode == KelinSecretModeTopSecret){
        [query whereKey:@"bests" equalTo:@(YES)];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.currentSkip += 100;
         self.tableView.separatorColor = [UIColor lightGrayColor];
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
    
    SecretTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    PFObject *secret = self.secrets[indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    cell.textLabel.text = secret[@"story"];
    
    
    if(secret[@"color"]){
        NSString *hexColor = secret[@"color"];
        cell.imageViewContainer.backgroundColor = [UIColor colorWithHexString:hexColor];
    }
    else{
        cell.imageViewContainer.backgroundColor = [UIColor clearColor];
        
    }
    if(secret[@"image"]){
        NSString *imageName = secret[@"image"];
        cell.imageView.image = [[UIImage imageNamed:imageName] imageWithColor:[UIColor whiteColor]];
    }
    
    cell.isVIP = [secret[@"vip"] boolValue];
    
    NSDate *date = secret.createdAt;
    
    cell.timeLabel.text = [date timeAgoSimple];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    return [self.secrets[indexPath.row][@"story"]
                        boundingRectWithSize:CGSizeMake(self.view.width - 40 - kKAPImageViewSize - 2*kKAPImageViewMargin, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{ NSParagraphStyleAttributeName:paragraphStyle.copy,
                                      NSFontAttributeName : [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]] }
                        context:nil].size.height + 40;
}

- (void) segmentedControlDidChange: (UISegmentedControl *) control{
    NSInteger index = control.selectedSegmentIndex;
    
    if(index == 0){
        self.mode = KelinSecretModeAll;
    }
    else if(index == 1){
        self.mode = KelinSecretModeTopSecret;
    }
    
    [self downloadData];
}

@end
