//
//  SimpleScrollViewController.m
//  SimpleScroll
//
//  Created by Andre Wissner on 15/01/14.
//  Copyright (c) 2014 Andre Wißner. All rights reserved.
//

#import "SimpleScrollViewController.h"

@interface SimpleScrollViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *subV;
@property (strong, nonatomic) IBOutlet UITextField *testInput;
@property (strong, nonatomic) IBOutlet UITextView *testAreaInput;
@property (strong, nonatomic) IBOutlet UIView *rootView;



@end

@implementation SimpleScrollViewController

- (void)viewDidLoad
{
    float fH = self.view.frame.size.height;
    float fW = self.view.frame.size.width;
    float ofH = 800;
    
    [super viewDidLoad];
    [self.view endEditing:YES];
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fW, fH)];
    self.scroll.pagingEnabled = false;
    
    self.rootView = [[UIView alloc] initWithFrame:CGRectMake(0,0,fW, ofH)];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scroll addGestureRecognizer:singleTap];
    
    [self.testInput setText:@"Hello"];
    [self.testInput resignFirstResponder];
    
    [self.scroll addSubview:self.subV];
    self.scroll.contentSize = CGSizeMake(fW, ofH);
    [self.view addSubview:self.scroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.testInput resignFirstResponder];
    [self.testAreaInput resignFirstResponder];
    
}
@end
