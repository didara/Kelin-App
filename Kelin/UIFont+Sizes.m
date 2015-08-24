//
//  UIFont+Sizes.m
//  Kelin
//
//  Created by Ayan Yenbekbay on 8/24/15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "UIFont+Sizes.h"

#import "AYMacros.h"

@implementation UIFont (Sizes)

+ (CGFloat)smallTextFontSize {
    if (IS_IPHONE_6P) {
        return 18;
    } else if (IS_IPHONE_6) {
        return 17;
    } else {
        return 16;
    }
}

+ (CGFloat)mediumTextFontSize {
    if (IS_IPHONE_6P) {
        return 20;
    } else if (IS_IPHONE_6) {
        return 19;
    } else {
        return 18;
    }
}

+ (CGFloat)largeTextFontSize {
    if (IS_IPHONE_6P) {
        return 26;
    } else if (IS_IPHONE_6) {
        return 24;
    } else {
        return 22;
    }
}

@end
