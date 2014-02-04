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

#define MOOD_SUPER_HAPPY    1
#define MOOD_HAPPY          2
#define MOOD_SAD            3
#define MOOD_SUPER_SAD      4
#define MOOD_UNDEFINDED     -1

#define STD_TEXTVIEW_TEXT @"Dein Text .."

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
@property (strong, nonatomic) NSString *theImageFilename;

@property (strong, nonatomic) NSURLConnection *multipartConnection;
@property (strong, nonatomic) NSURLConnection *connection;

@property (nonatomic, retain) Remote *remote;

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
    // Declare the view controller
    APLViewController *aplVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagePickerControllerID"];
    
    aplVC.title = self.titleInput.text;
    aplVC.text = self.textInput.text;
    aplVC.mood = selectedMood;
    aplVC.date = self.datePicker.date;
    
    
    [self.navigationController pushViewController:aplVC animated:YES];
}

- (void)viewDidLoad
{
    float fH = self.view.frame.size.height;
    float fW = self.view.frame.size.width;
    float ofH = 870;
    
    self.remote = [[Remote alloc] init];
    self.remote.delegate = self;

    [super viewDidLoad];
    [self.view endEditing:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    if(self.uiImage){
        self.theImage.image = self.uiImage;
    }
    if(self.titleI){
        self.titleInput.text = self.titleI;
    }
    if(self.mood != MOOD_UNDEFINDED){
        selectedMood = self.mood;
    }else{
        selectedMood = MOOD_UNDEFINDED;
    }
    if(self.date){
        self.datePicker.date = self.date;
    }
    
    [self setMoodEmoticonAsSelected:selectedMood];
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, fW, fH)];
    self.scroll.pagingEnabled = false;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.scroll.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame)+10, 0);
    
    self.rootview = [[UIView alloc] initWithFrame:CGRectMake(0,0,fW, ofH)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scroll addGestureRecognizer:singleTap];
    
    //self.subView.backgroundColor = [[UIColor alloc] initWithRed:1. green:0.5 blue:0.5 alpha:1];
    
    [self.titleInput resignFirstResponder];
    
    [self.scroll addSubview:self.subView];
    self.scroll.contentSize = CGSizeMake(fW, ofH);
    [self.view addSubview:self.scroll];
    
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"holzB2.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }

}

-(void)viewDidAppear:(BOOL)animated{
    if(self.textI){
        self.textInput.text = self.textI;
    }else{
        self.textInput.text = STD_TEXTVIEW_TEXT;
        self.textInput.textColor = [UIColor lightGrayColor];
        self.textInput.delegate = self;
    }
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
        selectedMood = MOOD_SUPER_HAPPY;
    }
    if([senderTitle isEqualToString:buttonHappyTitle])
    {
        selectedMood = MOOD_HAPPY;
    }
    if([senderTitle isEqualToString:buttonSadTitle])
    {
        selectedMood = MOOD_SAD;
    }
    if([senderTitle isEqualToString:buttonSuperSadTitle])
    {
        selectedMood = MOOD_SUPER_SAD;
    }
    [self setMoodEmoticonAsSelected:selectedMood];
}

-(void) setMoodEmoticonAsSelected:(NSInteger) mood{
    switch (mood) {
        case MOOD_SUPER_HAPPY:
            [self.superHappy setAlpha:1.0];
            [self.happy setAlpha:0.5];
            [self.sad setAlpha:0.5];
            [self.superSad setAlpha:0.5];
            break;
        case MOOD_HAPPY:
            [self.superHappy setAlpha:0.5];
            [self.happy setAlpha:1.0];
            [self.sad setAlpha:0.5];
            [self.superSad setAlpha:0.5];
            break;
        case MOOD_SAD:
            [self.superHappy setAlpha:0.5];
            [self.happy setAlpha:0.5];
            [self.sad setAlpha:1.5];
            [self.superSad setAlpha:0.5];
            break;
        case MOOD_SUPER_SAD:
            [self.superHappy setAlpha:0.5];
            [self.happy setAlpha:0.5];
            [self.sad setAlpha:0.5];
            [self.superSad setAlpha:1.0];
            break;
        default:
            [self.superHappy setAlpha:1.0];
            [self.happy setAlpha:1.0];
            [self.sad setAlpha:1.0];
            [self.superSad setAlpha:1.0];
            break;
    }
}



- (IBAction)save:(UIButton *)sender {
    
    [self saveIt];
    
}
- (IBAction)saveButton:(id)sender {
    [self saveIt];
}

-(void)saveIt
{
    if(self.titleInput.text.length == 0 || [self.textInput.text  isEqualToString:STD_TEXTVIEW_TEXT] || self.textInput.text.length == 0){
        //benutzer hat keinen Titel oder keinen Text oder beides nicht eingegeben
        UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Keine Eingabe" message:@"Bitte gib zuerst einen Titel und einen Text ein und versuche es dann erneut!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
        
    }else{
        
        // prüfe die erreichbarkeit des servers
        if(([Reachability reachabilityWithHostname:@"www.drewiss.de"]).isReachable)
        {
            //CONSTRUCT ENTRY OBJECT TO SEND
            Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                         inManagedObjectContext:self.managedObjectContext];
            entry.title = self.titleInput.text;
            entry.date = self.datePicker.date;
            entry.mood = [NSNumber numberWithInteger: selectedMood];
            entry.text = self.textInput.text;
            //entry.locationsLati = [key objectForKey:@"location_lati"];
            //entry.locationsLong = [key objectForKey:@"location_long"];
            
            if([self.uiImage CGImage] != nil){
                self.theImageFilename = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
                entry.image_path = self.theImageFilename;
            }
            
            NSLog(@"%@",entry);
            
            //object to json
            CoreDataWrapper *cdw = [[CoreDataWrapper alloc]init];
            NSData *json = [cdw getJSONFor:entry];
            
            //send json data
            self.connection = [self.remote postEntry:1 :json];
        }else{
            UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Internet Error" message:@"Eine Verbindung zum Server ist nicht möglich!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [error show];
        }
 
    }
}

-(void) showAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Glückwunsch"
                                                    message:@"Speichern erfolgreich"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//DELEGATE PROTOCOL METHODS
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
    
    if(connection == self.connection){
        NSLog(@"connection = normal");
        
        //prüfe, ob ein Bild ausgewählt wurde
        if([self.uiImage CGImage] != nil){
            //bild wurde gewählt
            NSLog(@"image != null");
            NSLog(@"filename: %@", _theImageFilename);
            
            //fire asynchronous request via Remote-Class
            self.multipartConnection = [self.remote postImage:self.theImage.image withFilename:self.theImageFilename];
        }else{
            //kein bild ausgewählt --> zeige alert
            [self showAlert];
        }
    }
    if(connection == self.multipartConnection){
        //multipart connection
        NSLog(@"connection = multipart");
        
        self.theImageFilename = nil;
        [self showAlert];
    }
 
    
    //Einträge sollen beim Wechsel zum ListViewController neu geladen werden
    [ListViewController setFetchItems:YES];

    //wechsle zum ListViewController
    self.tabBarController.selectedIndex = 0;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Fehler beim Speichern"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}


//TEXT VIEW METHODS
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    //simuliere das verhalten eines placeholders (text field)
    //placeholders in TextView wird von Apple nicht out of the
    //box unterstützt
    if(self.textInput.textColor == [UIColor lightGrayColor])
    {
        self.textInput.text = @"";
        self.textInput.textColor = [UIColor blackColor];
    }
    return YES;
}


-(void) textViewDidEndEditing:(UITextView *)textView
{
    //simuliere das verhalten eines placeholders (text field)
    //placeholders in TextView wird von Apple nicht out of the
    //box unterstützt
    if(self.textInput.text.length == 0){
        self.textInput.textColor = [UIColor lightGrayColor];
        self.textInput.text = STD_TEXTVIEW_TEXT;
        [self.textInput resignFirstResponder];
    }
}



@end
