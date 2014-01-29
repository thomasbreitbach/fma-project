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
@property (strong, nonatomic) IBOutlet UILabel *imageLoadingTitle;

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
    NSString *path = @"http://images2.fanpop.com/image/photos/13800000/farrari-sports-cars-13821367-1280-960.jpg";
    
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
    [self.imageLoadingTitle setText:@"Foto wird geladen!"];
    [self loadAsyncImageFromURI:self.imagePath];
    
//    [self saveFileToBundle:[self.moodImage image]];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
//    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
//
//    
//    [self.image setImage:img];
   NSLog(@"IMAGEPATH: %@", self.imagePath);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAsyncImageFromURI:(NSString*)uri
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSURL   *url = [NSURL URLWithString:uri];
        NSData  *data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
                    [self.image setImage:[[UIImage alloc] initWithData:data]];
        });
    });
}

-(void)saveFileToBundle:(UIImage*)image
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
}

@end
