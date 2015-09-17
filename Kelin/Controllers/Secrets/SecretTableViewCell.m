//
//  SecretTableViewCell.m
//  Kelin
//
//  Created by Zhanserik on 9/17/15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SecretTableViewCell.h"


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
    _imageView = [UIImageView new];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = kKAPImageViewSize / 2.f;
    
    
    [self.contentView addSubview:_imageView];
    
    _textLabel = [UILabel new];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.font = [UIFont systemFontOfSize:17.f];
    _textLabel.textColor = [UIColor darkGrayColor];
    
    [self.contentView addSubview:_textLabel];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    NSDictionary *metrics = @{@"kKAPImageViewSize" : @(kKAPImageViewSize),
                              @"kKAPImageViewMargin" : @(kKAPImageViewMargin)};
    
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
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_textLabel]-0-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_textLabel)]];
    
    NSString *visualFormat = @"H:|-kKAPImageViewMargin-[_imageView(kKAPImageViewSize)]-kKAPImageViewMargin-[_textLabel]-20-|";
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_imageView, _textLabel)]];
}

@end
