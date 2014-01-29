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
    
    [self getItems];

    [self.tableView setDelegate:self];
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
   
    /*
    _entries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<10; i++) {
        Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                     inManagedObjectContext:self.managedObjectContext];
        entry.title = [NSString stringWithFormat:@"Title %d", i];
        entry.date = [NSDate date];
        entry.id = [[NSUUID UUID] UUIDString];
        entry.image_path = @"Tagebuch.jpg";
        
        [_entries addObject:entry];
    }
     */
    
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
        
        UIImageView *entryImage = (UIImageView *)[cell viewWithTag:100];
        entryImage.image = [UIImage imageNamed:entry.image_path];
        
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
        entryImage.image = [UIImage imageNamed:@"plus.png"];
        
        UILabel *entryTitle = (UILabel *)[cell viewWithTag:101];
        entryTitle.text = @"Neuer Eintrag";
        
        UILabel *entryDate = (UILabel *)[cell viewWithTag:102];
        entryDate.text = @"";
        
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
        
        detailsVC.imageI = [UIImage imageNamed:[[_entries objectAtIndex:indexPath.row]image_path] ];
        
        [self.navigationController pushViewController:detailsVC animated:YES];
        
    }
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger id = [[[_entries objectAtIndex:indexPath.row]id] intValue];
         NSLog(@"%d",id);
        
        [self.remoteAsync deleteEntry:1 :id];
        
        [self getItems];
        [self.tableView reloadData];
        
    }
}




- (IBAction)newEntry:(UIBarButtonItem *)sender {
    
    self.tabBarController.selectedIndex = 1;
    
}

-(void)getItems {
    NSArray *d = [self.remote getEntries:@"1"];
    CoreDataWrapper *cdw = [[CoreDataWrapper alloc]init];
    _entries = [cdw getCoreDataObjsFor:d];
    
    
}
- (IBAction)refresh:(id)sender {
    
    // TODO: hier ein update der Entries
    [self getItems];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

@end
