//
//  Remote.m
//  diary
//
//  Created by Medien on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import "RemoteSynchronous.h"

@implementation RemoteSynchronous

#define BASE_URL    @"http://projects.drewiss.de/fma/rest"
#define BOOKS       @"books"
#define ENTRIES     @"entries"

-(id)init{
    return self;
}

/*
 *  GET REQUESTS
 */
-(NSArray*) get:(NSURL *)url{
    NSData *theData = [NSData dataWithContentsOfURL:url];
    NSError *theError = nil;
    NSArray *theResult = [NSJSONSerialization JSONObjectWithData:theData options:0 error:&theError];
    
    if(theError == nil){
        return theResult;
    }else{
        NSLog(@"get-request to %@ error:%@", url, theError);
        return nil;
    }
}

-(NSArray *)getBook:(NSString *)bookId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", BASE_URL, BOOKS, bookId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    return [self get:url];
}

-(NSArray *)getEntries:(NSString *)bookId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@", BASE_URL, BOOKS, bookId, ENTRIES];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    return [self get:url];
}


-(NSArray *)getEntry:(NSString *)bookId :(NSString *) entryId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", BASE_URL, BOOKS, bookId, ENTRIES, entryId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    return [self get:url];
}

/*
 * POST REQUESTS
 */


@end
