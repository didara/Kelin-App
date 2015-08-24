//
//  TestViewController.m
//  K
//
//  Created by Didara Pernebayeva on 30.06.15.
//  Copyright (c) 2015 Didara Pernebayeva. All rights reserved.
//

#import "TestViewController.h"
#import <Parse/Parse.h>
#import "ResultsViewController.h"
#import "JGProgressHUD.h"
#import "Question.h"

@interface TestViewController ()

{
    NSInteger answer;
}
@property (weak, nonatomic) IBOutlet UIButton *optionAButton;
@property (weak, nonatomic) IBOutlet UIButton *optionBButton;
@property (weak, nonatomic) IBOutlet UIButton *optionCButton;
@property (weak, nonatomic) IBOutlet UIButton *optionDButton;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) NSMutableArray *questions;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCurrentQuestion;

@property (nonatomic) int currentQuestion;
@property (nonatomic, strong) NSString *correctAnswer;
@property (nonatomic) int percentage;
@end


@implementation TestViewController

- (void)viewDidLoad {
      [super viewDidLoad];

    self.currentQuestion = 0;
    [self EnableAll];
    
    [self downloadData]; //:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) downloadData{ // :(BOOL)localDataStore{
    
    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleExtraLight];
    HUD.textLabel.text = @"Келiн наливает чай";
    [HUD showInView:self.view];
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    
  // if(localDataStore){
  //[query fromLocalDatastore];
  //}
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
          [PFObject pinAll:objects];
            for (Question *question in objects) {
                PFQuery *optionQuery = [PFQuery queryWithClassName:@"Option"];
                [optionQuery whereKey:@"questionId" equalTo:question];
                
                NSArray *list = [optionQuery findObjects];
                question.options = list;
            }
            
            self.questions = [objects mutableCopy];
            [self randomize];
            
            [HUD dismissAnimated:YES];
            [self showCurrentQuestion];
        }
    }];
}

-(void) showCurrentQuestion {
    Question *question = self.questions[self.currentQuestion];
    self.questionLabel.text = question.text;
    self.questionLabel.textColor = [UIColor colorWithRed:0.847 green:0.118 blue:0.208 alpha:1] /*#d81e35*/;
    self.correctAnswer = question.answer;
    //dataStore
   
        NSLog(@"objectid: %@", question.objectId);
    NSArray* options = question.options ;
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithArray:options];
   for (int i = 0; i < [question.options count]; i++) {
        int random1=arc4random()%[question.options count];
    [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:random1 ];
   }
    options = [NSArray arrayWithArray:mutableArray];
   
    
    
            [self.optionAButton setTitle:options [0][@"options"] forState:UIControlStateNormal];
            [self.optionBButton setTitle:options [1][@"options"] forState:UIControlStateNormal];
            [self.optionCButton setTitle:options [2][@"options"] forState:UIControlStateNormal];
            [self.optionDButton setTitle:options [3][@"options"] forState:UIControlStateNormal];
    
            [self resetButtons];
}

-(void) resetButtons
{   self.optionAButton.clipsToBounds = YES;
    self.optionAButton.layer.cornerRadius = 7;
    self.optionBButton.clipsToBounds = YES;
    self.optionBButton.layer.cornerRadius = 7;
    self.optionCButton.clipsToBounds = YES;
    self.optionCButton.layer.cornerRadius = 7;
    self.optionDButton.clipsToBounds = YES;
    self.optionDButton.layer.cornerRadius = 7;

    [self.optionAButton setBackgroundColor:[UIColor colorWithRed:0.118 green:0.773 blue:0.847 alpha:1] /*#1ec5d8*/];
    [self.optionBButton setBackgroundColor: [UIColor colorWithRed:0.118 green:0.773 blue:0.847 alpha:1] /*#1ec5d8*/];
    [self.optionCButton setBackgroundColor: [UIColor colorWithRed:0.118 green:0.773 blue:0.847 alpha:1] /*#1ec5d8*/];
    [self.optionDButton setBackgroundColor: [UIColor colorWithRed:0.118 green:0.773 blue:0.847 alpha:1] /*#1ec5d8*/];
}

-(void)checkAnswer : (UIButton *)button{

    if ([[button titleLabel].text isEqualToString:self.correctAnswer])
    {
       answer = answer + 1;
       NSLog(@"correct! %ld", (long)answer);
    }
    else {
            NSLog(@"not correct ");
        }
    int percentage = (int)(100 * answer)/13;
    self.percentage = percentage;
    NSLog(@"%i", percentage);
    
}

- (void) highlightCorrect {
    
    if ([[_optionAButton titleLabel].text isEqualToString:self.correctAnswer])
    {
        [_optionAButton setBackgroundColor:[UIColor greenColor]];
    }
    if ([[_optionBButton titleLabel].text isEqualToString:self.correctAnswer])
    {
        [_optionBButton setBackgroundColor:[UIColor greenColor]];
    }
    if ([[_optionCButton titleLabel].text isEqualToString:self.correctAnswer])
    {
         [_optionCButton setBackgroundColor:[UIColor greenColor]];
    }
    if ([[_optionDButton titleLabel].text isEqualToString:self.correctAnswer])
    {
        [_optionDButton setBackgroundColor:[UIColor greenColor]];

    }
    
    
}


-(void) displayNextQuestion {
    [self EnableAll];
    self.currentQuestion++;
        if (self.currentQuestion > 12) {
        [self getResultsSegue];
    }else{
        self.numberOfCurrentQuestion.text = [NSString stringWithFormat:@"%@/13", @(self.currentQuestion)];
        [self showCurrentQuestion];
       
    }
    
}

-(void) randomize{
    for (int x = 0; x<[self.questions count]; x++) {
        int randomInt=arc4random()%[self.questions count];
        [self.questions exchangeObjectAtIndex:x withObjectAtIndex:randomInt ];
  }
}

-(void) DisableAll
{
    [self.optionAButton setEnabled: NO];
    [self.optionBButton setEnabled: NO];
    [self.optionCButton setEnabled: NO];
    [self.optionDButton setEnabled: NO];
  
}


-(void) EnableAll
{
    [self.optionAButton setEnabled: YES];
    [self.optionBButton setEnabled: YES];
    [self.optionCButton setEnabled: YES];
    [self.optionDButton setEnabled: YES];
    
}



- (IBAction)optionAButtonPressed:(UIButton *)sender {
    [self resetButtons];
   
    [self.optionAButton setBackgroundColor: [UIColor colorWithRed:0.753 green:0.753 blue:0.753 alpha:1] /*#c0c0c0*/];
    [self highlightCorrect];
    [self checkAnswer:self.optionAButton];
    [self performSelector:@selector(displayNextQuestion) withObject:nil afterDelay:0.3];
}

- (IBAction)optionBButtonPressed:(UIButton *)sender {
    [self resetButtons];
    [self.optionBButton setBackgroundColor: [UIColor colorWithRed:0.753 green:0.753 blue:0.753 alpha:1] /*#c0c0c0*/];
    [self DisableAll];
    [self highlightCorrect];
    [self checkAnswer:self.optionBButton];
    [self performSelector:@selector(displayNextQuestion) withObject:nil afterDelay:0.3];
}

- (IBAction)optionCButtonPressed:(UIButton *)sender {
    [self resetButtons];
   
    [self.optionCButton setBackgroundColor: [UIColor colorWithRed:0.753 green:0.753 blue:0.753 alpha:1] /*#c0c0c0*/];
    [self DisableAll];
    [self highlightCorrect];
    [self checkAnswer:self.optionCButton];
    [self performSelector:@selector(displayNextQuestion) withObject:nil afterDelay:0.3];
}

- (IBAction)optionDButtonPressed:(UIButton *)sender {
    [self resetButtons];
    [self.optionDButton setBackgroundColor: [UIColor colorWithRed:0.753 green:0.753 blue:0.753 alpha:1] /*#c0c0c0*/];
    [self DisableAll];
    [self checkAnswer:self.optionDButton];
    [self highlightCorrect];
    [self performSelector:@selector(displayNextQuestion) withObject:nil afterDelay:0.3];
}

 -(void) getResultsSegue {
[self performSegueWithIdentifier:@"getResultsSegue" sender:nil];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"getResultsSegue"]){
        ResultsViewController *controller = segue.destinationViewController;
        controller.percentage = self.percentage;
    }
}

                

@end
