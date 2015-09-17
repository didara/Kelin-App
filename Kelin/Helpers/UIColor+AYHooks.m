//
//  UIColor+AYHooks.m
//  AYToolkit
//
//  Created by Ayan Yenbekbay on 2/17/15.
//  Copyright (c) 2015 Ayan Yenbekbay. All rights reserved.
//

#import "UIColor+AYHooks.h"
#define MAKEBYTE(_VALUE_) (int)(_VALUE_ * 0xFF) & 0xFF

@implementation UIColor (AYHooks)

+ (instancetype)colorWithHexString:(NSString *)stringToConvert {
    NSString *string = stringToConvert;
    if ([string hasPrefix:@"#"])
        string = [string substringFromIndex:1];
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum;
    if (![scanner scanHexInt: &hexNum]) return nil;
    int r = (hexNum >> 16) & 0xFF;
    int g = (hexNum >> 8) & 0xFF;
    int b = (hexNum) & 0xFF;
    
    return [UIColor colorWithRed:r/255.0f
                           green:g/255.0f
                            blue:b/255.0f
                           alpha:1.0f];
}

- (instancetype)lighterColor:(CGFloat)increment {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:(CGFloat)MIN(r + increment, 1)
                               green:(CGFloat)MIN(g + increment, 1)
                                blue:(CGFloat)MIN(b + increment, 1)
                               alpha:a];
    return nil;
}

- (instancetype)darkerColor:(CGFloat)decrement {
    CGFloat r, g, b, a;
    if ([self getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:(CGFloat)MAX(r - decrement, 0)
                               green:(CGFloat)MAX(g - decrement, 0)
                                blue:(CGFloat)MAX(b - decrement, 0)
                               alpha:a];
    return nil;
}

- (BOOL)isEqualToColor:(UIColor *)compareColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
            
            UIColor *convertedColor = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return convertedColor;
        } else {
            return color;
        }
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    compareColor = convertColorToRGBSpace(compareColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:compareColor];
}

- (BOOL)isDarkColor {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    CGFloat lum = 0.2126f * r + 0.7152f * g + 0.0722f * b;
    if (lum < .5f) {
        return YES;
    }
    return NO;
}

- (BOOL)isDistinct:(UIColor*)compareColor {
    CGFloat r, g, b, a;
    CGFloat r1, g1, b1, a1;
    [self getRed:&r green:&g blue:&b alpha:&a];
    [compareColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    CGFloat threshold = .25; //.15
    if (fabs(r - r1) > threshold ||
        fabs(g - g1) > threshold ||
        fabs(b - b1) > threshold ||
        fabs(a - a1) > threshold) {
        // Check for grays, prevent multiple gray colors
        if (fabs(r - g) < .03 && fabs(r - b) < .03) {
            if (fabs(r1 - g1) < .03 && fabs(r1 - b1) < .03)
                return NO;
        }
        return YES;
    }
    return NO;
}

- (instancetype)colorWithMinimumSaturation:(CGFloat)minSaturation {
    CGFloat hue = 0.0;
    CGFloat saturation = 0.0;
    CGFloat brightness = 0.0;
    CGFloat alpha = 0.0;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    if (saturation < minSaturation) {
        return [UIColor colorWithHue:hue saturation:minSaturation brightness:brightness alpha:alpha];
    }
    return self;
}

- (BOOL)isBlackOrWhite {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    if (r > .91 && g > .91 && b > .91)
        return YES; // White
    if (r < .09 && g < .09 && b < .09)
        return YES; // Black
    return NO;
}

- (BOOL)isBlack {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    if (r < .01 && g < .01 && b < .01)
        return YES;
    return NO;
}

- (BOOL)isContrastingColor:(UIColor *)color {
    if (color != nil) {
        CGFloat br, bg, bb, ba;
        CGFloat fr, fg, fb, fa;
        [self getRed:&br green:&bg blue:&bb alpha:&ba];
        [color getRed:&fr green:&fg blue:&fb alpha:&fa];
        CGFloat bLum = 0.2126f * br + 0.7152f * bg + 0.0722f * bb;
        CGFloat fLum = 0.2126f * fr + 0.7152f * fg + 0.0722f * fb;
        CGFloat contrast = 0.;
        if (bLum > fLum)
            contrast = (bLum + 0.05f) / (fLum + 0.05f);
        else
            contrast = (fLum + 0.05f) / (bLum + 0.05f);
        // Return contrast > 3.0; //3-4.5 W3C recommends a minimum ratio of 3:1
        return contrast > 3;
    }
    return YES;
}

- (instancetype)inversedColor {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return [UIColor colorWithRed:1-r green:1-g blue:1-b alpha:a];
}

- (instancetype)blendWithColor:(UIColor *)color2 alpha:(CGFloat)alpha2 {
    alpha2 = MIN( 1.0, MAX( 0.0, alpha2 ) );
    CGFloat beta = 1.0 - alpha2;
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    CGFloat red = r1 * beta + r2 * alpha2;
    CGFloat green = g1 * beta + g2 * alpha2;
    CGFloat blue = b1 * beta + b2 * alpha2;
    CGFloat alpha = a1 * beta + a2 * alpha2;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

CGColorSpaceRef DeviceRGBSpace()
{
    static CGColorSpaceRef rgbSpace = NULL;
    if (rgbSpace == NULL)
        rgbSpace = CGColorSpaceCreateDeviceRGB();
    return rgbSpace;
}

CGColorSpaceRef DeviceGraySpace()
{
    static CGColorSpaceRef graySpace = NULL;
    if (graySpace == NULL)
        graySpace = CGColorSpaceCreateDeviceGray();
    return graySpace;
}

- (CGColorSpaceModel) colorSpaceModel
{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}


- (BOOL) canProvideRGBComponents
{
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
        case kCGColorSpaceModelMonochrome:
            return YES;
        default:
            return NO;
    }
}

- (BOOL) usesMonochromeColorspace
{
    return (self.colorSpaceModel == kCGColorSpaceModelMonochrome);
}

- (CGFloat) red
{
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -red");
    CGFloat r = 0.0f;
    
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
            [self getRed:&r green:NULL blue:NULL alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&r alpha:NULL];
        default:
            break;
    }
    
    return r;
}

- (CGFloat) green
{
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -green");
    CGFloat g = 0.0f;
    
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
            [self getRed:NULL green:&g blue:NULL alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&g alpha:NULL];
        default:
            break;
    }
    
    return g;
}

- (CGFloat) blue
{
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -blue");
    CGFloat b = 0.0f;
    
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
            [self getRed:NULL green:NULL blue:&b alpha:NULL];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:&b alpha:NULL];
        default:
            break;
    }
    
    return b;
}

- (CGFloat) alpha
{
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -alpha");
    CGFloat a = 0.0f;
    
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
            [self getRed:NULL green:NULL blue:NULL alpha:&a];
            break;
        case kCGColorSpaceModelMonochrome:
            [self getWhite:NULL alpha:&a];
        default:
            break;
    }
    
    return a;
}

- (CGFloat) white
{
    NSAssert(self.usesMonochromeColorspace, @"Must be a Monochrome color to use -white");
    
    CGFloat w;
    [self getWhite:&w alpha:NULL];
    return w;
}

- (Byte) redByte { return MAKEBYTE(self.red); }
- (Byte) greenByte { return MAKEBYTE(self.green); }
- (Byte) blueByte { return MAKEBYTE(self.blue); }
- (Byte) alphaByte { return MAKEBYTE(self.alpha); }
- (Byte) whiteByte { return MAKEBYTE(self.white); };

- (NSString *) hexStringValue
{
    NSAssert(self.canProvideRGBComponents, @"Must be an RGB color to use -hexStringValue");
    NSString *result;
    switch (self.colorSpaceModel)
    {
        case kCGColorSpaceModelRGB:
            result = [NSString stringWithFormat:@"%02X%02X%02X", self.redByte, self.greenByte, self.blueByte];
            break;
        case kCGColorSpaceModelMonochrome:
            result = [NSString stringWithFormat:@"%02X%02X%02X", self.whiteByte, self.whiteByte, self.whiteByte];
            break;
        default:
            result = nil;
    }
    return result;
}

@end
