//
//  TestViewController.m
//  Kelin
//
//  Created by Didara Pernebayeva on 30.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "TestViewController.h"

#import "JGProgressHUD.h"
#import "Question.h"
#import <Parse.h>
#import "ResultsViewController.h"
#import "UIFont+Sizes.h"
#import <UIFont+OpenSans.h>

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UIButton *optionAButton;
@property (weak, nonatomic) IBOutlet UIButton *optionBButton;
@property (weak, nonatomic) IBOutlet UIButton *optionCButton;
@property (weak, nonatomic) IBOutlet UIButton *optionDButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressIndicatorLabel;

@property (nonatomic) NSMutableArray *questions;
@property (nonatomic) NSUInteger processedQuestionsCount;
@property (nonatomic) NSInteger correctAnswersCount;
@property (nonatomic) NSInteger currentQuestion;
@property (nonatomic) NSString *correctAnswer;
@property (nonatomic) CGFloat percentage;
@property (nonatomic) JGProgressHUD *HUD;

@end

@implementation TestViewController

#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.questionLabel.font = [UIFont openSansFontOfSize:[UIFont largeTextFontSize]];
    self.questionLabel.textColor = [UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1] /*#d81e35*/;
    for (UIButton *button in @[self.optionAButton, self.optionBButton, self.optionCButton, self.optionDButton]) {
        button.titleLabel.font = [UIFont openSansFontOfSize:[UIFont smallTextFontSize]];
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    self.progressIndicatorLabel.font = [UIFont openSansFontOfSize:[UIFont largeTextFontSize]];
    
    self.currentQuestion = 0;
    [self enableAll];
    
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    self.HUD.textLabel.text = @"Келiн накрывает на стол";
    [self.HUD showInView:self.view];
    
    [self getDataFromParseFromLocalDataStore:YES];
}
#pragma mark Private

- (void)getDataFromParseFromLocalDataStore:(BOOL)localDataStore {
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    if (localDataStore) {
        [query fromLocalDatastore];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *questions, NSError *questionsError) {
        if (!questionsError) {
            if (questions.count > 0) {
                [PFObject pinAllInBackground:questions];
                self.questions = [questions mutableCopy];
                [self randomizeArray:self.questions];
                [self.questions removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(13, self.questions.count - 13)]];
                self.progressIndicatorLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.currentQuestion), @(self.questions.count)];
                
#warning Attach options to the questions to avoid extra requests
                for (Question *question in self.questions) {
                    PFQuery *optionQuery = [PFQuery queryWithClassName:@"Option"];
                    [optionQuery whereKey:@"questionId" equalTo:question];
                    [optionQuery findObjectsInBackgroundWithBlock:^(NSArray *options, NSError *optionsError) {
                        if (!optionsError) {
                            question.options = options;
                            self.processedQuestionsCount++;
                            if (self.processedQuestionsCount == self.questions.count) {
                                [self.HUD dismissAnimated:YES];
                                [self showCurrentQuestion];
                            }
                        }
                    }];
                }
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

- (void)showCurrentQuestion {
    Question *question = self.questions[self.currentQuestion];
    self.questionLabel.text = question.text;
    self.correctAnswer = question.answer;
    self.currentQuestion++;
    self.progressIndicatorLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.currentQuestion), @(self.questions.count)];
   
    NSMutableArray *options = [question.options mutableCopy];
    [self randomizeArray:options];
    
    [self.optionAButton setTitle:options[0][@"options"] forState:UIControlStateNormal];
    [self.optionBButton setTitle:options[1][@"options"] forState:UIControlStateNormal];
    [self.optionCButton setTitle:options[2][@"options"] forState:UIControlStateNormal];
    [self.optionDButton setTitle:options[3][@"options"] forState:UIControlStateNormal];

    [self resetButtons];
}

- (void)resetButtons {
    for (UIButton *button in @[self.optionAButton, self.optionBButton, self.optionCButton, self.optionDButton]) {
        button.clipsToBounds = YES;
        button.layer.cornerRadius = 7;
        button.backgroundColor = [UIColor colorWithRed:0.118 green:0.773 blue:0.847 alpha:1];
    }
}

- (void)checkAnswer:(UIButton *)button{
    if ([[button titleLabel].text isEqualToString:self.correctAnswer]) {
        self.correctAnswersCount++;
    }
    self.percentage = (CGFloat)self.correctAnswersCount/self.questions.count;
}

- (void)highlightCorrect {
    // Loop through the array of buttons and highlight the correct one
    for (UIButton *button in @[self.optionAButton, self.optionBButton, self.optionCButton, self.optionDButton]) {
        if ([button.titleLabel.text isEqualToString:self.correctAnswer]) {
            button.backgroundColor = [UIColor greenColor];
        }
    }
}

- (void)displayNextQuestion {
    [self enableAll];
    // Try not to use static numbers, instead use variables (the count of the questions array in this case)
    if (self.currentQuestion >= self.questions.count) {
        [self performSegueWithIdentifier:@"showResults" sender:nil];
    } else {
        [self showCurrentQuestion];
    }
}

- (void)disableAll {
    // Loop through the array of buttons and set them all enabled
    for (UIButton *button in @[self.optionAButton, self.optionBButton, self.optionCButton, self.optionDButton]) {
        button.enabled = NO;
    }
}

- (void)enableAll {
    // Loop through the array of buttons and set them all disabled
    for (UIButton *button in @[self.optionAButton, self.optionBButton, self.optionCButton, self.optionDButton]) {
        button.enabled = YES;
    }
}

#pragma mark Actions

- (IBAction)optionButtonPressed:(UIButton *)sender {
    // As you can see, there is no need for four separate methods, one is just enough
    [self resetButtons];
    sender.backgroundColor = [UIColor colorWithRed:0.753 green:0.753 blue:0.753 alpha:1] /*#c0c0c0*/;
    [self highlightCorrect];
    [self checkAnswer:sender];
    [self performSelector:@selector(displayNextQuestion) withObject:nil afterDelay:0.3f];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showResults"]){
        ResultsViewController *controller = segue.destinationViewController;
        controller.percentage = self.percentage;
    }
}

#pragma mark Helpers

- (void)randomizeArray:(NSMutableArray *)array {
    for (NSUInteger i = 0; i < array.count; i++) {
        NSUInteger randomIndex = arc4random() % array.count;
        [array exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
    }
}

@end
