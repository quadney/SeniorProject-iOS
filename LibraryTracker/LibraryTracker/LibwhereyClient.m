//
//  NetworkConnection.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 3/29/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LibwhereyClient.h"

@implementation LibwhereyClient

+ (id)sharedClient {
    static LibwhereyClient *libwhereyClientInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        libwhereyClientInstance = [[self alloc] init];
    });
    return libwhereyClientInstance;
}

- (NSURLSession *)session {
    if (!_session) {
        // Initialize Session Configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Configure Session Configuration
        [sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
        
        // Initialize Session
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    
    return _session;
}


- (NSMutableArray *)retrieveUniversities {
    
}

- (NSMutableArray *)retrieveRegionsForUniversityWithId:(int)universityId {
    
}

@end
