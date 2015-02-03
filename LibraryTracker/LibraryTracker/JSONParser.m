//
//  JSONParser.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 2/3/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser


- (void)parseJsonData:(NSData *)data {
    NSDictionary *jsonDictionay = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:nil];
    
}

@end
