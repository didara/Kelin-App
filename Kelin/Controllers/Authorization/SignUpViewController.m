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
#import "UIColor+AYHooks.h"
#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"
#import "UIImage+AYAdditions.h"
#import "NSString+Utils.h"

@interface SignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordTextField.delegate = self;
    //want to remove keyboard after pressing return
    self.usernameTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.passwordTextField.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.signUpButton.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    self.signUpButton.layer.cornerRadius = 9;
    [self.signUpButton setBackgroundImage:[UIImage imageWithColor:[self.signUpButton.backgroundColor colorWithAlphaComponent:0.7f]] forState:UIControlStateNormal];
    [self.signUpButton setBackgroundImage:[UIImage imageWithColor:[[self.signUpButton.backgroundColor darkerColor:0.1f] colorWithAlphaComponent:0.7f]] forState:UIControlStateHighlighted];
}

- (IBAction)signUpButtonTapped:(UIButton *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];

    
    NSString *username = self.usernameTextField.text;
    NSString *trimmedUsername = [username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *pass = self.passwordTextField.text;
    NSString *trimmedPass = [pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    PFUser *user = [PFUser user];
    user.username = trimmedUsername;
    self.passwordTextField.secureTextEntry = YES;
    user.password = trimmedPass;
    
    if (![trimmedUsername validateEmail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                        message:@"Для регистрации нужен настоящий email!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        [HUD dismissAnimated:YES];
        return;
    }
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [HUD dismissAnimated:YES];
        if (succeeded) {
            [self performSegueWithIdentifier:@"enterApp" sender:nil];
        } else {
            
            if(error.code == kPFErrorUsernameTaken){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                message:@"Такая келинка уже существует!"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                message:@"Что то пошло не так..."
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
