//
//  RegisterViewController.m
//  K
//
//  Created by Didara Pernebayeva on 10.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
//@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [ self.navigationController.navigationBar setBarTintColor :[UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1] /*#d81e35*/];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signupButtonPressed:(UIButton *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];
        PFUser *user = [PFUser user];
        user.username = self.usernameTextField.text;
       // user.email = self.emailTextField.text;
        self.passwordTextField.secureTextEntry = YES;
        user.password = self.passwordTextField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         [HUD dismissAnimated:YES];
        if (succeeded) {
            
         [self enterApp];
                   } else {
                       UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                          message:@"Адрес почты указан неверно"
                                                                         delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                       [theAlert show];
                       

        }
    }];
}


-(void) enterApp
{
    [self performSegueWithIdentifier:@"enterAppSegue" sender:nil];
    
}

@end
