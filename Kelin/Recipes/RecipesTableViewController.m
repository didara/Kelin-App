//
//  RecipesTableViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 13.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "RecipesTableViewController.h"

#import "RecipesTableViewCell.h"
#import "DetailTableViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"
#import "UIFont+Sizes.h"
#import <UIFont+OpenSans.h>

@interface RecipesTableViewController ()

@property (nonatomic) NSArray *recipes ;
@property (nonatomic) NSMutableArray *images;
@property (nonatomic) NSArray *information;
@property (nonatomic) NSArray *ingredients;
@property (nonatomic) NSArray *cook;
@property (nonatomic) JGProgressHUD *HUD;

@end

@implementation RecipesTableViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.images = [NSMutableArray new];
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    self.HUD.textLabel.text = @"Келiн пошла за продуктами";
    [self.HUD showInView:self.tableView];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    [self getDataFromParseFromLocalDataStore:YES];
}

#pragma mark Private

- (void)getDataFromParseFromLocalDataStore:(BOOL)localDataStore {
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    if (localDataStore) {
        [query fromLocalDatastore];
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *intros, NSError *error) {
        if (!error) {
            if (intros.count > 0) {
                [self.HUD dismissAnimated:YES];
                self.recipes = intros;
                [self.tableView reloadData];
            } else if (localDataStore) {
                [self getDataFromParseFromLocalDataStore:NO];
            }
        } else {
            [self.HUD dismissAnimated:YES];
            // Show an error
        }
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipes count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    cell.titleLabel.text = _recipes[indexPath.row][@"intro"];
    cell.titleLabel.font = [UIFont openSansFontOfSize:[UIFont mediumTextFontSize]];
    cell.thumbImage.clipsToBounds = YES;
    [self.recipes[indexPath.row][@"Image"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.images[indexPath.row] = image;
            cell.thumbImage.image = self.images[indexPath.row];
        }
    }];
    return cell;
}

#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetailTableViewController *detailViewController = segue.destinationViewController;
        self.information = self.recipes;
        self.ingredients = self.recipes;
        self.cook = self.recipes;
        
        detailViewController.info = @[self.recipes[indexPath.row], self.images[indexPath.row], self.information[indexPath.row], self.ingredients[indexPath.row], self.cook[indexPath.row]];
    }
}

@end
