//
//  SecretPostTableViewCell.h
//  K
//
//  Created by Didara Pernebayeva on 31.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SecretPostTableViewCell : UITableViewCell

@property (nonatomic) int like;
@property (nonatomic) PFObject *secret;
//@property (nonatomic) UIButton *likeButton;
//@property (nonatomic) UILabel  *counterLabel;

@end
