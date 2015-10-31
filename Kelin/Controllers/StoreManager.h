//
//  StoreManager.h
//  Kelin
//
//  Created by Zhanserik on 10/18/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

static NSString *kKelinVIPAvatarsProductIdentifier = @"com.Kelin.VIP.Avatar";
static NSString *kKelinNicknamesProductIdentifier = @"com.Kelin.Nickname";
static NSString *kKelinBestSecretsProductIdentifier = @"com.Kelin.Best.Secrets";

static NSString *kKelinVIPAvatarIdentifierKey = @"kKelinVIPAvatarIdentifierKey";
static NSString *kKelinNicknamesIdentifierKey = @"kKelinNicknamesIdentifierKey";
static NSString *kKelinTopSecretIdentifierKey = @"kKelinTopSecretIdentifierKey";

@interface StoreManager : NSObject

+ (instancetype) sharedManager;

- (void) startObserving;

- (void) buyVipAvatarWithComplition:(void(^)(NSError *error))complition;
- (void) buyCustomNicknameWithComplition:(void(^)(NSError *error))complition;
- (void) buyTopSecretWithComplition:(void(^)(NSError *error))complition;

@end
