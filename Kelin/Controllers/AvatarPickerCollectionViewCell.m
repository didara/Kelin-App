//
//  AvatarPickerCollectionViewCell.m
//  Kelin
//
//  Created by Zhanserik on 10/15/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "AvatarPickerCollectionViewCell.h"
#import "UIImage+AYAdditions.h"

@implementation AvatarPickerCollectionViewCell

@synthesize selected = _selected;

- (instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        self.imageView = [UIImageView new];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.imageView];
        
        self.selectionColor = [UIColor blackColor];
    }
    
    self.layer.masksToBounds = YES;
    //self.layer.cornerRadius = CGRectGetHeight(frame) / 2.0f;
    
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_imageView]-20-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_imageView)]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_imageView]-20-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_imageView)]];
    
}

- (void) setSelected:(BOOL)selected{
    _selected = selected;
    
    if(!self.imageView.image){
        return;
    }
    
    if(selected){
        self.contentView.backgroundColor = self.selectionColor;
        self.imageView.image = [self.imageView.image imageWithColor:[UIColor whiteColor]];
    }
    else{
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.imageView.image = [self.imageView.image imageWithColor:[UIColor blackColor]];
    }
}
@end
