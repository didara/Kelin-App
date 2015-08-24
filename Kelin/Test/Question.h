//
//  Question.h
//  K
//
//  Created by Didara Pernebayeva on 27.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface Question : PFObject <PFSubclassing>

@property (nonatomic) NSString *text;
@property (nonatomic) NSString *answer;
@property (nonatomic) NSArray *options;

@end
