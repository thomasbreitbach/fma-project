//
//  Book.h
//  CoreData
//
//  Created by Müller on 15.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Book : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * lastEdit;

@end
