//
//  NetworkConnection.m
//  LibraryTracker
//
//  Created by Sydney Richardson on 3/29/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LibwhereyClient.h"
#import "ModelFactory.h"
#import <CoreLocation/CoreLocation.h>

@implementation LibwhereyClient

+ (id)sharedClient {
    static LibwhereyClient *libwhereyClientInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        libwhereyClientInstance = [[self alloc] initPrivate];
    });
    return libwhereyClientInstance;
}

- (id)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use: [LibwhereyClient sharedClient]"
                                 userInfo:nil];
    return nil;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        // do special things here if I need to...
    }
    return self;
}

- (NSURLSession *)session {
    if (!_session) {
        // Initialize Session Configuration
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        // Configure Session Configuration
        //[sessionConfiguration setHTTPAdditionalHeaders:@{ @"Accept" : @"application/json" }];
        
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
           // NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
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
                NSLog(@"THERE WAS AN ERROR: %@", error);
            }
        }
        else {
            NSJSONSerialization *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *results = [self universityWithJSONData:jsonData];
            
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
    // THIS IS A VIOLATION OF DRY BUT I DON'T KNOW (or have the time) to make it better #itsokaythoughtcauseIhavetherestofmylifetogetbetter, #right ?
    NSURL *url = [NSURL URLWithString:[self getRegionsWithUniversityId:universityId]];
    
    if (self.dataTask) {
        // dataTask is already alive, need to stop it
        [self.dataTask cancel];
    }
    
    self.dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            if (error.code != -999) {
                NSLog(@"THERE WAS AN ERROR: %@", error);
            }
        }
        else {
            NSJSONSerialization *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *results = [self regionsWithJSONData:jsonData];
            
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

- (NSString *)zoneUrlPrefix {
    return @"http://libwherey.herokuapp.com/api/v1/zones";
}

- (NSString *)enterZoneURLWithZoneId:(int)zoneId {
    return [NSString stringWithFormat:@"%@/%i/user_entered_zone", [self zoneUrlPrefix], zoneId];
}

- (NSString *)exitZoneURLWithZoneId:(int)zoneId {
    return [NSString stringWithFormat:@"%@/%i/user_exited_zone", [self zoneUrlPrefix], zoneId];
}

#pragma mark - Parsers - these also need to move when I know how to move them, sigh

- (NSArray *)regionsWithJSONData:(NSJSONSerialization *)jsonData {
    // the result of this should look like this:
    /* [{"id":3,
        "identifier":"Architecture and Fine Arts Library", "latitude":29.648167, "longitude":-82.340596, "current_population":0, "total_capacity":0, "created_at":"2015-03-29T21:56:16.734Z", "updated_at":"2015-03-29T21:56:16.734Z", "university_id":1}...] */
    NSMutableArray *regions = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in jsonData) {
        
        NSMutableArray *zones = [[NSMutableArray alloc] init];
        for (NSDictionary *zoneObj in [obj objectForKey:@"zones"]) {
            
            NSMutableArray *bssids = [[NSMutableArray alloc] init];
            for (NSDictionary *wifiData in [zoneObj objectForKey:@"bssids"]) {
                [bssids addObject:[wifiData objectForKey:@"identifier"]];
            }
            [zones addObject: [[ModelFactory modelStore] createZoneWithIdentifier:[zoneObj objectForKey:@"identifier"]
                                                                         idNumber:(int)[[zoneObj objectForKey:@"id"] longValue]
                                                                        bssidData:bssids
                                                                currentPopulation:(int)[[zoneObj objectForKey:@"current_population"] longValue]
                                                                      maxCapacity:(int)[[zoneObj objectForKey:@"max_capacity"] longValue]
                                                                         altitude:[[zoneObj objectForKey:@"gps_altitude"] floatValue]]];
        }
        [regions addObject:[[ModelFactory modelStore] createRegionWithIdentifier:[obj objectForKey:@"identifier"]
                                                                        latitude:[[obj objectForKey:@"latitude"] floatValue]
                                                                       longitude:[[obj objectForKey:@"longitude"] floatValue]
                                                                          radius:50.0
                                                                        idNumber:(int)[[obj objectForKey:@"id"] longValue]
                                                                           zones:zones]];
    }
    
    return [NSArray arrayWithArray:regions];
}

- (NSArray *)universityWithJSONData:(NSJSONSerialization *)jsonData {
    // the result of this should look like this:
    // [{"id":1,"name":"University of Florida", "created_at":"2015-03-16T22:06:43.359Z", "updated_at":"2015-04-02T17:35:44.349Z", "latitude":29.64363, "longitude":-82.35493}]
    
    NSMutableArray *universities = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in jsonData) {
        [universities addObject:[[ModelFactory modelStore] createUniversityWithName:[obj objectForKey:@"name"]
                                                                            latitude:[[obj objectForKey:@"latitude"] floatValue]
                                                                           longitude:[[obj objectForKey:@"longitude"] floatValue]
                                                                             regions:nil
                                                                            idNumber:(int)[[obj objectForKey:@"id"] longValue]]];
    }
    return [NSArray arrayWithArray:universities];
}

@end
