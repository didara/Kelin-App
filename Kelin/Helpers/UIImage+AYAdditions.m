//
//  UIImage+AYAdditions.m
//  AYToolkit
//
//  Created by Ayan Yenbekbay on 2/17/15.
//  Copyright (c) 2015 Ayan Yenbekbay. All rights reserved.
//

#import "UIImage+AYAdditions.h"

#import "AYMacros.h"

@implementation UIImage (AYAdditions)

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)convertViewToImage:(UIView *)view {
    UIImage *capturedScreen;
    
    if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //Optimized/fast method for rendering a UIView as image on iOS 7 and later versions.
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        //For devices running on earlier iOS versions.
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return capturedScreen;
}

@end
