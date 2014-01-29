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
-(void)getBook:(NSInteger *) bookId;
-(void)getEntries:(NSInteger *)bookId;
-(void)getEntry:(NSInteger *)bookId :(NSInteger *) entryId;

//POST
-(void) postBook:(NSData *) requestBodyData;
-(void) postEntry:(NSInteger) book_id :(NSData *) requestBodyData;
-(void) postImage:(NSInteger) book_id :(NSInteger) entry_id;

//PUT
-(void) putBook:(NSInteger *) book_id :(NSData *) requestBodyData;
-(void) putEntry:(NSInteger *) book_id :(NSInteger *) entry_id :(NSData *) requestBodyData;

//DELETE
-(void) deleteBook:(NSInteger *) book_id;
-(void) deleteEntry:(NSInteger *) book_id :(NSInteger *) entry_id;

@property (weak, nonatomic) UIViewController *delegate;

@end
