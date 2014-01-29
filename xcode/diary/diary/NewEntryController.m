//
//  FirstViewController.m
//  diary
//
//  Created by Müller on 28.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import "NewEntryController.h"
#import "APLViewController.h"
#import "Entry.h"
#import "AppDelegate.h"
#import "CoreDataWrapper.h"
#import "Remote.h"
#import "ListViewController.h"

@interface NewEntryController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *rootview;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UITextField *titleInput;
@property (strong, nonatomic) IBOutlet UITextView *textInput;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) IBOutlet UIButton *superHappy;
@property (strong, nonatomic) IBOutlet UIButton *happy;
@property (strong, nonatomic) IBOutlet UIButton *sad;
@property (strong, nonatomic) IBOutlet UIButton *superSad;
@property (strong, nonatomic) IBOutlet UIImageView *theImage;
@property (strong, nonatomic) IBOutlet UIButton *selectTheImage;

@property (strong, nonatomic) APLViewController *imagePicker;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation NewEntryController
- (NSManagedObjectContext *)managedObjectContext;
{
    if (!_managedObjectContext) {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        _managedObjectContext = appDelegate.managedObjectContext;
        
    }
    return _managedObjectContext;
}

- (IBAction)pickTheImage:(id)sender
{
    
    NSLog(@"BUTTON:TOUCHED");
    
    
    // Declare the view controller
    APLViewController *aplVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePickerControllerID"];    
    
    [self presentModalViewController:aplVC animated:YES];
    
    //[self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)viewDidLoad
{
    float fH = self.view.frame.size.height;
    float fW = self.view.frame.size.width;
    float ofH = 900;
    
    selectedMood = -1;
    
    [super viewDidLoad];
    [self.view endEditing:YES];
    
    //self.imagePicker = [[APLViewController alloc] init];
    
    if(self.uiImage){
        self.theImage.image = self.uiImage;
    }
        
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fW, fH)];
    self.scroll.pagingEnabled = false;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.scroll.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame)+20, 0);
    
    self.rootview = [[UIView alloc] initWithFrame:CGRectMake(0,0,fW, ofH)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scroll addGestureRecognizer:singleTap];
    
    //self.subView.backgroundColor = [[UIColor alloc] initWithRed:1. green:0.5 blue:0.5 alpha:1];
    
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
- (IBAction)changeMood:(id)sender {
    NSString *senderTitle = [(UIButton *)sender currentTitle];
    NSString *buttonSuperHappyTitle = self.superHappy.titleLabel.text;
    NSString *buttonHappyTitle = self.happy.titleLabel.text;
    NSString *buttonSuperSadTitle = self.superSad.titleLabel.text;
    NSString *buttonSadTitle = self.sad.titleLabel.text;
    
    if([senderTitle isEqualToString:buttonSuperHappyTitle])
    {
        [self.superHappy setAlpha:1.0];
        [self.happy setAlpha:0.5];
        [self.sad setAlpha:0.5];
        [self.superSad setAlpha:0.5];
        
        selectedMood = 1;
    }
    if([senderTitle isEqualToString:buttonHappyTitle])
    {
        [self.superHappy setAlpha:0.5];
        [self.happy setAlpha:1.0];
        [self.sad setAlpha:0.5];
        [self.superSad setAlpha:0.5];
        
        selectedMood = 2;
    }
    if([senderTitle isEqualToString:buttonSadTitle])
    {
        [self.superHappy setAlpha:0.5];
        [self.happy setAlpha:0.5];
        [self.sad setAlpha:1.5];
        [self.superSad setAlpha:0.5];
        
        selectedMood = 3;
    }
    if([senderTitle isEqualToString:buttonSuperSadTitle])
    {
        [self.superHappy setAlpha:0.5];
        [self.happy setAlpha:0.5];
        [self.sad setAlpha:0.5];
        [self.superSad setAlpha:1.0];
        
        selectedMood = 4;
    }
    
}



- (IBAction)save:(UIButton *)sender {
    
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                 inManagedObjectContext:self.managedObjectContext];
    entry.title = self.titleInput.text;
    entry.date = self.datePicker.date;
    
    //entry.id = [key objectForKey:@"id"]; //TODO ID erzeugen
    
    entry.mood = [NSNumber numberWithInteger: selectedMood];
    entry.text = self.textInput.text;
    
    //entry.locationsLati = [key objectForKey:@"location_lati"];
    //entry.locationsLong = [key objectForKey:@"location_long"];
    
    //self.theImage
    
    //entry.image = @"";
    
    NSLog(@"%@",entry);
    
    CoreDataWrapper *cdw = [[CoreDataWrapper alloc]init];
    
    NSData *json = [cdw getJSONFor:entry];
    //NSLog(@"%@",json);
    
    Remote *remote = [[Remote alloc] init];
    remote.delegate = self;
    
    [remote postEntry:1 :json];
    
}

//PROTOCOL METHODS
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //request is complete! parse now
    
    NSLog(@"NewEntryController: %@", _responseData);
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Glückwunsch"
                                                    message:@"Speichern erfolgreich"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // Declare the view controller
    //ListViewController *aplVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePickerControllerID"];
    
    //[self presentModalViewController:aplVC animated:YES];
    
    self.tabBarController.selectedIndex = 0;
    
    
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //ERROR
    //check the error var
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}

@end
