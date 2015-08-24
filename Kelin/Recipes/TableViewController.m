//
//  TableViewController.m
//  K
//
//  Created by Didara Pernebayeva on 13.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "TableViewController.h"
#import "TableCell.h"
#import "DetailTableViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"


@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.images = [NSMutableArray new];
    [self data: YES];
}
  
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) data:(BOOL)localDataStore  {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
    HUD.textLabel.text = @"Келiн пошла за продуктами";
    [HUD showInView:self.view];

    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    if (localDataStore) {
        [query fromLocalDatastore];
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray *intros, NSError *error) {
                if (!error) {
            [HUD dismissAnimated:YES];
             if ([intros count] > 0) {
                self.recipes = intros;
            } else if (localDataStore) {
                [self data:NO];
            }

            //self.recipes = intros;
            
            NSLog(@"ingridients%@", self.ingridients);
            [self.tableView reloadData];
            } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
    }];
}



#pragma mark - Table view data source


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_recipes count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableCell";
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    int row = [indexPath row];
    
    //JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
  //  HUD.textLabel.text = @"Келiн пошла за продуктами";
  //  [HUD showInView:self.view];
    cell.titleLabel.text = _recipes[row][@"intro"];
    PFFile *imageFile= _recipes[row][@"Image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
              // [HUD dismissAnimated:YES];
                UIImage *image = [UIImage imageWithData:imageData];
                self.images[row] = image;
                cell.thumbImage.image = self.images[row];
              

}
}];
    
       return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *myIndexPath = [self.tableView indexPathForSelectedRow];
        DetailTableViewController *destViewController = segue.destinationViewController;
        self.information =_recipes;
        self.ingridients = _recipes;
        self.cook =_recipes;

        int row = [myIndexPath row];
        NSLog(@"current recipe: %@", _recipes[row]);
        
       destViewController.DetailModule = @[_recipes[row], _images[row],_information[row],_ingridients [row],_cook[row]];
      
        
        // destViewController.title = destViewController.DetailModule;
    }
}

@end
