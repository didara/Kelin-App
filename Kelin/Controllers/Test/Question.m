//
//  Question.m
//  Kelin
//
//  Created by Didara Pernebayeva on 27.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "Question.h"

@implementation Question

@dynamic text;
@dynamic answer;
@synthesize options = _options;

#pragma mark Getters and setters

- (void) setOptions:(NSArray *)options{
    _options = options;
}

- (NSArray *) options{
    return _options;
}

#pragma mark PFSubclassing

+ (void) load{
    [self registerSubclass];
}

+ (NSString *) parseClassName{
    return @"Question";
}

@end
