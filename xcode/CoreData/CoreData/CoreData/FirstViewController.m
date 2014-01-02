//
//  FirstViewController.m
//  CoreData
//
//  Created by Müller on 15.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import "FirstViewController.h"

#import "AppDelegate.h"
#import "Entry.h"

@interface FirstViewController ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *eTitle;
@property (weak, nonatomic) IBOutlet UITextView *textf;
@property (weak, nonatomic) IBOutlet UIDatePicker *data;

@end

@implementation FirstViewController


- (IBAction)save:(id)sender {
    
    //  1
    Entry *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                      inManagedObjectContext:self.managedObjectContext];
    //  2
    newEntry.title = self.eTitle.text;
    newEntry.text = self.textf.text;
    newEntry.date = self.data.date;
    
    //  3
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    //  4
    
    //  5
    [self.view endEditing:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //1
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;   
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
