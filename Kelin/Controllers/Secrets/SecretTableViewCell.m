//
//  SecretTableViewCell.m
//  Kelin
//
//  Created by Zhanserik on 9/17/15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SecretTableViewCell.h"


static CGFloat kKAPCrownImageViewWidth = 20.f;
static CGFloat kKAPCrownImageViewHeight = 11.f;

@interface SecretTableViewCell()

@property (nonatomic) UIImageView *crownImageView;

@end


@implementation SecretTableViewCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        
        [self initialize];

    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self){
        [self initialize];
    }
    
    return self;
}

- (void) initialize{
    
    _imageViewContainer = [UIView new];
    _imageViewContainer.translatesAutoresizingMaskIntoConstraints = NO;
    _imageViewContainer.layer.masksToBounds = YES;
    _imageViewContainer.layer.cornerRadius = kKAPImageViewContainerSize / 2.f;
    _imageViewContainer.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0].CGColor;
    [self.contentView addSubview:_imageViewContainer];
    
    _imageView = [UIImageView new];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = kKAPImageViewSize / 2.f;
    _imageView.layer.borderColor = [UIColor yellowColor].CGColor;
    [_imageViewContainer addSubview:_imageView];
    
    _textLabel = [UILabel new];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.font = [UIFont systemFontOfSize:17.f];
    _textLabel.textColor = [UIColor darkGrayColor];
    
    [self.contentView addSubview:_textLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.font = [UIFont systemFontOfSize:10.0f];
    _timeLabel.textColor = [UIColor lightGrayColor];
    
    [self.contentView addSubview:_timeLabel];
    
    self.crownImageView = [UIImageView new];
    self.crownImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.crownImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.crownImageView.image = [UIImage imageNamed:@"crown"];
    self.crownImageView.alpha = 0.f;
    
    [self.contentView addSubview:self.crownImageView];
    
    self.usernameLabel = [UILabel new];
    self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameLabel.font = [UIFont systemFontOfSize:10.0f];
    self.usernameLabel.textColor = [UIColor darkGrayColor];
    
    [self.contentView addSubview:self.usernameLabel];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    NSDictionary *metrics = @{@"kKAPImageViewSize" : @(kKAPImageViewSize),
                              @"kKAPImageViewMargin" : @(kKAPImageViewMargin),
                              @"kKAPImageViewContainerSize" : @(kKAPImageViewContainerSize),
                              @"kKAPCrownImageViewWidth" : @(kKAPCrownImageViewWidth),
                              @"kKAPCrownImageViewHeight" : @(kKAPCrownImageViewHeight)};
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageViewContainer(kKAPImageViewContainerSize)]"
                                                                                options:0
                                                                                metrics:metrics
                                                                                  views:NSDictionaryOfVariableBindings(_imageViewContainer)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageViewContainer
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    
    [_imageViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView(kKAPImageViewSize)]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_imageView)]];
    [_imageViewContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_imageView(kKAPImageViewSize)]"
                                                                                options:0
                                                                                metrics:metrics
                                                                                  views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [_imageViewContainer addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_imageViewContainer
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    
    [_imageViewContainer addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_imageViewContainer
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_textLabel]-0-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_textLabel)]];
    
    NSString *visualFormat = @"H:|-kKAPImageViewMargin-[_imageViewContainer(kKAPImageViewContainerSize)]-kKAPImageViewMargin-[_textLabel]-20-|";
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_imageViewContainer, _textLabel)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeLabel]-5-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_timeLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_timeLabel]-5-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_timeLabel)]];
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_crownImageView(kKAPCrownImageViewWidth)]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_crownImageView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_crownImageView(kKAPCrownImageViewHeight)]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_crownImageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.crownImageView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_imageViewContainer
                                                                 attribute:NSLayoutAttributeTop
                                                                multiplier:1.0f
                                                                  constant:2.0f]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.crownImageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:_imageView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_usernameLabel]-5-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_usernameLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_usernameLabel]-25-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_usernameLabel)]];
}

- (void) setIsVIP:(BOOL)isVIP{
    _isVIP = isVIP;
    
    if(isVIP){
        self.crownImageView.alpha = 1.f;
        self.imageViewContainer.layer.borderWidth = 3.0f;
    }
    else{
        self.crownImageView.alpha = 0.0f;
        self.imageViewContainer.layer.borderWidth = 0.0f;
    }
}

@end
