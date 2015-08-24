//
//  ViewController.m
//  K
//
//  Created by Didara Pernebayeva on 29.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBarTintColor :[UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1] /*#d81e35*/];
      }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];
    self.passwordTextField.secureTextEntry = YES;
[PFUser logInWithUsernameInBackground:self.usernameTextField.text  password:self.passwordTextField.text
block:^(PFUser *user, NSError *error) {
    [HUD dismissAnimated:YES];
    if (user) {

[self enterApp];
    } else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                           message:@"Такая келинка не найдена"
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
