//
//  ViewController.h
//  XMLParser
//
//  Created by Andre Wissner on 03/02/14.
//  Copyright (c) 2014 TCA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
    ViewController  *viewController;
    
    NSXMLParser         *rssParser;
    NSMutableArray      *articles;
    NSMutableDictionary *item;
    NSString            *currentElement;
    NSMutableString     *elementValue;
    BOOL                errorParsing;
}

@property (nonatomic, retain) IBOutlet ViewController *viewController;

-(void)parseXMLFileAtURL:(NSString*) url;

@end
