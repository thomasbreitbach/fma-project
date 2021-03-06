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
#define PICTURES    @"photos"
#define BOOKS       @"books"
#define ENTRIES     @"entries"

-(id)init{
    return self;
}

/*
 *  GET REQUESTS
 */
-(NSArray*) get:(NSURL *)url{
   
    // TODO: GET Data from URL
    //NSData *theData = ....
    NSError *theError = nil;
    
    // TODO: JSONSerialization
    //NSArray *theResult = ....
    
    if(theError == nil){
        
        // return theResult; // TODO:
        return nil; // TODO
        
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

-(UIImage *) getImage:(NSString *) fileName{
    UIImage *result;
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", BASE_URL, PICTURES, fileName];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    result = [UIImage imageWithData:data];
    
    NSLog(@"BILD %@", result);
    return result;
}

@end
