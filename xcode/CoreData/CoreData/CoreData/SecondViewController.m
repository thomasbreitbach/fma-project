//
//  SecondViewController.m
//  CoreData
//
//  Created by Müller on 15.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import "SecondViewController.h"

#import "AppDelegate.h"
#import "Entry.h"


@interface SecondViewController ()
@property (nonatomic,strong)NSArray* fetchedRecordsArray;
@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    // Fetching Records and saving it in "fetchedRecordsArray" object
    self.fetchedRecordsArray = [appDelegate getAllEntryRecords];
      
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
