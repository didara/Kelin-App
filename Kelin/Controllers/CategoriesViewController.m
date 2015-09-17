//
//  CategoriesViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 10.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "CategoriesViewController.h"

#import <Parse/Parse.h>
#import "UIView+AYUtils.h"

@interface CategoriesViewController ()

@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *dictionaryButton;
@property (weak, nonatomic) IBOutlet UIButton *secretsButton;

@end

@implementation CategoriesViewController

#pragma mark Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        [self performSegueWithIdentifier:@"goToAuthorization" sender:nil];
    }];
}
- (IBAction)instagramButtonDidPress:(id)sender {
    NSURL *instaURL = [[NSURL alloc] initWithString:@"instagram://user?username=the_kelin"];
    
    if (![[UIApplication sharedApplication] canOpenURL:instaURL] ) {
        instaURL = [[NSURL alloc] initWithString:@"http://instagram.com/the_kelin"];
    }
    
    [[UIApplication sharedApplication] openURL:instaURL];
}

@end
