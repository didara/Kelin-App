//
//  AvatarChangeView.m
//  Kelin
//
//  Created by Zhanserik on 10/18/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "AvatarChangeView.h"
#import "UIImage+AYAdditions.h"

@interface AvatarChangeView()


@property (nonatomic) UIImageView *upArrowImageView;
@property (nonatomic) UIImageView *downArrowImageView;

@end

@implementation AvatarChangeView

- (instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        [self initialize];
    }
    
    return self;
}

- (void) initialize{
    
    self.imageViewContainerView = [UIView new];
    self.imageViewContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageViewContainerView.backgroundColor = [UIColor blackColor];
    self.imageViewContainerView.layer.masksToBounds = YES;
    [self addSubview:self.imageViewContainerView];
    
    self.imageView = [UIImageView new];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.masksToBounds = YES;
    //self.imageView.layer.cornerRadius = kKelinImageViewSize / 2.0f;
    self.imageView.backgroundColor = [UIColor clearColor];
    
    [self.imageViewContainerView addSubview:self.imageView];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0];
    
    [self addSubview:self.titleLabel];
    
    self.upArrowImageView = [UIImageView new];
    self.upArrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.upArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.upArrowImageView.image = [[UIImage imageNamed:@"up_arrow_icon"] imageWithColor:[UIColor whiteColor]];

    [self addSubview:self.upArrowImageView];
    
    self.downArrowImageView = [UIImageView new];
    self.downArrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.downArrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.downArrowImageView.image = [[UIImage imageNamed:@"down_arrow_icon"] imageWithColor:[UIColor whiteColor]];
    [self addSubview:self.downArrowImageView];
    
//    self.imageView.layer.contentsRect = CGRectMake(0.2, 0.2, 0.2, 0.2);
}

- (void) layoutSubviews{
    [super layoutSubviews];

    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageViewContainerView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_imageViewContainerView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageViewContainerView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.6f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageViewContainerView
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_imageViewContainerView
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageViewContainerView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_titleLabel]-0-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_titleLabel)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.2f
                                                      constant:0.0f]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_upArrowImageView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_upArrowImageView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_upArrowImageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_upArrowImageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.1f
                                                      constant:0.0f]];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_downArrowImageView]"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_downArrowImageView)]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_downArrowImageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_downArrowImageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:0.1f
                                                      constant:0.0f]];
    
    
    //-----
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_upArrowImageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_imageViewContainerView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_upArrowImageView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_imageViewContainerView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_downArrowImageView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:_titleLabel
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0f
                                                      constant:0.0f]];
    
    
    
    [self.imageViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_imageView]-10-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self.imageViewContainerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_imageView]-10-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_imageView)]];
    
    self.imageView.layer.cornerRadius = CGRectGetWidth(self.imageView.frame)/ 2.0f;
    self.imageViewContainerView.layer.cornerRadius = CGRectGetWidth(self.imageViewContainerView.frame)/ 2.0f;
    
    
}

@end
