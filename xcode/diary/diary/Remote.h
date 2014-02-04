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

//GET
-(NSURLConnection *) getBook:(NSInteger *) bookId;
-(NSURLConnection *) getEntries:(NSInteger *)bookId;
-(NSURLConnection *) getEntry:(NSInteger *)bookId :(NSInteger *) entryId;

//POST
-(NSURLConnection *) postBook:(NSData *) requestBodyData;
-(NSURLConnection *) postEntry:(NSInteger) book_id :(NSData *) requestBodyData;
-(NSURLConnection *) postImage:(UIImage *) image withFilename:(NSString *) filename;

//PUT
-(void) putBook:(NSInteger *) book_id :(NSData *) requestBodyData;
-(void) putEntry:(NSInteger *) book_id :(NSInteger *) entry_id :(NSData *) requestBodyData;

//DELETE
-(void) deleteBook:(NSInteger *) book_id;
-(void) deleteEntry:(NSInteger *) book_id :(NSInteger *) entry_id;

@property (weak, nonatomic) UIViewController *delegate;

@end
