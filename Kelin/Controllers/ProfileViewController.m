//
//  ProfileViewController.m
//  Kelin
//
//  Created by Zhanserik on 10/13/15.
//  Copyright © 2015 Didara Pernebayeva. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "UIColor+AYHooks.h"
#import "AvatarPickerView.h"
#import "ProfileTableViewCell.h"
#import "UIImage+AYAdditions.h"
#import "AvatarChangeView.h"
#import <Parse/Parse.h>
#import "StoreManager.h"

static CGFloat kKelinBackgroundImageViewHeight = 280.f;
static NSInteger kBSANumberOfComponents = 3;

static CGFloat kKelinImageViewSize = 90.0f;
static CGFloat kKelinImageViewBorderWidth = 5.0f;

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic) UIBarButtonItem *editBarButtonItem;

@property (nonatomic) UIImageView *backgroundImageView;

@property (nonatomic) UIImageView *crownImageView;
@property (nonatomic) UIView *containerView;
@property (nonatomic) UIView *avatarContainerView;
@property (nonatomic) UIImageView *avatarImageView;

@property (nonatomic) UITextField *nicknameTextField;
@property (nonatomic) CALayer *nicknameBottomBorder;

@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) CALayer *cityBottomBorder;
@property (nonatomic) UIPickerView *cityPickerView;
@property (nonatomic) NSArray *cityList;

@property (nonatomic) UITableView *tableView;

@property (nonatomic) BOOL isEditing;

@property (nonatomic) NSArray *iconList;
@property (nonatomic) NSArray *colorList;
@property (nonatomic) NSInteger currentIcon;
@property (nonatomic) NSInteger currentColor;

@property (nonatomic) AvatarChangeView *iconChangeView;
@property (nonatomic) UISwipeGestureRecognizer *iconViewGestureUp;
@property (nonatomic) UISwipeGestureRecognizer *iconViewGestureDown;

@property (nonatomic) AvatarChangeView *colorChangeView;
@property (nonatomic) UISwipeGestureRecognizer *colorViewGestureUp;
@property (nonatomic) UISwipeGestureRecognizer *colorViewGestureDown;

@property (nonatomic) BOOL iconChanged;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightBarButtonItem = [UIBarButtonItem new];
    self.rightBarButtonItem.action = @selector(rightBarButtonItemDidPress:);
    self.rightBarButtonItem.target = self;
    self.rightBarButtonItem.image = [UIImage imageNamed:@"rings_icon"];
    
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.hidesBackButton = YES;
    
    self.editBarButtonItem = [UIBarButtonItem new];
    self.editBarButtonItem.title = @"Изменить";
    self.editBarButtonItem.target = self;
    self.editBarButtonItem.action = @selector(editBarButtonDidPress:);
    
    self.navigationItem.leftBarButtonItem = self.editBarButtonItem;
    
    self.backgroundImageView = [UIImageView new];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.frame = CGRectMake(0,
                                                64,
                                                CGRectGetWidth(self.view.frame),
                                                kKelinBackgroundImageViewHeight);
    self.backgroundImageView.image = [UIImage imageNamed:@"background_image"];
    
    [self.view addSubview:self.backgroundImageView];
    
    
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0,
                                      CGRectGetMaxY(self.backgroundImageView.frame),
                                      CGRectGetWidth(self.view.frame),
                                      CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(self.backgroundImageView.frame));
    
    [self.view addSubview:self.tableView];
    
    self.containerView = [UIView new];
    self.containerView.frame = CGRectMake(0,
                                          0,
                                          kKelinImageViewSize + kKelinImageViewBorderWidth,
                                          kKelinImageViewSize + kKelinImageViewBorderWidth);
    self.containerView.center = CGPointMake(CGRectGetWidth(self.backgroundImageView.frame) / 2.0f,
                                            CGRectGetHeight(self.backgroundImageView.frame) / 2.0f - 30);
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = CGRectGetHeight(self.containerView.frame) / 2.f;
    self.containerView.layer.borderWidth = kKelinImageViewBorderWidth;
    self.containerView.layer.borderColor = [UIColor colorWithRed:1.0 green:0.84 blue:0.0 alpha:1.0].CGColor;
    
    [self.backgroundImageView addSubview:self.containerView];
    
    self.avatarContainerView = [UIView new];
    self.avatarContainerView.frame = CGRectMake(0,
                                                0,
                                                kKelinImageViewSize - 3,
                                                kKelinImageViewSize - 3);
    
    self.avatarContainerView.center = CGPointMake(CGRectGetWidth(self.containerView.frame) / 2.0f,
                                                  CGRectGetHeight(self.containerView.frame) / 2.0f);
    
    self.avatarContainerView.layer.masksToBounds = YES;
    self.avatarContainerView.layer.cornerRadius = CGRectGetHeight(self.avatarContainerView.frame) / 2.f;
    self.avatarContainerView.layer.borderWidth = kKelinImageViewBorderWidth;
    self.avatarContainerView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.containerView addSubview:self.avatarContainerView];
    
    self.avatarImageView = [UIImageView new];
    self.avatarImageView.frame = CGRectMake(0, 0, kKelinImageViewSize - 35, kKelinImageViewSize - 35);
    self.avatarImageView.center = CGPointMake(CGRectGetWidth(self.avatarContainerView.frame) / 2.0f,
                                              CGRectGetHeight(self.avatarContainerView.frame) / 2.0f);
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.avatarContainerView addSubview:self.avatarImageView];
    
    self.crownImageView = [UIImageView new];
    self.crownImageView.frame = CGRectMake(0, 0, 50, 30);
    self.crownImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.crownImageView.center = CGPointMake(CGRectGetWidth(self.backgroundImageView.frame) / 2.0f,
                                             CGRectGetMinY(self.containerView.frame)-7);
    self.crownImageView.image = [UIImage imageNamed:@"crown_icon"];
    
    [self.backgroundImageView addSubview:self.crownImageView];
    
    self.nicknameTextField = [UITextField new];
    self.nicknameTextField.frame = CGRectMake(0, 0, 220, 30);
    self.nicknameTextField.textAlignment = NSTextAlignmentCenter;
    self.nicknameTextField.textColor = [UIColor whiteColor];
    self.nicknameTextField.center = CGPointMake(CGRectGetWidth(self.backgroundImageView.frame) / 2.0f,
                                                CGRectGetMaxY(self.containerView.frame) + 25);
//    self.nicknameTextField.placeholder = ;
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"@ВашНикнейм" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.nicknameTextField.attributedPlaceholder = attributedPlaceholder;
    
    NSString *oldNick = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPNicknameIdentifierKey];
    self.nicknameTextField.text = oldNick;
    self.nicknameTextField.delegate = self;
    self.nicknameTextField.userInteractionEnabled = YES;
    self.nicknameTextField.enabled = NO;
    
    self.nicknameBottomBorder = [CALayer new];
    self.nicknameBottomBorder.frame = CGRectMake(0,
                                             CGRectGetHeight(self.nicknameTextField.frame) - 1 / [UIScreen mainScreen].scale,
                                             CGRectGetWidth(self.nicknameTextField.frame),
                                             1 / [UIScreen mainScreen].scale);
    self.nicknameBottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    self.nicknameBottomBorder.hidden = YES;
    
    [self.nicknameTextField.layer addSublayer:self.nicknameBottomBorder];
    
    [self.backgroundImageView addSubview:self.nicknameTextField];
    
    self.cityTextField = [UITextField new];
    self.cityTextField.frame = CGRectMake(0, 0, 220, 30);
    self.cityTextField.textAlignment = NSTextAlignmentCenter;
    self.cityTextField.textColor = [UIColor whiteColor];
    self.cityTextField.center = CGPointMake(CGRectGetWidth(self.backgroundImageView.frame) / 2.0f,
                                            CGRectGetMaxY(self.nicknameTextField.frame) + 25);
    self.cityTextField.enabled = NO;
    
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPCurrentCityIdentifierKey];
    
    if([city length] > 2){
        self.cityTextField.text = city;
    }
    else{
        self.cityTextField.text = @"Алматы";
    }
    
    self.cityBottomBorder = [CALayer new];
    self.cityBottomBorder.frame = CGRectMake(0,
                                             CGRectGetHeight(self.cityTextField.frame) - 1 / [UIScreen mainScreen].scale,
                                             CGRectGetWidth(self.cityTextField.frame),
                                             1 / [UIScreen mainScreen].scale);
    self.cityBottomBorder.backgroundColor = [UIColor whiteColor].CGColor;
    self.cityBottomBorder.hidden = YES;
    
    [self.cityTextField.layer addSublayer:self.cityBottomBorder];

    [self.backgroundImageView addSubview:self.cityTextField];
    
    self.cityPickerView = [UIPickerView new];
    self.cityPickerView.dataSource = self;
    self.cityPickerView.delegate = self;
    
    self.cityTextField.inputView = self.cityPickerView;
    
//    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPCurrentCityIdentifierKey];
    
//    self.cityTextField.text = city;
    
    self.cityList = @[@"Алматы",
                      @"Астана",
                      @"Уральск",
                      @"Атырау",
                      @"Актау",
                      @"Актобе",
                      @"Петропавл",
                      @"Костанай",
                      @"Кокшетау",
                      @"Павлодар",
                      @"Семей",
                      @"Усть-Каменогорск",
                      @"Караганда",
                      @"Жезказган",
                      @"Талдыкорган",
                      @"Тараз",
                      @"Шымкент",
                      @"Кызылорда"];
    
    
    self.colorList = @[@"54c7fc",
                       @"ffcd00",
                       @"ff9600",
                       @"ff2851",
                       @"0076ff",
                       @"44dd5e",
                       @"ff3824",
                       @"8e8e93",
                       @"1abc9c",
                       @"8e44ad",
                       @"e74c3c",
                       @"2c3e50",
                       @"f1c40f",
                       @"e67e22"];
    
    self.iconList = @[@"vip1.png",
                      @"vip2.png",
                      @"vip3.png",
                      @"vip4.png",
                      @"vip5.png",
                      @"vip6.png",
                      @"vip7.png",
                      @"vip8.png",
                      @"vip9.png",];
    
    self.iconChangeView = [[AvatarChangeView alloc] initWithFrame:CGRectMake(0, 0, 60, 100)];
    self.iconChangeView.center = CGPointMake(CGRectGetMinX(self.containerView.frame) / 2.f,
                                             CGRectGetMidY(self.containerView.frame));
    self.iconChangeView.titleLabel.text = @"Иконки";
    self.iconChangeView.alpha = 0.0;
    self.iconChangeView.imageView.image = [[UIImage imageNamed:[self.iconList firstObject]] imageWithColor:[UIColor whiteColor]];
    [self.backgroundImageView addSubview:self.iconChangeView];
    
    self.iconViewGestureUp = [UISwipeGestureRecognizer new];
    self.iconViewGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.iconViewGestureUp addTarget:self action:@selector(iconGestureDidSwipe:)];
    
    [self.iconChangeView addGestureRecognizer:self.iconViewGestureUp];
    
    
    self.iconViewGestureDown = [UISwipeGestureRecognizer new];
    self.iconViewGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.iconViewGestureDown addTarget:self action:@selector(iconGestureDidSwipe:)];
    
    [self.iconChangeView addGestureRecognizer:self.iconViewGestureDown];
    
    
    self.colorChangeView = [[AvatarChangeView alloc] initWithFrame:CGRectMake(0, 0, 60, 100)];
    self.colorChangeView.imageViewContainerView.backgroundColor = [UIColor colorWithHexString:[self.colorList firstObject]];
    self.colorChangeView.titleLabel.text = @"Цвет";
    self.colorChangeView.alpha = 0.0;
    
    self.colorChangeView.center = CGPointMake(CGRectGetMaxX(self.containerView.frame) + (CGRectGetMaxX(self.view.frame) - CGRectGetMaxX(self.containerView.frame)) / 2.f,
                                             CGRectGetMidY(self.containerView.frame));
    [self.backgroundImageView addSubview:self.colorChangeView];
    
    self.colorViewGestureUp = [UISwipeGestureRecognizer new];
    self.colorViewGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.colorViewGestureUp addTarget:self action:@selector(colorGestureDidSwipe:)];
    
    [self.colorChangeView addGestureRecognizer:self.colorViewGestureUp];
    
    self.colorViewGestureDown = [UISwipeGestureRecognizer new];
    self.colorViewGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.colorViewGestureDown addTarget:self action:@selector(colorGestureDidSwipe:)];
    
    [self.colorChangeView addGestureRecognizer:self.colorViewGestureDown];
    
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if([[NSUserDefaults standardUserDefaults] objectForKey:kKAPAvatarColorIdentifierKey]){
        NSString *colorName = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPAvatarColorIdentifierKey];
        
        //self.avatarImageView.backgroundColor = [UIColor colorWithHexString:colorName];
        self.avatarContainerView.backgroundColor = [UIColor colorWithHexString:colorName];
        
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:kKAPAvatarImageIdentifierKey]){
        NSString *imageName = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPAvatarImageIdentifierKey];
        UIImage *image = [[UIImage imageNamed:imageName] imageWithColor:[UIColor whiteColor]];
        
        self.avatarImageView.image = image;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) rightBarButtonItemDidPress: (id) sender{
    //UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
    
    //[self.navigationController pushViewController:controller animated:YES];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.45;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    transition.type = kCATransitionFromRight;
    [transition setType:kCATransitionPush];
    transition.subtype = kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Datasource & Delegate

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return kBSANumberOfComponents;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CGRectGetHeight(tableView.frame) / kBSANumberOfComponents;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"identidier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor colorWithHexString:@"DB3C50"];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0){
        cell.imageView.image = [UIImage imageNamed:@"vip_icon"];
        cell.textLabel.text = @"Поменять королевскую аватарку";
        cell.detailTextLabel.text = @"Привлеките внимание на форуме";
    }
    else if (indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"insta_icon"];
        cell.textLabel.text = @"Следите в Instagram";
        cell.detailTextLabel.text = @"Быть в курсе событий всех келинок";
    }
    else if (indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"logout_icon"];
        cell.textLabel.text = @"Выйти c аккаунта";
        cell.detailTextLabel.text = @"Вы всегда можете зайти вновь";
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreViewController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.row == 1){
        NSURL *instaURL = [[NSURL alloc] initWithString:@"instagram://user?username=the_kelin"];
        
        if (![[UIApplication sharedApplication] canOpenURL:instaURL] ) {
            instaURL = [[NSURL alloc] initWithString:@"http://instagram.com/the_kelin"];
        }
        
        [[UIApplication sharedApplication] openURL:instaURL];
    }
    else if (indexPath.row == 2){
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Выйти с аккаунта?"
//                                                            message:@"Не уходите :)"
//                                                           delegate:self
//                                                  cancelButtonTitle:@"Отмена"
//                                                  otherButtonTitles:@"Выйти", nil];
//        [alertView show];
        [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
            [self performSegueWithIdentifier:@"goToAuthorization" sender:nil];
        }];
    }
}

#pragma mark - <UIPickerViewDelegate>

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.cityList[row];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.cityTextField.text = self.cityList[row];
}
#pragma mark - <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.cityList count];
}

#pragma mark - <UITextFieldDelegate>

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    if([textField.text length] < 1){
        textField.text = @"@";
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(![textField.text hasPrefix:@"@"] && [textField.text length] > 0){
        textField.text = [NSString stringWithFormat:@"@%@", textField.text];
    }
}

- (void) editBarButtonDidPress: (UIBarButtonItem *) item{
    self.isEditing = !self.isEditing;
    
    self.nicknameBottomBorder.hidden = !self.isEditing;
    self.cityBottomBorder.hidden = !self.isEditing;
    self.nicknameTextField.enabled = self.isEditing;
    self.cityTextField.enabled = self.isEditing;
    
    if(self.isEditing){
        self.editBarButtonItem.title = @"Сохранить";
        
        [UIView animateWithDuration:0.3f animations:^{
            self.iconChangeView.alpha = 1.f;
            self.colorChangeView.alpha = 1.f;
        }];
    }
    
    else{
        self.editBarButtonItem.title = @"Изменить";
        
        [UIView animateWithDuration:0.3f animations:^{
            self.iconChangeView.alpha = .0f;
            self.colorChangeView.alpha = .0f;
        }];
        
        [self saveChanges];
    }
}

- (void) saveChanges{
    
    [self.cityTextField resignFirstResponder];
    [self.nicknameTextField resignFirstResponder];
    
    NSString *city = self.cityTextField.text;
    
    if(city){
        [[NSUserDefaults standardUserDefaults] setObject:city forKey:kKAPCurrentCityIdentifierKey];
    }
    
    if(self.iconChanged){
        NSString *color = self.colorList[self.currentColor];
        NSString *icon = self.iconList[self.currentIcon];
        
//        static NSString *kKAPAvatarImageIdentifierKey = @"kKAPAvatarImageIdentifierKey";
//        static NSString *kKAPAvatarColorIdentifierKey = @"kKAPAvatarColorIdentifierKey";
        
        NSString *currentColor = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPAvatarColorIdentifierKey];
        NSString *currentIcon = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPAvatarImageIdentifierKey];
        
        if(![color isEqualToString:currentColor] || ![icon isEqualToString:currentIcon]){
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:kKelinVIPAvatarIdentifierKey]){
                [[NSUserDefaults standardUserDefaults] setObject:color forKey:kKAPAvatarColorIdentifierKey];
                [[NSUserDefaults standardUserDefaults] setObject:icon forKey:kKAPAvatarImageIdentifierKey];
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kKelinVIPAvatarIdentifierKey];
            }
            else{
                
                self.avatarImageView.image = [[UIImage imageNamed:currentIcon] imageWithColor:[UIColor whiteColor]];
                self.avatarContainerView.backgroundColor = [UIColor colorWithHexString:currentColor];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Аватарка недоступна"
                                                                    message:@"Келинка, купи возможность изменить аватарку в магазине."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
                return;
            }
            
        }
    }
    
    
    NSString *nickname = self.nicknameTextField.text;
    NSString *oldNick = [[NSUserDefaults standardUserDefaults] objectForKey:kKAPNicknameIdentifierKey];
    
    if(![nickname isEqualToString:oldNick]){
        if([[NSUserDefaults standardUserDefaults] boolForKey:kKelinNicknamesIdentifierKey]){
            
           NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_@"];
           // NSCharacterSet *alphaSet = [NSCharacterSet alphanumericCharacterSet];
            BOOL valid = [[nickname stringByTrimmingCharactersInSet:set] isEqualToString:@""];
           
            if(!valid){
                
                self.nicknameTextField.text = oldNick;
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                    message:@"Келинка, никнейм должен состоять только из букв и цифр"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
        
            }
            else{
                [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:kKAPNicknameIdentifierKey];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kKelinNicknamesIdentifierKey];
            }
        }
        else{
            
            self.nicknameTextField.text = oldNick;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Никнейм недоступен"
                                                                message:@"Келинка, купи возможность изменить никнейм в магазине."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
    }
    else{
        self.nicknameTextField.text = oldNick;
    }
    
}

- (void) colorGestureDidSwipe: (UISwipeGestureRecognizer *) sender{
    
    if(sender.direction == UISwipeGestureRecognizerDirectionUp){
        self.currentColor ++;
        self.currentColor = self.currentColor % [self.colorList count];
    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionDown){
        self.currentColor --;
        if(self.currentColor < 0){
            self.currentColor = [self.colorList count] - 1;
        }
    }
    self.avatarContainerView.backgroundColor = [UIColor colorWithHexString:self.colorList[self.currentColor]];
    self.colorChangeView.imageViewContainerView.backgroundColor = [UIColor colorWithHexString:self.colorList[self.currentColor]];
    
    self.iconChanged = YES;
}
- (void) iconGestureDidSwipe: (UISwipeGestureRecognizer *) sender{
    
    if(sender.direction == UISwipeGestureRecognizerDirectionUp){
        self.currentIcon ++;
        self.currentIcon = self.currentIcon % [self.iconList count];
    }
    else if(sender.direction == UISwipeGestureRecognizerDirectionDown){
        self.currentIcon --;
        if(self.currentIcon < 0){
            self.currentIcon = [self.iconList count] - 1;
        }
    }
    
    self.iconChangeView.imageView.image = [[UIImage imageNamed:self.iconList[self.currentIcon]] imageWithColor:[UIColor whiteColor]];
    self.avatarImageView.image = [[UIImage imageNamed:self.iconList[self.currentIcon]] imageWithColor:[UIColor whiteColor]];
    
    self.iconChanged = YES;
}
@end
