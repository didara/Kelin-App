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

@interface TestViewController ()

@property (weak, nonatomic) IBOutlet UIButton *optionAButton;
@property (weak, nonatomic) IBOutlet UIButton *optionBButton;
@property (weak, nonatomic) IBOutlet UIButton *optionCButton;
@property (weak, nonatomic) IBOutlet UIButton *optionDButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressIndicatorLabel;

@property (nonatomic) NSMutableArray *questions;
@property (nonatomic) NSInteger correctAnswersCount;
@property (nonatomic) NSInteger currentQuestion;
@property (nonatomic) NSString *correctAnswer;
@property (nonatomic) CGFloat percentage;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentQuestion = 0;
    [self enableAll];
    [self downloadData];
}

- (void)downloadData {
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error){
            [PFObject pinAllInBackground:objects];
            for (Question *question in objects) {
                PFQuery *optionQuery = [PFQuery queryWithClassName:@"Option"];
                [optionQuery whereKey:@"questionId" equalTo:question];
                
                NSArray *list = [optionQuery findObjects];
                question.options = list;
            }
            
            self.questions = [objects mutableCopy];
            [self randomizeArray:self.questions];
            
            [HUD dismissAnimated:YES];
            [self showCurrentQuestion];
        }
    }];
}

- (void)showCurrentQuestion {
    Question *question = self.questions[self.currentQuestion];
    self.questionLabel.text = question.text;
    self.questionLabel.textColor = [UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1] /*#d81e35*/;
    self.correctAnswer = question.answer;
   
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
    self.currentQuestion++;
    // Try not to use static numbers, instead use variables (the count of the questions array in this case)
    if (self.currentQuestion >= self.questions.count) {
        [self performSegueWithIdentifier:@"getResultsSegue" sender:nil];
    } else {
        self.progressIndicatorLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.currentQuestion), @(self.questions.count)];
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

- (IBAction)optionButtonPressed:(UIButton *)sender {
    // As you can see, there is no need for four separate methods, one is just enough
    [self resetButtons];
    sender.backgroundColor = [UIColor colorWithRed:0.753 green:0.753 blue:0.753 alpha:1] /*#c0c0c0*/;
    [self highlightCorrect];
    [self checkAnswer:sender];
    [self performSelector:@selector(displayNextQuestion) withObject:nil afterDelay:0.3f];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"getResultsSegue"]){
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
