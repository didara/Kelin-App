//
//  SecretTableViewCell.h
//  Kelin
//
//  Created by Zhanserik on 9/17/15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat kKAPImageViewContainerSize = 40.f;
static CGFloat kKAPImageViewMargin = 10.f;
static CGFloat kKAPImageViewSize = 24.f;

@interface SecretTableViewCell : UITableViewCell

@property (nonatomic) UILabel *timeLabel;
@property (nonatomic) UIView  *imageViewContainer;
@property (nonatomic) BOOL isVIP;

@property (nonatomic) UILabel *usernameLabel;

@end
