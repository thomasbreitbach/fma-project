//
//  DetailsViewController.m
//  diary
//
//  Created by Müller on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()


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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"%@",self.mood);
    NSLog(@"%@",self.date);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
