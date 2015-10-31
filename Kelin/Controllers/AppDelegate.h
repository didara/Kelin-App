//
//  AppDelegate.h
//  K
//
//  Created by Didara Pernebayeva on 29.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kKAPAvatarImageIdentifierKey = @"kKAPAvatarImageIdentifierKey";
static NSString *kKAPAvatarColorIdentifierKey = @"kKAPAvatarColorIdentifierKey";
static NSString *kKAPCurrentCityIdentifierKey = @"kKAPCurrentCityIdentifierKey";
static NSString *kKAPNicknameIdentifierKey = @"kKAPNicknameIdentifierKey";
static NSString *kKAPVIPAvatarIdentifierKey = @"kKAPVIPAvatarIdentifierKey";

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;
@property (nonatomic) UINavigationController *navigationController;

@end

