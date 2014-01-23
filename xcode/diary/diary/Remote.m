//
//  Remote.m
//  diary
//
//  Created by Medien on 15.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import "Remote.h"

@implementation Remote

#define BASE_URL    @"http://projects.drewiss.de/fma/rest"
#define UPLOAD_URL  (BASE_URL @"/upload.php")
#define BOOKS       @"books"
#define ENTRIES     @"entries"

NSMutableData *_responseData;

-(id)init{
    return self;
}

//PROTOCOL METHODS
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _responseData = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_responseData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //request is complete! parse now
    
    /*
     * TODO PARSE DATA
     */
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //ERROR
    //check the error var
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}


/*
 *  GET REQUESTS
 */
-(void) get:(NSURL *)url{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

-(void)getBook:(NSString *)bookId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", BASE_URL, BOOKS, bookId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self get:url];
}


-(void)getEntries:(NSString *)bookId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@", BASE_URL, BOOKS, bookId, ENTRIES];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self get:url];
}


-(void)getEntry:(NSString *)bookId :(NSString *) entryId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@", BASE_URL, BOOKS, bookId, ENTRIES, entryId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self get:url];
}

/*
 * POST REQUESTS
 */
-(void) post:(NSURL *)url :(NSData *) requestBodyData{
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //convert data and set HTTPBody
    request.HTTPBody = requestBodyData;
    
    //fire asynchonous request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


/*
 * PUT REQUESTS
 */
-(void) put:(NSURL *)url :(NSData *) requestBodyData{
    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //convert data and set HTTPBody
    request.HTTPBody = requestBodyData;
    
    //fire asynchonous request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
