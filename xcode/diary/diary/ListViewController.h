//
//  ListViewController.h
//  diary
//
//  Created by Müller on 28.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface ListViewController : UITableViewController{
    Reachability *internetReachableFoo;
}

@property (nonatomic, assign, getter=getServerState) BOOL serverState;
@property (nonatomic) NSString *urlToServer;

@end
