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

#define TEST_URL @"http://projects.drewiss.de/fma/rest/books/1/entries"

@interface ListViewController ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,strong)NSMutableArray *entries;
@property (nonatomic, copy) NSArray *items;
@property (weak, nonatomic) IBOutlet UIRefreshControl *refreshOutlet;


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
    
    [self.tableView setDelegate:self];
    self.getItems;
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
   
    
    _entries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<10; i++) {
        Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                     inManagedObjectContext:self.managedObjectContext];
        entry.title = [NSString stringWithFormat:@"Title %d", i];
        entry.date = [NSDate date];
        entry.id = [[NSUUID UUID] UUIDString];
        entry.image = @"Tagebuch.jpg";
        
        [_entries addObject:entry];
    }
    NSLog(@"%d", [_entries count]);
    NSLog([_entries description]);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
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
        
        UIImageView *entryImage = (UIImageView *)[cell viewWithTag:100];
        entryImage.image = [UIImage imageNamed:entry.image];
        
        UILabel *entryTitle = (UILabel *)[cell viewWithTag:101];
        entryTitle.text = entry.title;
        
        UILabel *entryDate = (UILabel *)[cell viewWithTag:102];
        
        
        NSDateFormatter *formatter;
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
        
        entryDate.text = [formatter stringFromDate:entry.date];

        
    } else {
        // eintrag für neuen tagebuch eintrag
        
        UIImageView *entryImage = (UIImageView *)[cell viewWithTag:100];
        entryImage.image = [UIImage imageNamed:@"Tagebuch.jpg"]; // TODO:
        
        UILabel *entryTitle = (UILabel *)[cell viewWithTag:101];
        entryTitle.text = @"Neuen Eintrag erstellen";
        
        UILabel *entryDate = (UILabel *)[cell viewWithTag:102];
        entryDate.text = @"";
        
    }
    
       return cell;
}

// This method is run when the user taps the row in the tableview
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tapped row!"
                                                    message:[NSString stringWithFormat:@"You tapped: %@", [_entries objectAtIndex:indexPath.row]]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    //[alert show];
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
    
    detailsVC.moodT = @"MOOD test";
    
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    detailsVC.dateT = [formatter stringFromDate:[[_entries objectAtIndex:indexPath.row]date]];
    
    detailsVC.textT = @"ein ganz langer text der vll über mehrer zeilen geht ein ganz langer text der vll über mehrer zeilen geht";
    
    [self.navigationController pushViewController:detailsVC animated:YES];  
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
- (IBAction)newEntry:(UIBarButtonItem *)sender {
    
    // TODO: NewEntry Controller aufrufen
    
}

-(void)getItems {
    /*NSURL *url = [[NSURL alloc] initWithString:TEST_URL];
    NSData *theData = [NSData dataWithContentsOfURL:url];
    NSError *theError = nil;
    NSDictionary *theResult = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&theError];
    
    if(theError == nil){
        self.items = [theResult valueForKeyPath:@""];
        NSLog(@"My dictionary is %@",theResult);
    }
     */
}
- (IBAction)refresh:(id)sender {
    
    // TODO: hier ein update der Entries
    NSLog(@"Refresh and stop again");
    [self.refreshControl endRefreshing];
}

@end
