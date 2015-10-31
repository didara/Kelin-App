//
//  StoreManager.m
//  Kelin
//
//  Created by Zhanserik on 10/18/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "StoreManager.h"
#import "AppDelegate.h"

@implementation StoreManager

static StoreManager *manager;

+ (instancetype) sharedManager{
    static dispatch_once_t predicate;
    dispatch_once( &predicate, ^{
        manager = [[self alloc] init];
    } );
    return manager;
}

- (void) startObserving{
    [PFPurchase addObserverForProduct:kKelinBestSecretsProductIdentifier block:^(SKPaymentTransaction *transaction) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKelinTopSecretIdentifierKey];
        
    }];
    [PFPurchase addObserverForProduct:kKelinNicknamesProductIdentifier block:^(SKPaymentTransaction *transaction) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKelinNicknamesIdentifierKey];
        
    }];
    [PFPurchase addObserverForProduct:kKelinVIPAvatarsProductIdentifier block:^(SKPaymentTransaction *transaction) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKelinVIPAvatarIdentifierKey];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKAPVIPAvatarIdentifierKey];
        
    }];
}

- (void) buyVipAvatarWithComplition:(void(^)(NSError *error))complition{
    [PFPurchase buyProduct:kKelinVIPAvatarsProductIdentifier block:^(NSError *error) {
        if (complition) {
            complition(error);
        }
    }];
}
- (void) buyCustomNicknameWithComplition:(void(^)(NSError *error))complition{
    [PFPurchase buyProduct:kKelinNicknamesProductIdentifier block:^(NSError *error) {
        if (complition) {
            complition(error);
        }
    }];
}
- (void) buyTopSecretWithComplition:(void(^)(NSError *error))complition{
    [PFPurchase buyProduct:kKelinBestSecretsProductIdentifier block:^(NSError *error) {
        if (complition) {
            complition(error);
        }
    }];
}

@end
