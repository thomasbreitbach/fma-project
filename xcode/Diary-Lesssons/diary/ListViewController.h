//
//  ListViewController.h
//  diary
//
//  Created by Müller on 28.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface ListViewController : UITableViewController<NSURLConnectionDataDelegate>{
   
}

 +(void) setFetchItems:(BOOL) fetch;
@end
