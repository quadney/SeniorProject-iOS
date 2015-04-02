//
//  NetworkConnection.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 3/29/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LibwhereyClient.h"
#import "Region.h"
#import "University.h"
#import <CoreLocation/CoreLocation.h>

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

- (void)retrieveDataFromURL:(NSString *)urlString withCompletionBlock:(void (^)(void))completionBlock {
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (self.dataTask) {
        // dataTask is already alive, need to stop it
        [self.dataTask cancel];
    }
    
    self.dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (error.code != -999) {
                NSLog(@"%@", error);
            }
        }
        else {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            // want this to go to the appropriate JSON parser, which can turn this data into the correct classes which correlate to this project
        }
    }];
    
    if (self.dataTask) {
        [self.dataTask resume];
    }
}

#pragma mark - LibwhereyClient API implementation
- (void)getUniversitiesWithCompletion:(UniversitiesRequestCompletionBlock)completionBlock {
    NSURL *url = [NSURL URLWithString:[self getUniversities]];
    
    if (self.dataTask) {
        // dataTask is already alive, need to stop it
        [self.dataTask cancel];
    }
    
    self.dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (error.code != -999) {
                NSLog(@"%@", error);
            }
        }
        else {
            NSArray *results = [self universityWithJSONData:data];
            
            if (completionBlock) {
                completionBlock(YES, nil, results);
            }
            
            else {
                if (completionBlock) {
                    completionBlock(NO, nil, nil);
                }
            }
        }
    }];
    
    if (self.dataTask) {
        [self.dataTask resume];
    }
}

- (void)getRegionsFromUniversityWithId:(int)universityId completion:(RegionsRequestCompletionBlock)completionBlock {
    
}

- (void)getRegionWithId:(int)regionId completion:(RegionsRequestCompletionBlock)completionBlock {
    
}

- (void)userEntersRegionWithId:(int)regionId completion:(UpdateUserLocationCompletionBlock)completionBlock {
    
}

- (void)userExitsRegionWithId:(int)regionId completion:(UpdateUserLocationCompletionBlock)completionBlock {
    
}

#pragma mark - URL Creation methods for the api url string

// TODO move to more appropriate class when I figure out how

- (NSString *)getUniversities {
    return @"http://libwherey.herokuapp.com/api/v1/universities";
}

- (NSString *)getRegionwithId:(int)regionId {
    return [NSString stringWithFormat:@"http://libwherey.herokuapp.com/api/v1/regions/%i", regionId];
}

- (NSString *)getRegionsWithUniversityId:(int)univId {
    return [NSString stringWithFormat:@"%@/%i/regions", [self getUniversities], univId];
}

- (NSString *)enterRegionURLWithRegionId:(int)regionId {
    return [NSString stringWithFormat:@"%@/user_entered_region", [self getRegionwithId:regionId]];
}

- (NSString *)exitRegionURLWithRegionId:(int)regionId {
    return [NSString stringWithFormat:@"%@/user_exited_region", [self getRegionwithId:regionId]];
}

#pragma mark - Parsers - these also need to move when I know how to move them, sigh

- (NSArray *)regionWithJSONData:(id)jsonData {
    // TODO
    // the result of this should look like this:
    //
    NSMutableArray *regions = [[NSMutableArray alloc] init];
//    for (NSDictionary *obj in jsonData) {
////        [regions addObject:[[Region alloc] initWithIdentifier:[obj objectForKey:@"identifier"]
////                                                       center:[[CLLocation alloc] initWithLatitude:[obj objectForKey:@"latitiude"]
////                                                                                         longitude:[obj objectForKey:@"longitude"]]
////                                                       radius:50.0
////                                                     idNumber:(int)[obj objectForKey:@"id"]]];
//    }
    
    return [NSArray arrayWithArray:regions];
}

- (NSArray *)universityWithJSONData:(id)jsonData {
    // the result of this should look like this:
    // [{"id":1,"name":"University of Florida", "created_at":"2015-03-16T22:06:43.359Z", "updated_at":"2015-04-02T17:35:44.349Z", "latitude":29.64363, "longitude":-82.35493}]
    NSMutableArray *universities = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in jsonData) {
        [universities addObject:[[University alloc] initWithName:[obj objectForKey:@"name"]
                                                        latitude:[[obj objectForKey:@"latitude"] floatValue]
                                                       longitude:[[obj objectForKey:@"longitude"] floatValue]
                                                         regions:nil
                                                        idNumber:[[obj objectForKey:@"id"] integerValue]]];
    }
    return [NSArray arrayWithArray:universities];
}

@end
