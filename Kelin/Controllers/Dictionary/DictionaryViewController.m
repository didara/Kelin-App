//
//  DictionaryViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 20.07.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "DictionaryViewController.h"

#import <Parse/Parse.h>
#import "JGProgressHUD.h"
#import <ZLSwipeableView/ZLSwipeableView.h>
#import "DictionaryCard.h"
#import <UIFont+OpenSans.h>

@interface DictionaryViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (nonatomic) NSArray *words;
@property (nonatomic) NSInteger currentWordNumber;
@property (nonatomic) NSInteger wordsSwipedCount;
@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic) JGProgressHUD *HUD;

@end

@implementation DictionaryViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentWordNumber = 0;
    self.wordsSwipedCount = 1;
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    self.swipeableView.backgroundColor = [UIColor clearColor];
    
    [self getDataFromParseFromLocalDataStore:YES];
}

#pragma mark Private

- (void)getDataFromParseFromLocalDataStore:(BOOL)localDataStore {
    PFQuery *query = [PFQuery queryWithClassName:@"Dictionary"];
    if (localDataStore) {
        [query fromLocalDatastore];
    } else if (!self.HUD) {
        self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleLight];
        self.HUD.textLabel.text = @"Келiн пошла за продуктами";
        [self.HUD showInView:self.view];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *words, NSError *error) {
        if (!error) {
            if (words.count > 0) {
                [PFObject pinAllInBackground:words];
                [self.HUD dismissAnimated:YES];
                self.words = [words mutableCopy];
                self.numberLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.wordsSwipedCount), @([self.words count])];
                [self.swipeableView discardAllSwipeableViews];
                [self.swipeableView loadNextSwipeableViewsIfNeeded];
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

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if ([self.words count] > 0 && self.currentWordNumber < [self.words count]) {
        DictionaryCard *dictionaryCard = [[DictionaryCard alloc] initWithFrame:self.swipeableView.bounds];
        UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(dictionaryCard.frame) - 20, CGRectGetHeight(dictionaryCard.frame)*0.4f)];
        wordLabel.backgroundColor = [UIColor whiteColor];
        wordLabel.textColor = [UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1] /*#d81e35*/;
        UILabel *definitionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(wordLabel.frame), CGRectGetWidth(dictionaryCard.frame) - 20, CGRectGetHeight(dictionaryCard.frame)*0.6f)];
        definitionLabel.backgroundColor = [UIColor colorWithRed:0.118 green:0.773 blue:0.847 alpha:1] /*#1ec5d8*/;
        definitionLabel.textColor = [UIColor whiteColor];
        [dictionaryCard addSubview:wordLabel];
        [dictionaryCard addSubview:definitionLabel];
        for (UILabel *label in @[wordLabel, definitionLabel]) {
            label.numberOfLines = 0;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont openSansFontOfSize:32];
        }
        PFObject *word = self.words[self.currentWordNumber];
        wordLabel.text = [word[@"Text"] uppercaseString];
        definitionLabel.text = word[@"Words"];
        self.currentWordNumber++;
        return dictionaryCard;
    } else {
        return nil;
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
    if (self.wordsSwipedCount < [self.words count]) {
        self.wordsSwipedCount++;
        self.numberLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.wordsSwipedCount), @([self.words count])];
    }
}

@end
