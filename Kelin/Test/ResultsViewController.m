//
//  ResultsViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 07.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "ResultsViewController.h"

#import "AYMacros.h"
#import <MGInstagram/MGInstagram.h>
#import "UIFont+Sizes.h"
#import <UIFont+OpenSans.h>
#import "UIView+AYUtils.h"

static CGSize const kResultsSharingViewSize = {500, 500};

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic) MGInstagram *instagramPoster;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instagramPoster = [MGInstagram new];
    
    NSMutableAttributedString *percentageText = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)roundf(self.percentage * 100 + 0.5f)] attributes:@{ NSFontAttributeName: self.percentageLabel.font }] mutableCopy];
    [percentageText appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:@{ NSFontAttributeName: [UIFont openSansLightFontOfSize:40] }]];
    self.percentageLabel.attributedText = percentageText;
    
    if (self.percentage == 100) {
        self.levelLabel.text = @"Вы - настоящая келiн!!!";
    } else if (self.percentage > 91) {
        self.levelLabel.text = @"Вы Келин для всего Казахстана";
    } else if (self.percentage > 83) {
        self.levelLabel.text = @"Вы Келин всех регионов, кроме ЮКО";
    } else if (self.percentage > 75) {
        self.levelLabel.text = @"Вы Келин Северного, Центрального и Восточного Казахстана";
    } else if (self.percentage > 68) {
        self.levelLabel.text = @"Вы Келин Северного и Восточного Казахстана";
    } else if (self.percentage > 50){
        self.levelLabel.text = @"Вы Келин Северного Казахстана";
    }   else if (self.percentage < 50) {
        self.levelLabel.text = @"Неплохо, можно лучше! :)";
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.percentageLabel.top = 0;
    [self.levelLabel sizeToFit];
    self.levelLabel.width = self.contentView.width;
    self.levelLabel.top = self.percentageLabel.bottom + 10;
    
    CGFloat totalHeight = self.levelLabel.bottom;
    for (UILabel *label in @[self.levelLabel, self.percentageLabel]) {
        label.top += (self.contentView.height - totalHeight)/2;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)shareButtonTapped:(UIButton *)sender {
    UIImage *image = [self convertViewToImage:[self viewForSharing]];
    if ([MGInstagram isAppInstalled]) {
        [self.instagramPoster postImage:image inView:self.view];
    } else {
        // Need to show the error
    }
}

- (UIView *)viewForSharing {
    UIView *viewForSharing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kResultsSharingViewSize.width, kResultsSharingViewSize.height)];
    UILabel *percentageLabel = [[UILabel alloc] initWithFrame:percentageLabel.frame];
    percentageLabel.font = self.percentageLabel.font;
    percentageLabel.attributedText = self.percentageLabel.attributedText;
    [viewForSharing addSubview:viewForSharing];
    
    UILabel *levelLabel = [UILabel new];
    levelLabel.font = self.levelLabel.font;
    [levelLabel sizeToFit];
    levelLabel.width = viewForSharing.width;
    levelLabel.top = percentageLabel.bottom + 10;
    [viewForSharing addSubview:levelLabel];
    
    CGFloat totalHeight = levelLabel.bottom;
    for (UILabel *label in @[levelLabel,percentageLabel]) {
        label.top += (viewForSharing.height - totalHeight)/2;
    }
    
    UILabel *watermarkLabel = [UILabel new];
    watermarkLabel.text = @"Kelin";
    [watermarkLabel sizeToFit];
    watermarkLabel.right = viewForSharing.width - 10;
    watermarkLabel.bottom = viewForSharing.height - 10;
    [viewForSharing addSubview:watermarkLabel];
    
    return viewForSharing;
}

- (UIImage *)convertViewToImage:(UIView *)view {
    UIImage *image;
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        // Optimized/fast method for rendering a UIView as image on iOS 7 and later versions.
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        // For devices running on earlier iOS versions.
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

@end
