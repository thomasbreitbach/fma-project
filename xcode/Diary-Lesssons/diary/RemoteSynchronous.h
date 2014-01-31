//
//  Remote.h
//  diary
//
//  Created by Medien on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteSynchronous : NSObject

-(id)init;
-(NSArray *)getBook:(NSString *)bookId;
-(NSArray *)getEntries:(NSString *)bookId;
-(NSArray *)getEntry:(NSString *)bookId :(NSString *) entryId;
-(UIImage *) getImage:(NSString *) fileName;

@end
