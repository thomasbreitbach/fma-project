//
//  Birthday.m
//  SignificantDates
//
//  Created by Chris Wagner on 6/11/12.
//

#import "Birthday.h"
#import "NSManagedObject+JSON.h"
#import "SDSyncEngine.h"

@implementation Birthday

@dynamic objectId;
@dynamic name;
@dynamic date;
@dynamic giftIdeas;
@dynamic facebook;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic image;
@dynamic syncStatus;

- (NSDictionary *)JSONToCreateObjectOnServer {
    NSString *jsonString = nil;
    NSDictionary *date = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Date", @"__type",
                          [[SDSyncEngine sharedEngine] dateStringForAPIUsingDate:self.date], @"iso" , nil];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.name, @"name",
                                    self.giftIdeas, @"giftIdeas",
                                    self.facebook, @"facebook",
                                    date, @"date", nil];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization 
                        dataWithJSONObject:jsonDictionary 
                        options:NSJSONWritingPrettyPrinted 
                        error:&error];
    if (!jsonData) {
        NSLog(@"Error creaing jsonData: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonDictionary;
}

@end
