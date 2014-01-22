//
//  Remote.h
//  diary
//
//  Created by Medien on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Remote : NSObject

-(id)init;
-(NSDictionary *)getBook:(NSString *)bookId;
-(NSDictionary *)getEntries:(NSString *)bookId;

@end
