//
//  RecipeDetailsViewController.h
//  Kelin
//
//  Created by Didara Pernebayeva on 13.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>

@interface RecipeDetailsViewController : UITableViewController

@property (nonatomic) PFObject *recipe;

@end
