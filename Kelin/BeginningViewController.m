//
//  BeginningViewController.m
//  K
//
//  Created by Didara Pernebayeva on 10.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "BeginningViewController.h"
#import "JGProgressHUD.h"
#import <Parse/Parse.h>

@interface BeginningViewController ()

@property (weak, nonatomic) IBOutlet UIButton *ButtonVoiti;
@property (weak, nonatomic) IBOutlet UIButton *ButtonZareg;

@end

@implementation BeginningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
    if ([PFUser currentUser]) {
    [self performSegueWithIdentifier:@"signedUpSegue" sender:nil];
        
   }
}


-(IBAction)Unwind:(UIStoryboardSegue *)segue {
    [self.ButtonZareg setHidden:NO];
    [self.ButtonVoiti setHidden:NO];
   
}

- (IBAction)VoitiButtonPressed:(UIButton *)sender {

    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    HUD.textLabel.text = @"Келiн наливает чай";

    [self.ButtonZareg setHidden:YES];
    [self performSegueWithIdentifier:@"enterVoitiSegue" sender:nil];
    [HUD dismissAnimated:YES];
}

- (IBAction)ZaregButtonPresseed:(UIButton *)sender {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    HUD.textLabel.text = @"Келiн наливает чай";

    [self.ButtonVoiti setHidden:YES];
    [self performSegueWithIdentifier:@"enterZaregSegue" sender:nil];
    [HUD dismissAnimated:YES];

}





@end
