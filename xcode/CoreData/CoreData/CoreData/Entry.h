//
//  Entry.h
//  CoreData
//
//  Created by Müller on 15.12.13.
//  Copyright (c) 2013 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * locationsLati;
@property (nonatomic, retain) NSNumber * locationsLong;
@property (nonatomic, retain) NSNumber * mood;
@property (nonatomic, retain) NSNumber * picID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Book *bookID;

@end
