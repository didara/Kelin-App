//
//  StoreItem.h
//  Kelin
//
//  Created by Zhanserik on 10/14/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StoreItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *descr;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *price;

@end
