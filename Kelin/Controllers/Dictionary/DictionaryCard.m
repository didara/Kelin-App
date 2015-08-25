//
//  DictionaryCard.m
//  Kelin
//
//  Created by Didara Pernebayeva on 23.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "DictionaryCard.h"

@implementation DictionaryCard

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    [self setup];
    return self;
}

- (void)setup {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33f;
    self.layer.shadowOffset = CGSizeMake(0, 1.5f);
    self.layer.shadowRadius = 4;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.cornerRadius = 10;
}

@end
