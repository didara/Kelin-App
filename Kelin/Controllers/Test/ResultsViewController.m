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
#import "UIColor+AYHooks.h"
#import <UIFont+OpenSans.h>
#import "UIFont+Sizes.h"
#import "UIImage+AYAdditions.h"
#import "UIView+AYUtils.h"

static CGSize const kResultsSharingViewSize = {400, 400};

@interface ResultsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *unwindButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic) MGInstagram *instagramPoster;

@end

@implementation ResultsViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instagramPoster = [MGInstagram new];
    for (UIButton *button in @[self.unwindButton, self.shareButton]) {
        button.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
        [button setBackgroundImage:[UIImage imageWithColor:button.backgroundColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[button.backgroundColor darkerColor:0.1f]] forState:UIControlStateHighlighted];
    }
    
    self.levelLabel.font = [UIFont openSansLightFontOfSize:26];
    NSMutableAttributedString *percentageText = [[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)roundf(self.percentage * 100 + 0.5f)] attributes:@{ NSFontAttributeName: [UIFont openSansFontOfSize:200] }] mutableCopy];
    [percentageText appendAttributedString:[[NSAttributedString alloc] initWithString:@"%" attributes:@{ NSFontAttributeName: [UIFont openSansLightFontOfSize:40] }]];
    self.percentageLabel.attributedText = percentageText;
    if (self.percentage == 1) {
        self.levelLabel.text = @"Вы - настоящая келiн!!!";
    } else if (self.percentage > 0.91f) {
        self.levelLabel.text = @"Вы Келин для всего Казахстана";
    } else if (self.percentage > 0.83f) {
        self.levelLabel.text = @"Вы Келин всех регионов, кроме ЮКО";
    } else if (self.percentage > 0.75f) {
        self.levelLabel.text = @"Вы Келин Северного, Центрального и Восточного Казахстана";
    } else if (self.percentage > 0.68f) {
        self.levelLabel.text = @"Вы Келин Северного и Восточного Казахстана";
    } else if (self.percentage > 0.5f){
        self.levelLabel.text = @"Вы Келин Северного Казахстана";
    }   else if (self.percentage < 0.5f) {
        self.levelLabel.text = @"Неплохо, можно лучше! :)";
    }
    self.contentView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.4f animations:^{
        self.contentView.alpha = 1;
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.percentageLabel.top = 0;
    [self.levelLabel sizeToFit];
    self.levelLabel.width = self.contentView.width - 20;
    self.levelLabel.left = 10;
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

#pragma mark Actions

- (IBAction)shareButtonTapped:(UIButton *)sender {
    UIImage *image = [self convertViewToImage:[self viewForSharing]];
    if ([MGInstagram isAppInstalled]) {
#warning Add a comment to the post "#kelinapp @the_kelin" or something like that
        [self.instagramPoster postImage:image inView:self.view];
    } else {
#warning Show an error
    }
}

#pragma mark Private

- (UIView *)viewForSharing {
    UIView *viewForSharing = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kResultsSharingViewSize.width, kResultsSharingViewSize.height)];
    viewForSharing.backgroundColor = self.view.backgroundColor;
    UILabel *percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, viewForSharing.width - 20, 200)];
    percentageLabel.font = self.percentageLabel.font;
    percentageLabel.textColor = [UIColor whiteColor];
    percentageLabel.textAlignment = NSTextAlignmentCenter;
    percentageLabel.attributedText = self.percentageLabel.attributedText;
    percentageLabel.minimumScaleFactor = 0.5f;
    percentageLabel.adjustsFontSizeToFitWidth = YES;
    [viewForSharing addSubview:percentageLabel];
    
    UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, percentageLabel.bottom + 10, viewForSharing.width - 20, viewForSharing.height - percentageLabel.bottom - 20)];
    levelLabel.font = [UIFont openSansLightFontOfSize:26];
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.text = self.levelLabel.text;
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.numberOfLines = 0;
    levelLabel.minimumScaleFactor = 0.5f;
    levelLabel.adjustsFontSizeToFitWidth = YES;
    [levelLabel sizeToFit];
    levelLabel.width = viewForSharing.width - 20;
    levelLabel.left = 10;
    [viewForSharing addSubview:levelLabel];
    
    UILabel *watermarkLabel = [UILabel new];
    watermarkLabel.text = @"#kelinapp";
    watermarkLabel.textColor = [UIColor whiteColor];
    watermarkLabel.font = self.levelLabel.font;
    [watermarkLabel sizeToFit];
    watermarkLabel.right = viewForSharing.width - 10;
    watermarkLabel.bottom = viewForSharing.height - 10;
    [viewForSharing addSubview:watermarkLabel];
    
    CGFloat totalHeight = levelLabel.bottom;
    for (UILabel *label in @[levelLabel,percentageLabel]) {
        label.top += (watermarkLabel.top - totalHeight)/2;
    }
    
    return viewForSharing;
}

#pragma mark Helpers

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
