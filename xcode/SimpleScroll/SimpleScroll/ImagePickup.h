//
//  ImagePickup.h
//  SimpleScroll
//
//  Created by Andre Wissner on 15/01/14.
//  Copyright (c) 2014 Andre Wißner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickup : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    IBOutlet UIButton               *button;

	UIImagePickerController         *imgPicker;
    IBOutlet UIImageView *theImage;
}
- (IBAction)grabImage;

@property (nonatomic, retain) UIImagePickerController *imgPicker;

@end