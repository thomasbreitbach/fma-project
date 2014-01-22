//
//  Remote.h
//  diary
//
//  Created by Medien on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Remote : NSObject<NSURLConnectionDataDelegate>

-(id)init;
-(void)getBook:(NSString *)bookId;
-(void)getEntries:(NSString *)bookId;
-(void)getEntry:(NSString *)bookId :(NSString *) entryId;

@end
