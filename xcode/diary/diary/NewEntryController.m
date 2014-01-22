//
//  FirstViewController.m
//  diary
//
//  Created by Müller on 28.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import "NewEntryController.h"

@interface NewEntryController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *rootview;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UITextField *titleInput;
@property (strong, nonatomic) IBOutlet UITextView *textInput;

@end

@implementation NewEntryController

- (void)viewDidLoad
{
    
    float fH = self.view.frame.size.height;
    float fW = self.view.frame.size.width;
    float ofH = 800;
    
    [super viewDidLoad];
    [self.view endEditing:YES];
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fW, fH)];
    self.scroll.pagingEnabled = false;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.scroll.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame)+20, 0);
    
    self.rootview = [[UIView alloc] initWithFrame:CGRectMake(0,0,fW, ofH)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scroll addGestureRecognizer:singleTap];
    
   // self.subView.backgroundColor = [[UIColor alloc] initWithRed:1. green:0.5 blue:0.5 alpha:1];
    
    [self.titleInput resignFirstResponder];
    
    [self.scroll addSubview:self.subView];
    self.scroll.contentSize = CGSizeMake(fW, ofH);
    [self.view addSubview:self.scroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.titleInput resignFirstResponder];
    [self.textInput resignFirstResponder];
    
}
@end
