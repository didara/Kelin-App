//
//  DictionaryViewController.m
//  
//
//  Created by Didara Pernebayeva on 20.07.15.
//
//

#import "DictionaryViewController.h"
#import <Parse/Parse.h>
#import "JGProgressHUD.h"
#import <ZLSwipeableView/ZLSwipeableView.h>
#import "DictionaryCard.h"
#import <UIFont+OpenSans.h>

@interface DictionaryViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate>

@property (strong, nonatomic) NSArray *words;
@property (nonatomic) long currentWord;
@property (nonatomic) NSInteger wordsSwiped;
@property (weak, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation DictionaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentWord = 0;
    self.wordsSwiped = 1;
    self.swipeableView.dataSource = self;
    self.swipeableView.delegate = self;
    self.swipeableView.backgroundColor = [UIColor clearColor];
    [self dataFromParseWithLocalDataStore:YES];
}

- (void)dataFromParseWithLocalDataStore:(BOOL)localDataStore {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн убирается";
    [HUD showInView:self.view];
    PFQuery *query = [PFQuery queryWithClassName:@"Dictionary"];
    if (localDataStore) {
        [query fromLocalDatastore];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *words, NSError *error) {
        [HUD dismissAnimated:YES];
        if (!error) {
            if ([words count] > 0) {
                self.words = [words mutableCopy];
                self.number.text = [NSString stringWithFormat:@"%@/%@", @(self.wordsSwiped), @([self.words count])];
                [self.swipeableView discardAllSwipeableViews];
                [self.swipeableView loadNextSwipeableViewsIfNeeded];
            } else if (localDataStore) {
                [self dataFromParseWithLocalDataStore:NO];
            }
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if ([self.words count] > 0 && self.currentWord < [self.words count]) {
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
        PFObject *word = self.words[self.currentWord];
        wordLabel.text = [word[@"Text"] uppercaseString];
        definitionLabel.text = word[@"Words"];
        self.currentWord++;
        
        return dictionaryCard;
    } else {
        return nil;
    }
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView didSwipeView:(UIView *)view inDirection:(ZLSwipeableViewDirection)direction {
    if (self.wordsSwiped < [self.words count]) {
        self.wordsSwiped++;
        self.number.text = [NSString stringWithFormat:@"%@/%@", @(self.wordsSwiped), @([self.words count])];
    }
}





@end
