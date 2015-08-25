//
//  LogInViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 29.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "LogInViewController.h"

#import "JGProgressHUD.h"
#import <Parse/Parse.h>
#import "UIColor+AYHooks.h"
#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"
#import "UIImage+AYAdditions.h"

@interface LogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.passwordTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.logInButton.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.logInButton.layer.cornerRadius = 5;
    [self.logInButton setBackgroundImage:[UIImage imageWithColor:self.logInButton.backgroundColor] forState:UIControlStateNormal];
    [self.logInButton setBackgroundImage:[UIImage imageWithColor:[self.logInButton.backgroundColor darkerColor:0.1f]] forState:UIControlStateHighlighted];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];
    self.passwordTextField.secureTextEntry = YES;
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text  password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        [HUD dismissAnimated:YES];
        if (user) {
            [self performSegueWithIdentifier:@"enterApp" sender:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Такая келинка не найдена" delegate:self
                                                     cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
