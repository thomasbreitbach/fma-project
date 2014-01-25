//
//  Entry.h
//  diary
//
//  Created by Medien on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
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
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) Book *bookID;

@end
