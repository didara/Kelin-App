//
//  DetailTableViewController.m
//  K
//
//  Created by Didara Pernebayeva on 13.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "DetailTableViewController.h"
#import "SecondTableCell.h"
#import "Parse/Parse.h"

@interface DetailTableViewController ()

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.DetailModule[0][@"intro"];
    
    self.tableView.estimatedRowHeight = 200.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"ИНГРИДИЕНТЫ";
    }
    if (section == 1) {
        return @"ПРИГОТОВЛЕНИЕ";
    }
    return @"ИНГРЕДИЕНТЫ";
}
    // get the text for indexPath
  
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TableCell";
 
   SecondTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SecondTableCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
  
    if(indexPath.section == 0){
        cell.ImageView.image = self.DetailModule[1];
        cell.basicInformationLabel.text = self.DetailModule [2][@"firstInformation"];
        cell.textLabel.text = self.DetailModule [3] [@"ingridients"];
        cell.textLabel.numberOfLines = 0;
    }
    else if (indexPath.section == 1){
        
      //  cell.ingridientsLabel.text = @"Blah blah blah";
        cell.textLabel.text= self.DetailModule[4][@"cook"];
        cell.textLabel.numberOfLines = 0;
    }
    
    return cell;
}



@end
