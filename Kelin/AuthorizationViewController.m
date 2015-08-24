//
//  AuthorizationViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 10.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "AuthorizationViewController.h"

#import "JGProgressHUD.h"
#import <Parse/Parse.h>
#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"

@interface AuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                              NSFontAttributeName: [UIFont openSansFontOfSize:17] }];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                              NSFontAttributeName: [UIFont openSansFontOfSize:17] } forState:UIControlStateNormal];
    [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1]] /*#d81e35*/;
    
    self.logInButton.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.logInButton.layer.cornerRadius = 5;
    self.signUpButton.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.signUpButton.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"enterApp" sender:nil];
    }
}

@end
