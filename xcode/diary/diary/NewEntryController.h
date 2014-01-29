//
//  FirstViewController.h
//  diary
//
//  Created by Müller on 28.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface NewEntryController : UIViewController<NSURLConnectionDelegate>
{
     int   selectedMood;
    Reachability *reachability;
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture;
@property (weak, nonatomic) UIImage *uiImage;


@end
