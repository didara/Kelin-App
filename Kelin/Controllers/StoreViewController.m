//
//  StoreViewController.m
//  Kelin
//
//  Created by Zhanserik on 10/13/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreTableViewCell.h"
#import "StoreItem.h"
#import "StoreManager.h"
#import "UIColor+AYHooks.h"
#import "JGProgressHUD.h"

@interface StoreViewController () <UITableViewDataSource, UITableViewDelegate, StoreTableViewCellDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *storeItems;
@property (nonatomic) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic) JGProgressHUD *HUD;

@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [UITableView new];
    self.tableView.frame = CGRectMake(0,
                                      0,
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetHeight(self.view.frame));
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.storeItems = [self fetchStoreItems];
    
    [self.view addSubview:self.tableView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,0,0)];
    
    self.leftBarButtonItem = [UIBarButtonItem new];
    self.leftBarButtonItem.action = @selector(leftBarButtonItemDidPress:);
    self.leftBarButtonItem.target = self;
    self.leftBarButtonItem.image = [UIImage imageNamed:@"rings_icon"];
    
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.storeItems count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"identifier";
    
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[StoreTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    StoreItem *item = self.storeItems[indexPath.row];
    
    cell.imageView.image = item.image;
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.descr;
    cell.buttonTitle = [NSString stringWithFormat:@"Купить за %@", item.price];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 2){
        if([[NSUserDefaults standardUserDefaults] boolForKey:kKelinTopSecretIdentifierKey]){
            cell.storeButton.layer.borderColor = [UIColor colorWithHexString:@"15C077"].CGColor;
            
            [cell.storeButton setTitleColor:[UIColor colorWithHexString:@"15C077"]
                                   forState:UIControlStateNormal];
            cell.storeButton.userInteractionEnabled = NO;
            [cell.storeButton setTitle:@"Куплено" forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (CGRectGetHeight(tableView.frame) - 64) / 3.f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - Actions

- (NSArray *) fetchStoreItems{
    
    StoreItem *item1 = [StoreItem new];
    item1.title = @"Королевские аватарки";
    item1.descr = @"Уникальные аватарки с возможностью выбора любимого цвета и иконки";
    item1.price = @"$0.99";
    item1.image = [UIImage imageNamed:@"store_item_1"];
    
    StoreItem *item2 = [StoreItem new];
    item2.title = @"Создание никнейма";
    item2.descr = @"Вам не придется больше подписываться в конце своих сообщений.";
    item2.price = @"$0.99";
    item2.image = [UIImage imageNamed:@"store_item_2"];
    
    StoreItem *item3 = [StoreItem new];
    item3.title = @"Лучшие секреты";
    item3.descr = @"Доступ к самым интересным секретам, подобранным для вас создателями приложения.";
    item3.price = @"$0.99";
    item3.image = [UIImage imageNamed:@"store_item_3"];
    
    return @[item1, item2, item3];
}

- (void) storeButtonDidPressForCell: (nonnull StoreTableViewCell *) cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    self.HUD.textLabel.text = @"Келинка пошла за калькулятором...";
    
    
    if(indexPath.row == 0){
        [self.HUD showInView:self.view];
        
        [[StoreManager sharedManager] buyVipAvatarWithComplition:^(NSError *error) {
            
            if ([self.HUD isVisible]) {
                [self.HUD dismissAnimated:YES];
            }
            
            if(!error){
                
            }
        }];
    }
    else if(indexPath.row == 1){
        [self.HUD showInView:self.view];
        
        [[StoreManager sharedManager] buyCustomNicknameWithComplition:^(NSError *error) {
            
            if ([self.HUD isVisible]) {
                [self.HUD dismissAnimated:YES];
            }
            
            if(!error){
                
            }
        }];
    }
    else if(indexPath.row == 2){
        [self.HUD showInView:self.view];
        
        [[StoreManager sharedManager] buyTopSecretWithComplition:^(NSError *error) {
            
            if ([self.HUD isVisible]) {
                [self.HUD dismissAnimated:YES];
            }
            
            if(!error){
                [self.tableView reloadData];
            }
        }];
    }
}

- (void) leftBarButtonItemDidPress: (UIBarButtonItem *) item{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
