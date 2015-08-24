//
//  SignUpViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 10.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SignUpViewController.h"

#import "JGProgressHUD.h"
#import <Parse/Parse.h>
#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.passwordTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.signUpButton.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.signUpButton.layer.cornerRadius = 5;
}

- (IBAction)signUpButtonTapped:(UIButton *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    self.passwordTextField.secureTextEntry = YES;
    user.password = self.passwordTextField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [HUD dismissAnimated:YES];
        if (succeeded) {
            [self performSegueWithIdentifier:@"enterApp" sender:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Адрес почты указан неверно"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

@end
