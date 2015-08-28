//
//  SendSecretViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 29.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SendSecretViewController.h"

#import <Parse/Parse.h>
#import "JGProgressHUD.h"

@interface SendSecretViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SendSecretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.tintColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (IBAction)doneButtonPressed:(UIBarButtonItem *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Отправляется";
    [HUD showInView:self.view];
    PFObject *secret = [PFObject objectWithClassName:@"Secrets"];
    secret[@"story"] = self.textView.text;
    [secret saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [HUD dismissAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
#warning Show an error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            

        }
    }];
}

@end
