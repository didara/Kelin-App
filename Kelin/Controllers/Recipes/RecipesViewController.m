//
//  RecipesViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 13.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "RecipesViewController.h"

#import "RecipesViewCell.h"
#import "RecipeDetailsViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"
#import "UIFont+Sizes.h"
#import <UIFont+OpenSans.h>

@interface RecipesViewController ()

@property (nonatomic) NSArray *recipes;
@property (nonatomic) JGProgressHUD *HUD;

@end

@implementation RecipesViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    [self getDataFromParseFromLocalDataStore:YES];
}

#pragma mark Private

- (void)getDataFromParseFromLocalDataStore:(BOOL)localDataStore {
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    if (localDataStore) {
        [query fromLocalDatastore];
    } else if (!self.HUD) {
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        self.HUD.textLabel.text = @"Келiн пошла за продуктами";
        [self.HUD showInView:self.tableView];
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *intros, NSError *error) {
        if (!error) {
            if (intros.count > 0) {
                [PFObject pinAllInBackground:intros];
                [self.HUD dismissAnimated:YES];
                self.recipes = intros;
                [self.tableView reloadData];
            } else if (localDataStore) {
                [self getDataFromParseFromLocalDataStore:NO];
            }
        } else {
            [self.HUD dismissAnimated:YES];
#warning Show an error
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"" delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            

        }
        
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.recipes[indexPath.row][@"intro"];
    cell.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    cell.thumbImage.clipsToBounds = YES;
    [self.recipes[indexPath.row][@"Image"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.thumbImage.image = image;
        }
    }];
    return cell;
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RecipeDetailsViewController *detailViewController = segue.destinationViewController;
        detailViewController.recipe = self.recipes[indexPath.row];
    }
}

@end
