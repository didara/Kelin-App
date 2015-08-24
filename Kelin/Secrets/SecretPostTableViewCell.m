//
//  SecretPostTableViewCell.m
//  K
//
//  Created by Didara Pernebayeva on 31.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SecretPostTableViewCell.h"
#import <UIFont+OpenSans.h>

@interface SecretPostTableViewCell()

@property (nonatomic) UIView *bottomView;

@end

@implementation SecretPostTableViewCell



@synthesize textLabel = _textLabel;
//@synthesize likeButton = _likeButton;
//@synthesize counterLabel = _counterLabel;
@synthesize bottomView = _bottomView;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self){
        [self initialize];
        [self awakeFromNib];
        
    }
    
    return self;
}

- (void) initialize {
    
    _textLabel = [UILabel new];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _textLabel.textColor = [UIColor darkGrayColor];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.font = [UIFont systemFontOfSize:16.f];
    _textLabel.numberOfLines = 0;
    [self.contentView addSubview:_textLabel];
    
    _bottomView = [UIView new];
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:_bottomView];
    
 /*
    _counterLabel = [UILabel new];
    _counterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _counterLabel.textColor = [UIColor lightGrayColor];
    _counterLabel.textAlignment = NSTextAlignmentRight;
    _counterLabel.font = [UIFont systemFontOfSize:12.f];
    _counterLabel.numberOfLines = 1;
    [_bottomView addSubview:_counterLabel];
    
    
    _likeButton = [UIButton new];
    _likeButton.translatesAutoresizingMaskIntoConstraints = NO;
    _likeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    
    [_bottomView addSubview:_likeButton];
   */
  
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_textLabel]-20-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_textLabel)]];
   [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_bottomView]-20-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_bottomView)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_textLabel]-5-[_bottomView(20)]-5-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_bottomView,_textLabel)]];
    
  /*  [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_counterLabel]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(_counterLabel)]];
    [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_likeButton]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(_likeButton)]];
    [_bottomView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_counterLabel]-5-[_likeButton]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:NSDictionaryOfVariableBindings(_likeButton, _counterLabel)]];
  

}

- (void) layoutSubviews{
    [super layoutSubviews];
}

- (void)awakeFromNib {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeButtonPressed:)];
    [_likeButton addGestureRecognizer:tapGestureRecognizer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)likeButtonPressed:(id)sender {
    _like++;
    NSLog(@"%i", _like);
    self.counterLabel.text = [NSString stringWithFormat:@"%@", @(_like)];
    self.counterLabel.font = [UIFont openSansItalicFontOfSize:14];
}



*/
}
@end
