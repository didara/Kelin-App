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

@property (nonatomic) UIBarButtonItem *leftBarButtonItem;

@end

@implementation CategoriesViewController

#pragma mark Lifecycle

- (void) viewDidLoad{
    [super viewDidLoad];
    
//    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
//    NSMutableArray *vcs =  [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    [vcs insertObject:controller atIndex:[vcs count]-1];
//    [self.navigationController setViewControllers:vcs animated:NO];
    
    self.leftBarButtonItem = [UIBarButtonItem new];
    self.leftBarButtonItem.action = @selector(profileButtonDidPress:);
    self.leftBarButtonItem.target = self;
    self.leftBarButtonItem.image = [UIImage imageNamed:@"profile_icon"];
    
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    
}

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
//- (IBAction)instagramButtonDidPress:(id)sender {
//    NSURL *instaURL = [[NSURL alloc] initWithString:@"instagram://user?username=the_kelin"];
//    
//    if (![[UIApplication sharedApplication] canOpenURL:instaURL] ) {
//        instaURL = [[NSURL alloc] initWithString:@"http://instagram.com/the_kelin"];
//    }
//    
//    [[UIApplication sharedApplication] openURL:instaURL];
//}

- (void) profileButtonDidPress: (id) sender{

    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromLeft;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:controller animated:NO];
}
@end
