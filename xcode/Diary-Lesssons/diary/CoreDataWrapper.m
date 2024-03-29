//
//  CoreDataWrapper.m
//  diary
//
//  Created by Müller on 22.01.14.
//  Copyright (c) 2014 FMA. All rights reserved.
//

#import "CoreDataWrapper.h"
#import "Remote.h"
#import "Entry.h"
#import "AppDelegate.h"


@interface CoreDataWrapper ()

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation CoreDataWrapper


-(id)init{

    return self;
}


- (NSManagedObjectContext *)managedObjectContext;
{
    if (!_managedObjectContext) {
        AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        _managedObjectContext = appDelegate.managedObjectContext;
        
    }
    return _managedObjectContext;
}


-(NSMutableArray*)getCoreDataObjsFor:(NSArray *)dictionary{
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", dictionary);
    for (NSDictionary *key in dictionary) {
        
        Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry"
                                                     inManagedObjectContext:self.managedObjectContext];
        entry.title = [key objectForKey:@"title"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *str = [key objectForKey:@"date"];
        NSLog(@"%@",str);
        NSLog(@"%@",[df dateFromString: str]);
        entry.date = [df dateFromString: str];
        
        entry.id = [key objectForKey:@"id"];
        entry.mood = [NSNumber numberWithInteger: [[key objectForKey:@"mood"] integerValue]];
        entry.text = [key objectForKey:@"text"];
        //entry.locationsLati = [key objectForKey:@"location_lati"]; //[NSNumber numberWithInteger: [[key objectForKey:@"mood"] integerValue]];
        //entry.locationsLong = [key objectForKey:@"location_long"];
        
        NSString* iP = [key objectForKey:@"image_path"];
        if(iP)
        {
            entry.image_path = iP;
            NSLog(@"IP: %@", iP);
        }
        [entries addObject:entry];
        
    }
    return entries;
}

-(NSData*)getJSONFor:(Entry *)entry{
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    
    for (NSAttributeDescription *attribute in [[entry entity] properties]) {
        NSString *attributeName = attribute.name;
        
        id attributeValue;
        
        if([attributeName  isEqual: @"date"]){
            
            NSDateFormatter *formatter;
            formatter = [[NSDateFormatter alloc] init];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:s"];
            attributeValue = [formatter stringFromDate:[entry valueForKey:attributeName]];
        }else{
            attributeValue = [entry valueForKey:attributeName];
        }
        
        if (attributeValue) {
            [jsonDict setObject:attributeValue forKey:attributeName];
        }
    }
    
    // TODO: Obj(NSMutableDictionary *jsonDict) to JSON (NSData* jsonData)
    
    //NSData* jsonData = ....
    NSData* jsonData = nil; // TODO
    
    //NSString* jsonString = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];
    
    //NSLog(@"%@",jsonData);
    //NSLog(@"%@",jsonString);
    
    return jsonData;
}



@end
