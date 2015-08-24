//
//  ResultsViewController.m
//  K
//
//  Created by Didara Pernebayeva on 07.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "ResultsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MGInstagram/MGInstagram.h>
#import <UIFont+OpenSans.h>

@interface ResultsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic) MGInstagram *instagramPoster;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instagramPoster = [MGInstagram new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    self.resultsLabel.text = [NSString stringWithFormat:@"%i", self.percentage];
    _resultsLabel.font = [UIFont openSansFontOfSize:120];
    if (self.percentage == 100) {
      _levelLabel.font =[UIFont openSansFontOfSize:20];
        self.levelLabel.text = @"Вы - настоящая келiн!!!";
    } else {
    if (self.percentage > 91) {
        _levelLabel.font =[UIFont openSansFontOfSize:20];
        self.levelLabel.text = @"Вы Келин для всего Казахстана";

    } else {
    if (self.percentage > 83) {
        _levelLabel.font =[UIFont openSansFontOfSize:20];
        self.levelLabel.text = @"Вы Келин всех регионов, кроме ЮКО";
    } else {
    if (self.percentage > 75) {
        _levelLabel.font =[UIFont openSansFontOfSize:20];
        self.levelLabel.text = @"Вы Келин Северного, Центрального и Восточного Казахстана";
        
    }else{
    if (self.percentage > 68) {
       _levelLabel.font =[UIFont openSansFontOfSize:20];
        self.levelLabel.text = @"Вы Келин Северного и Восточного Казахстана";
    }else{
    if (self.percentage > 50){
        _levelLabel.font =[UIFont openSansFontOfSize:20];
        self.levelLabel.text = @"Вы Келин Северного Казахстана";
    }else{
    if (self.percentage < 50) {
        _levelLabel.font =[UIFont openSansFontOfSize:20];
        self.levelLabel.text = @"неплохо, можно лучше!:)";

}
}}}}}}}
- (IBAction)ShareButton:(UIButton *)sender {
    
    
    UIImage *image = [self imageWithView:self.contentView];
    if ([MGInstagram isAppInstalled])
    {
        [self.instagramPoster postImage:image inView:self.view];
    }
    else
    {
        NSLog(@"Error Instagram is either not installed or image is incorrect size");
    }
    
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
