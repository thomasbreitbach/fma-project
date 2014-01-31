//
//  FirstViewController.h
//  diary
//
//  Created by Müller on 28.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface NewEntryController : UIViewController<NSURLConnectionDelegate, UITextViewDelegate>
{
     int   selectedMood;
}
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture;
@property (weak, nonatomic) UIImage *uiImage;


@property (strong, nonatomic) NSString *titleI;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) int mood;
@property (strong, nonatomic) NSString *textI;

@end
