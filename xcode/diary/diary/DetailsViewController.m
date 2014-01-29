//
//  DetailsViewController.m
//  diary
//
//  Created by Müller on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mood;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *textTitle;
@property (strong, nonatomic) IBOutlet UIImageView *moodImage;
@property (strong, nonatomic) IBOutlet UITextView *text;

@end

@implementation DetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@",self.moodT);
    NSLog(@"%@",self.dateT);
    
    NSString    *filePath;
    
    if([self.moodT isEqualToString:@"1"]){ filePath = [[NSBundle mainBundle] pathForResource:@"rhappy" ofType:@"png"];   }
    if([self.moodT isEqualToString:@"2"]){ filePath = [[NSBundle mainBundle] pathForResource:@"feelGood" ofType:@"png"]; }
    if([self.moodT isEqualToString:@"3"]){ filePath = [[NSBundle mainBundle] pathForResource:@"sad" ofType:@"png"];      }
    if([self.moodT isEqualToString:@"4"]){ filePath = [[NSBundle mainBundle] pathForResource:@"crying" ofType:@"png"];   }
    
    [self.moodImage setImage:[UIImage imageWithContentsOfFile:filePath]];
    
    self.date.text = self.dateT;
    self.textTitle.text = @"Liebes Tagebuch...";
    [self.text setText:self.textT];
    [self.text setEditable:false];
    //self.text.frame = CGRectMake(20,20,200,800);
    [self.textTitle sizeToFit];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
