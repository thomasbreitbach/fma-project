//
//  MIMEMultipartBody.h
//  diary
//
//  Created by Medien on 29.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MIMEMultipartBody : NSObject

@property (nonatomic, readonly) NSStringEncoding encoding;
@property (nonatomic, copy, readonly) NSString *charset;
@property (nonatomic, copy, readonly) NSString *boundary;
@property (nonatomic, copy, readonly) NSString *contentType;

- (id)init;
- (id)initWithEncoding:(NSStringEncoding)inEncoding;
- (id)initWithEncoding:(NSStringEncoding)inEncoding boundary:(NSString *)inSeparator;

- (NSData *)body;

- (NSMutableURLRequest *)mutableRequestWithURL:(NSURL *)inURL timeout:(NSTimeInterval)inTimeout;

@end
