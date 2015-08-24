//
//  SecretsViewController.m
//  K
//
//  Created by Didara Pernebayeva on 29.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SecretsViewController.h"

#import <Parse/Parse.h>
#import "JGProgressHUD.h"

@interface SecretsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *stories;

@end

@implementation SecretsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stories.tintColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.stories becomeFirstResponder];
}

- (IBAction)DoneButtonPressed:(UIBarButtonItem *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Отправляется";
    [HUD showInView:self.view];
    PFObject *secret = [PFObject objectWithClassName:@"Secrets"];
    secret[@"story"] = _stories.text;
    [secret saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [HUD dismissAnimated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"saved %@", secret);
        } else {
            NSLog(@"error");
        }
    }];
}


@end
