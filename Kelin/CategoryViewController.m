//
//  CategoryViewController.m
//  
//
//  Created by Didara Pernebayeva on 30.06.15.
//
//
#import "ViewController.h"
#import "CategoryViewController.h"
#import <Parse/Parse.h>

@interface CategoryViewController ()

@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *dictButton;
@property (weak, nonatomic) IBOutlet UIButton *secretsButton;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar
setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
     [ self.navigationController.navigationBar setBarTintColor :[UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1] /*#d81e35*/];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (IBAction)logoutButtonPressed:(UIBarButtonItem *)sender {
    [PFUser logOutInBackgroundWithBlock:^ (NSError *error) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
