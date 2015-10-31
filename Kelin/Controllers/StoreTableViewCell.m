//
//  StoreTableViewCell.m
//  Kelin
//
//  Created by Zhanserik on 10/14/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "StoreTableViewCell.h"
#import "MOStoreButton.h"

static CGFloat kImageViewHorizontalMargin = 30.f;
static CGFloat kImageViewWidth = 70.f;

static CGFloat kStoreButtonHeight = 30.f;
static CGFloat kTextLabelHeght = 20.f;

@interface StoreTableViewCell()


@property (nonatomic) UIView *rightView;

@end

@implementation StoreTableViewCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize buttonTitle = _buttonTitle;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self initialize];
    }
    
    return self;
}

- (void) initialize{
    
    _imageView = [UIImageView new];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:_imageView];
    
    self.rightView = [UIView new];
    self.rightView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:self.rightView];
    
    _textLabel = [UILabel new];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:17.0f];
    _textLabel.textColor = [UIColor darkGrayColor];
    _textLabel.numberOfLines = 0;
    [self.rightView addSubview:_textLabel];
    
    _detailTextLabel = [UILabel new];
    _detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
    _detailTextLabel.textColor = [UIColor colorWithWhite:155.f/255.f alpha:1.0];
    _detailTextLabel.numberOfLines = 0;
    [self.rightView addSubview:_detailTextLabel];
    
    self.storeButton = [UIButton new];
    self.storeButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.storeButton.layer.masksToBounds = YES;
    self.storeButton.layer.cornerRadius = 5.f;
    self.storeButton.layer.borderWidth = 1.f;
    self.storeButton.layer.borderColor = [UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1].CGColor;
  
    [self.storeButton setTitleColor:[UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1]
                           forState:UIControlStateNormal];
    
    [self.storeButton addTarget:self action:@selector(storeButtonDidPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.storeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    [self.rightView addSubview:self.storeButton];
    
    
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    NSDictionary *metrics = @{@"kImageViewHorizontalMargin" : @(kImageViewHorizontalMargin),
                              @"kImageViewWidth" : @(kImageViewWidth),
                              @"kTextLabelHeght" : @(kTextLabelHeght),
                              @"kStoreButtonHeight" : @(kStoreButtonHeight)
                              };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_imageView]"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0.0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_rightView]-0-|"
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:NSDictionaryOfVariableBindings(_rightView)]];
    
    NSString *visualFormat = @"H:|-kImageViewHorizontalMargin-[_imageView(kImageViewWidth)]-kImageViewHorizontalMargin-[_rightView]-15-|";
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
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
    
    [self.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_storeButton(120)]"
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:NSDictionaryOfVariableBindings(_storeButton)]];
    
    visualFormat = @"V:|-12-[_textLabel(kTextLabelHeght)]-0-[_detailTextLabel]-[_storeButton(kStoreButtonHeight)]-20-|";
    
    [self.rightView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                           options:0
                                                                           metrics:metrics
                                                                             views:NSDictionaryOfVariableBindings(_textLabel, _detailTextLabel, _storeButton)]];
    
}

- (void) storeButtonDidPress{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(storeButtonDidPressForCell:)]){
            [self.delegate storeButtonDidPressForCell:self];
        }
    }
}

- (void) setButtonTitle:(NSString *)buttonTitle{
    _buttonTitle = buttonTitle;
      [self.storeButton setTitle:buttonTitle forState:UIControlStateNormal];
}
- (NSString *) buttonTitle{
    return _buttonTitle;
}
@end
