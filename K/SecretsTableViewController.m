//
//  SecretsTableViewController.m
//  K
//
//  Created by Didara Pernebayeva on 30.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "SecretsTableViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"
#import <UIFont+OpenSans.h>
#import "SecretPostTableViewCell.h"
#import "CarbonKit.h"

@interface SecretsTableViewController ()

@property (nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) NSArray *secretsArray;
//@property (strong, nonatomic) IBOutlet UILabel *numberOfLikes;

@end

@implementation SecretsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadData];
    
    [self.tableView registerClass:[SecretPostTableViewCell class] forCellReuseIdentifier:@"SecretsTableCell2"];
    self.tableView.estimatedRowHeight = 150.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorColor = [UIColor clearColor];
 
    self.refresh = [UIRefreshControl new];
    //[refresh setMarginTop:0];
    //[refresh setColors:@[[UIColor redColor], [UIColor whiteColor]]];
    [self.tableView addSubview:self.refresh];

    [self.refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh:(id)sender {
    [self downloadData];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) downloadData {
   JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
   //HUD.textLabel.text =@"Келинка подготавливает секреты";
    if(!self.refresh.refreshing){
       [HUD showInView:self.view];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Secrets"];
    [query orderByDescending:@"updatedAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [HUD dismissAnimated:YES];
           self.secretsArray = [objects mutableCopy];
            NSLog(@"Successfully retrieved %lu words", (unsigned long)objects.count);
           // PFObject *object = [PFObject objectWithoutDataWithClassName:@"invFriend"
             //                                                  objectId:@"efgh"];
            //[object deleteEventually];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.refresh endRefreshing];
        
        [self.tableView reloadData];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _secretsArray.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    static NSString *CellIdentifier = @"SecretsTableCell2";
    SecretPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell){
        cell = [[SecretPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
       NSLog(@"%i: %@", (int)indexPath.row, _secretsArray[indexPath.row][@"story"]);

    cell.textLabel.text =_secretsArray[indexPath.row][@"story"];
    cell.textLabel.numberOfLines = 0;
    return cell;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //SecretsTableCell *cell = (SecretsTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    CGRect labelRect = [_secretsArray[indexPath.row][@"story"]
                        boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame) - 40, 0)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{
                                     NSFontAttributeName : [UIFont systemFontOfSize:16]
                                     }
                        context:nil];
    
    return labelRect.size.height + 80;
}

@end
