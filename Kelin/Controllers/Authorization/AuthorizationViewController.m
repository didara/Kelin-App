//
//  AuthorizationViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 10.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "AuthorizationViewController.h"

#import "JGProgressHUD.h"
#import "UIColor+AYHooks.h"
#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"
#import "UIImage+AYAdditions.h"

@interface AuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation AuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
     //_signUpButton.backgroundColor = [UIColor colorWithRed:0.118 green:0.773 blue:0.847 alpha:1];
    // _logInButton.backgroundColor = [UIColor colorWithRed:0.741 green:0.125 blue:0.192 alpha:1];
    for (UIButton *button in @[self.logInButton, self.signUpButton]) {
        [button setAlpha:0.7];
        button.clipsToBounds = YES;
        button.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
        button.layer.cornerRadius = 9;
       [button setBackgroundImage:[UIImage imageWithColor:button.backgroundColor] forState:UIControlStateNormal];
       [button setBackgroundImage:[UIImage imageWithColor:[button.backgroundColor darkerColor:0.1f]] forState:UIControlStateHighlighted];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
