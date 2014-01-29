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


/*
 *  GET REQUESTS
 */
-(void) get:(NSURL *)url{
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

-(void)getBook:(NSInteger *) bookId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d", BASE_URL, BOOKS, (int)bookId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self get:url];
}


-(void)getEntries:(NSInteger *)bookId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@", BASE_URL, BOOKS, (int)bookId, ENTRIES];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self get:url];
}


-(void)getEntry:(NSInteger *)bookId :(NSInteger *) entryId{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@/%d", BASE_URL, BOOKS, (int)bookId, ENTRIES, (int)entryId];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self get:url];
}

/*
 * POST REQUESTS
 */
-(void) post:(NSURL *)url :(NSData *) requestBodyData{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //convert data and set HTTPBody
    request.HTTPBody = requestBodyData;
    
    //fire asynchonous request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self.delegate];
}


-(void) postBook:(NSData *) requestBodyData{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@", BASE_URL, BOOKS];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self post:url :requestBodyData];
}


-(void) postEntry:(NSInteger) book_id :(NSData *) requestBodyData{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@", BASE_URL, BOOKS, (int)book_id, ENTRIES];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self post:url :requestBodyData];
}

-(void) postImage:(NSInteger)book_id :(NSInteger)entry_id{
    
}



/*
 * PUT REQUESTS
 */
-(void) put:(NSURL *)url :(NSData *) requestBodyData{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //convert data and set HTTPBody
    request.HTTPBody = requestBodyData;
    
    //fire asynchonous request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void) putBook:(NSInteger *) book_id :(NSData *) requestBodyData{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d", BASE_URL, BOOKS, (int)book_id];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self put:url :requestBodyData];
}

-(void) putEntry:(NSInteger *) book_id :(NSInteger *) entry_id :(NSData *) requestBodyData{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@/%d", BASE_URL, BOOKS, (int)book_id, ENTRIES, (int)entry_id];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self put:url :requestBodyData];
}


/*
 * DELETE REQUESTS
 */
-(void) delete:(NSURL *)url{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    
    //fire asynchonous request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void) deleteBook:(NSInteger *)book_id{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d", BASE_URL, BOOKS, (int)book_id];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self delete:url];
}


-(void) deleteEntry:(NSInteger *)book_id :(NSInteger *) entry_id{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%d/%@/%d", BASE_URL, BOOKS, (int)book_id, ENTRIES, (int)entry_id];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    [self delete:url];
}

@end
