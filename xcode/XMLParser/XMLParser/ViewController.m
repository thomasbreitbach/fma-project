//
//  ViewController.m
//  XMLParser
//
//  Created by Andre Wissner on 03/02/14.
//  Copyright (c) 2014 TCA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *bTitle;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self parseXMLFileAtURL:@"http://projects.drewiss.de/fma/xml/entries.xml"];

    NSLog(@"A: %@", articles);
    
    //self.bTitle.text = [articles valueForKey:@"title"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)parserDidStartDocument:(NSXMLParser*)parser{
    NSLog(@"File found and parsing started!");
}

/*
 This function instructs the engine to download a file at a particular web address (URL) and start the process for parsing it.     
 We're telling the remote server that we are a Safari running on Mac just in case the server tries to redirect the iPhone/iPad to a mobile version.
 */
-(void)parseXMLFileAtURL:(NSString *)url{
    NSString            *agentString = @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_6; en-us) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/3.2.1 Safari/525.27.1";
  	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [request setValue:agentString forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/xml" forHTTPHeaderField:@"Accept"];
   // [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    NSData *xml = [NSURLConnection sendSynchronousRequest:request returningResponse:Nil error:nil];
    
    NSLog(@"%@", xml);
    
    articles = [[NSMutableArray alloc]init];
    errorParsing = NO;
    
    rssParser = [[NSXMLParser alloc] initWithData:xml];

    rssParser.delegate = self;
    [rssParser parse];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSString *errorString = [NSString stringWithFormat:@"Error code %i", [parseError code]];
    NSLog(@"Eror parsing XML: %@", errorString);
    errorParsing=YES;
}

-(void)parser:(NSXMLParser*)parser
    didStartElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict{
    
    currentElement = [elementName copy];
    elementValue = [[NSMutableString alloc]init];
    
    if([elementName isEqualToString:@"entrie"])
    {
        item = [[NSMutableDictionary alloc]init];
    }
}

-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString *)string{
    [elementValue appendString:string];
}

-(void)parser:(NSXMLParser*) parser
    didEndElement:(NSString *)elementName
    namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"entrie"]){
        [articles addObject:[item copy]];
    }else{
        [item setObject:elementValue forKey:elementName];
    }
}

-(void) parserDidEndDocument:(NSXMLParser*)parser{
    if(errorParsing == NO)
    {
        NSLog(@"XML processing done!");
    }else{
        NSLog(@"Error occurred during XML processing");
    }
}

@end
