//
//  NetworkConnection.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 3/29/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibwhereyClient : NSObject

// talks to the network/API and parses JSON

@property (nonatomic, strong) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;

+ (id)sharedClient;

//- (NSMutableArray *)retrieveUniversities;
//- (NSMutableArray *)retrieveRegionsForUniversityWithId:(int)universityId;

@end
