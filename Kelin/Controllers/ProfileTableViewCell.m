//
//  ProfileTableViewCell.m
//  Kelin
//
//  Created by Zhanserik on 10/16/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import "UIColor+AYHooks.h"

static CGFloat kKAPImageViewContainerSize = 40.f;
static CGFloat kKAPImageViewMargin = 10.f;
static CGFloat kKAPImageViewSize = 24.f;

@interface ProfileTableViewCell()

@property (nonatomic) UIView *rightView;

@end

@implementation ProfileTableViewCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self initialize];
    }
    
    return self;
}

- (void) initialize{
    _imageView = [UIImageView new];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:_imageView];
    
    self.rightView = [UIView new];
    self.rightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.rightView];
    
    _textLabel = [UILabel new];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    _textLabel.textColor = [UIColor colorWithHexString:@"DB3C50"];
    _textLabel.numberOfLines = 0;
    
    [self.rightView addSubview:_textLabel];
    
    _detailTextLabel = [UILabel new];
    _detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    _detailTextLabel.textColor = [UIColor lightGrayColor];
    _detailTextLabel.numberOfLines = 0;
    
    [self.rightView addSubview:_detailTextLabel];
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    NSDictionary *metrics = @{
                              @"kKAPImageViewSize" : @(kKAPImageViewSize)
                              };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView(kKAPImageViewSize)]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0f
                                                                  constant:0.0f]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_rightView(kKAPImageViewSize)]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_rightView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_imageView(kKAPImageViewSize)]-15-[_rightView]-15-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_imageView, _rightView)]];
    
    
    [self.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_textLabel]-0-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_textLabel)]];
    [self.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_detailTextLabel]-0-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_detailTextLabel)]];
    
    [self.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_textLabel]-0-[_detailTextLabel(_textLabel)]-0-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_textLabel, _detailTextLabel)]];
    
    
}
@end
