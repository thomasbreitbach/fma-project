//
//  ImagePickup.m
//  SimpleScroll
//
//  Created by Andre Wissner on 15/01/14.
//  Copyright (c) 2014 Andre Wißner. All rights reserved.
//

#import "ImagePickup.h"

@interface ImagePickup ()

@end

@implementation ImagePickup

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
    [super viewDidLoad];

    self.imgPicker = [[UIImagePickerController alloc]init];
    self.imgPicker.editing=true;
    self.imgPicker.delegate = self;
}

-(IBAction)grabImage{
    [self presentViewController:self.imgPicker animated:true completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
	[theImage setImage:img];
	[[picker parentViewController] dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
