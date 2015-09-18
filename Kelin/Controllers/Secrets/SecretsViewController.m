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

@interface SecretsViewController ()

@property (nonatomic) NSMutableArray *secrets;
@property (nonatomic) JGProgressHUD *HUD;
@property (nonatomic) NSInteger currentSkip;

@end

@implementation SecretsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.separatorColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor darkGrayColor];
    [self.refreshControl addTarget:self action:@selector(downloadData) forControlEvents:UIControlEventValueChanged];
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    self.HUD.textLabel.text = @"Келiн собирает секреты";
    [self.HUD showInView:self.view];
    [self downloadData];
    

    
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleWhite;
    
    __weak SecretsViewController *weakSelf = self;
    
    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {

        PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
        [query orderByDescending:@"updatedAt"];
        query.limit = 100;
        query.skip = weakSelf.currentSkip;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            weakSelf.currentSkip += 100;
            
            if (!error) {
              
                [weakSelf.secrets addObjectsFromArray:[objects mutableCopy]];
            }
            
            [weakSelf.tableView reloadData];
            
            [tableView finishInfiniteScroll];
        }];
    }];
}

#pragma mark Private

- (void)downloadData {
    PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
    query.limit = 100;
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.currentSkip += 100;
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
        cell.imageView.backgroundColor = [UIColor colorWithHexString:hexColor];
    }
    else{
        cell.imageView.backgroundColor = [UIColor clearColor];
    }
    if(secret[@"image"]){
        NSString *imageName = secret[@"image"];
        cell.imageView.image = [[UIImage imageNamed:imageName] imageWithColor:[UIColor whiteColor]];
    }
    
    
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

@end
