//
//  ListViewController.m
//  diary
//
//  Created by Müller on 28.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import "ListViewController.h"
#import "DetailsViewController.h"
#import "Entry.h"
#import "AppDelegate.h"
#import "RemoteSynchronous.h"
#import "Remote.h"
#import "CoreDataWrapper.h"

#define TEST_URL @"http://projects.drewiss.de/fma/rest/books/1/entries"

@interface ListViewController ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSMutableArray *entries;
@property (nonatomic, copy) NSArray *items;
@property (weak, nonatomic) IBOutlet UIRefreshControl *refreshOutlet;

@property (nonatomic, retain) RemoteSynchronous *remote;
@property (nonatomic, retain) Remote *remoteAsync;

@property (strong, nonatomic) NSMutableData *responseData;

@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext;
{
    if (!_managedObjectContext) {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        _managedObjectContext = appDelegate.managedObjectContext;
        
    }
    return _managedObjectContext;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.remote = [[RemoteSynchronous alloc] init];
    self.remoteAsync = [[Remote alloc] init];

    self.remoteAsync.delegate = self;

    [self.tableView setDelegate:self];

    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
 
    [self getItems];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"holzB2.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_entries count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%d",indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    if (indexPath.row < [_entries count]) {
        
        // Display entries in the table cell
        Entry *entry = [_entries objectAtIndex:indexPath.row];
        
        UILabel *entryTitle = (UILabel *)[cell viewWithTag:101];
        entryTitle.text = entry.title;
        
        UILabel *entryDate = (UILabel *)[cell viewWithTag:102];
        
        
        NSDateFormatter *formatter;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        
        entryDate.text = [formatter stringFromDate:entry.date];
        
        
        // img stuff
        
         UIImageView *entryImage = (UIImageView *)[cell viewWithTag:100];
        
        if (entry.imageData) {
            // image bereits geladen
            UIImage *currentImage = [[UIImage alloc] initWithData:entry.imageData];
            entryImage.image = [self centerCropImage:currentImage];
            NSLog(@"bild schon da");
            
        }else if (![entry.image_path isEqualToString:@""]){
            
            NSLog(@"bild wird geladen");
            
            // image muss geladen werden
            
            //placeholder setzen
            UIImage *palceholderImage = [UIImage imageNamed:@"loading.gif"];
            entryImage.image = palceholderImage;
            entry.imageData = UIImageJPEGRepresentation(palceholderImage,0.7);
            
            
            // download the image
            // creating the download queue
            dispatch_queue_t downloadQueue=dispatch_queue_create("thumbnailImage", NULL);
            
            dispatch_async(downloadQueue, ^{
                
                UIImage *downloadedImage = [self.remote getImage:entry.image_path];
                
                //Need to go back to the main thread since this is UI related
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // store the downloaded image
                    entry.imageData = UIImageJPEGRepresentation(downloadedImage,0.7);
                    
                    // update UI
                    entryImage.image = [self centerCropImage:downloadedImage];
                });
            });
            
        }
        

        
    } else {
        // eintrag für neuen tagebuch eintrag
        
        UIImageView *entryImage = (UIImageView *)[cell viewWithTag:100];
        entryImage.image = [UIImage imageNamed:@"plus.png"];
        
        UILabel *entryTitle = (UILabel *)[cell viewWithTag:101];
        entryTitle.text = @"Neuer Eintrag";
        
        UILabel *entryDate = (UILabel *)[cell viewWithTag:102];
        entryDate.text = @"Was gibt es neues?";
        
    }
    
       return cell;
}

// This method is run when the user taps the row in the tableview
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView numberOfRowsInSection:0] == indexPath.row+1){
        self.tabBarController.selectedIndex = 1;
        
    }else{
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        // Declare the view controller
        DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        
        
        // Get cell textLabel string to use in new view controller title
        NSString *cellTitleText = [[_entries objectAtIndex:indexPath.row]title];
        
        // Get object at the tapped cell index from table data source array to display in title
        //id tappedObj = [sitesArray objectAtIndex:indexPath.row];
        
        // Set title indicating what row/section was tapped
        [detailsVC setTitle:[NSString stringWithFormat:@"%@", cellTitleText]];
        
        // present it modally (not necessary, but sometimes looks better then pushing it onto the stack - depending on your App)
        [detailsVC setModalPresentationStyle:UIModalPresentationFormSheet];
        
        // Have the transition do a horizontal flip - my personal fav
        [detailsVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        
        // The method `presentModalViewController:animated:` is depreciated in iOS 6 so use `presentViewController:animated:completion:` instead.
        //[self.navigationController presentViewController:detailsVC animated:YES completion:NULL];
        
        detailsVC.moodT = [[[_entries objectAtIndex:indexPath.row]mood]stringValue];
        
        NSDateFormatter *formatter;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        detailsVC.dateT = [formatter stringFromDate:[[_entries objectAtIndex:indexPath.row]date]];
        
        detailsVC.textT = [[_entries objectAtIndex:indexPath.row]text];
        
        if([[_entries objectAtIndex:indexPath.row]imageData]){
            detailsVC.imageI = [[UIImage alloc] initWithData:[[_entries objectAtIndex:indexPath.row]imageData]];
        }
        
        detailsVC.imagePath = [[_entries objectAtIndex:indexPath.row]image_path];
        
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if([tableView numberOfRowsInSection:0] == indexPath.row+1 ){
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger id = [[[_entries objectAtIndex:indexPath.row]id] intValue];
         NSLog(@"%d",id);
        
        [self.remoteAsync deleteEntry:1 :id];
        
        
    }
}
 

-(void)getItems {

    
    if(([Reachability reachabilityWithHostname:@"www.drewiss.de"]).isReachable)
    {
        RemoteSynchronous *remote = [[RemoteSynchronous alloc] init];
        NSArray *d                = [remote getEntries:@"1"];
        CoreDataWrapper *cdw      = [[CoreDataWrapper alloc]init];
        _entries                  = [cdw getCoreDataObjsFor:d];
        
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    }else{
        
        UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Internet Error" message:@"Eine Verbindung zum Severst nicht möglich!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];

    }
    
    
}
- (IBAction)refresh:(id)sender {

    [self getItems];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
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
    NSLog(@"foo");
    
    [self getItems];
    [self.tableView reloadData];
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Fehler beim Laden"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

// Returns largest possible centered cropped image.
- (UIImage *)centerCropImage:(UIImage *)image
{
    // Use smallest side length as crop square length
    CGFloat squareLength = MIN(image.size.width, image.size.height);
    // Center the crop area
    CGRect clippedRect = CGRectMake((image.size.width - squareLength) / 2, (image.size.height - squareLength) / 2, squareLength, squareLength);
    
    // Crop logic
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], clippedRect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}


@end
