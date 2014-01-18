//
//  DetailsViewController.h
//  diary
//
//  Created by Müller on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) NSString *mood;
@property (weak, nonatomic) NSString *date;
@property (weak, nonatomic) UIImage *image;
@property (weak, nonatomic) NSString *text;


@end
