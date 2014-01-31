//
//  CoreDataWrapper.h
//  diary
//
//  Created by Müller on 22.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entry.h"

@interface CoreDataWrapper : NSObject
-(NSMutableArray*)getCoreDataObjsFor:(NSArray *)dictionary;
-(NSString*)getJSONFor:(Entry *)entry;

@end
