//
//  NetworkConnection.h
//  LibraryTracker
//
//  Created by Sydney Richardson on 3/29/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UniversitiesRequestCompletionBlock)(BOOL success, NSError **error, NSArray *universities);
typedef void (^RegionsRequestCompletionBlock)(BOOL success, NSError **error, NSArray *regions);
typedef void (^UpdateUserLocationCompletionBlock)(BOOL success, NSError **error);

@interface LibwhereyClient : NSObject

// talks to the network/API and parses JSON

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

#pragma mark - LibwhereyClient singleton

+ (id)sharedClient;

#pragma mark - LibwhereyClient API

/*
 Returns all Universities in the database
 
 @param completionBlock: A completion block with a NSArray of the Universities
 */
- (void)getUniversitiesWithCompletion:(UniversitiesRequestCompletionBlock)completionBlock;

/*
 Returns all Regions associated with the University
 
 @param completionBlock: A completion block with a NSArray of the regions
 */
- (void)getRegionsFromUniversityWithId:(int)universityId completion:(RegionsRequestCompletionBlock)completionBlock;

/*
 Returns the Region with the specified id
 
 @param completionBlock: A completion block with a NSArray of the regions
 */
- (void)getRegionWithId:(int)regionId completion:(RegionsRequestCompletionBlock)completionBlock;

/*
 Tells the database that a user has entered the region and is studying there
 
 Returns the updated Region
 
 @param completionBlock: A completion block with a NSArray of the regions
 */
- (void)userEntersRegionWithId:(int)regionId completion:(UpdateUserLocationCompletionBlock)completionBlock;

/*
 Tells the database that a user has exited the region
 
 Returns the updated Region
 
 @param completionBlock: A completion block with a NSArray of the regions
 */
- (void)userExitsRegionWithId:(int)regionId completion:(UpdateUserLocationCompletionBlock)completionBlock;

@end
