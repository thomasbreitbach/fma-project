//
//  NSString+URLTools.m
//  diary
//
//  Created by Medien on 29.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.

#import "NSString+URLTools.h"

@implementation NSString(URLTools)

- (NSString *)encodedStringForURLWithEncoding:(NSStringEncoding)inEncoding {
    CFStringEncoding theEncoding = CFStringConvertNSStringEncodingToEncoding(inEncoding);
    CFStringRef theResult = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                    (__bridge CFStringRef) self,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                    theEncoding);
    
    return (__bridge_transfer NSString *)theResult;
}

@end
