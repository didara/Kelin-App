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
#import "NSString+Utils.h"

@interface LogInViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.delegate = self;
    //want to remove keyboard after pressing return
    self.usernameTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.passwordTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.logInButton.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.logInButton.layer.cornerRadius = 9;
    [self.logInButton setBackgroundImage:[UIImage imageWithColor:[self.logInButton.backgroundColor colorWithAlphaComponent:0.7f]] forState:UIControlStateNormal];
    [self.logInButton setBackgroundImage:[UIImage imageWithColor:[[self.logInButton.backgroundColor darkerColor:0.1f] colorWithAlphaComponent:0.7f]] forState:UIControlStateHighlighted];
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];
    self.passwordTextField.secureTextEntry = YES;
    
    
    
    NSString *username = self.usernameTextField.text;
    NSString *trimmedUsername = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *pass = self.passwordTextField.text;
    NSString *trimmedPass = [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    
    //Для регистрации нужен настоящий email!
    
    [PFUser logInWithUsernameInBackground:trimmedUsername  password:trimmedPass block:^(PFUser *user, NSError *error) {
        [HUD dismissAnimated:YES];
        if (user) {
            [self performSegueWithIdentifier:@"enterApp" sender:nil];
        } else {
            
            if(error.code == kPFErrorUserPasswordMissing){
//                Келинка, пароль указан неверно!
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                message:@"Келинка, пароль указан неверно!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                message:@"Такая келинка не найдена"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }
    }];
}

//to remove keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [textField resignFirstResponder];
    }
    return NO;
}

@end
