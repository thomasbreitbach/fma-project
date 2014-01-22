//
//  CoreDataWrapper.h
//  diary
//
//  Created by Müller on 22.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataWrapper : NSObject
-(NSMutableArray*)getCoreDataObjsFor:(NSArray *)dictionary;
@end
