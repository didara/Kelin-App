//
//  MOStoreButton.h
//  Kelin
//
//  Created by Zhanserik on 10/14/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#define blueColor_macro [UIColor colorWithRed:156.0/255.0 green:140.0/255.0 blue:103.0/255.0 alpha:1]

#import <UIKit/UIKit.h>

@class MOStoreButton;

@protocol MOStoreButtonDelegate
- (void)storeButtonFired:(MOStoreButton *)button;
@end



@interface MOStoreButton : UIButton{
    
    CAGradientLayer *gradient_;
    CGPoint customPadding_;
    
}

@property(nonatomic,strong)NSArray *titles;
@property (nonatomic, assign) id<MOStoreButtonDelegate> buttonDelegate;
@property(nonatomic,readonly,assign)int  currentIndex;
@property(nonatomic,assign)BOOL isInTestingMode;
@property(nonatomic,strong)NSString *finishedDownloadingButtonTitle;


- (void)setProgress:(CGFloat)progress animated:(BOOL)animate;

-(void)startDownloading;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor*)buttonColor;
@end