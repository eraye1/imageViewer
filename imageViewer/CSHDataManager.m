//
//  CSHDataManager.m
//  imageViewer
//
//  Created by Minjian Wang on 7/18/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import "CSHDataManager.h"
#import "CSHCrunchyRollObject.h"

#import "AFNetworking.h"

@interface CSHDataManager ()

@end

@implementation CSHDataManager

#pragma initializers
+ (instancetype)sharedManager {
    static CSHDataManager *sharedManager;
    if (!sharedManager) {
        sharedManager = [[self alloc] initPrivate];
        [sharedManager initializeCrunchyRollData];
    }
    return sharedManager;
}

- (instancetype)init {
    [NSException raise:@"Singleton initialization error" format:@"Use sharedManager to get access to the manager."];
    return nil;
}

- (instancetype)initPrivate {
    self = [super init];
    self.crunchyRollObjectList = [[NSMutableArray alloc] init];
    return self;
}

#pragma data acquisition.

//gets the data from crunchyroll endpoint.
- (void)initializeCrunchyRollData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    //we have this because the server returns plain text instead of html, so we have to tell the responser serializer what type to expect.
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    [manager GET:@"https://dl.dropboxusercontent.com/u/89445730/images.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
       
        [self convertCrunchyRollDataToUsableFormat:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//gets the data into the format we want: an NSArray of NSString and UIImages.

//Design note: We could also just preload a certain amount and only load more in the background as users scroll in the tableview.
//The upside is, if our tableview gets massive, we don't have to load everything.
//The downside is, it's tricky to implement.
//For simplicity's sake, I just load everything now.

- (void)convertCrunchyRollDataToUsableFormat:(NSArray *)responseObject {
    //done to make sure we don't do this a bunch of times.  
    if ([self.crunchyRollObjectList count] > 0) {
        [self.crunchyRollObjectList removeAllObjects];
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableArray *thumbOperations = [NSMutableArray array];
    NSMutableArray *originalOperations = [NSMutableArray array];
    
    for (NSDictionary *dictionary in responseObject) {
        
        //caption and creating the object.
        NSString *caption = dictionary[@"caption"];
        CSHCrunchyRollObject *rollObject = [[CSHCrunchyRollObject alloc] init];
        if (![caption  isKindOfClass:[NSNull class]]) {
            rollObject.caption = caption;
        }
        
        //adding thumb requests to NSOperationQueue and marking which ones are not null.
        NSString *thumb = dictionary[@"thumb"];
        if (![thumb isKindOfClass:[NSNull class]]) {
            NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:thumb parameters:nil error:nil];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            [thumbOperations addObject:operation];
            
            //we mark these not null by allocating a blank image there.
            rollObject.thumb = [[UIImage alloc] init];
        }
        
        //adding original requests to NSOperationQueue and marking which ones are not null.
        NSString *original = dictionary[@"original"];
        if (![original isKindOfClass:[NSNull class]]) {
            NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:original parameters:nil error:nil];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            
            [originalOperations addObject:operation];
            
            rollObject.original = [[UIImage alloc] init];
        }

        //Add object to list.  Placeholders in place for when the network functions will replace them later.
        [self.crunchyRollObjectList addObject:rollObject];
    }
    
    [[manager operationQueue] addOperations:thumbOperations waitUntilFinished:YES];
    
    int indexToThumbOperations = 0;
    for (CSHCrunchyRollObject *rollObject in self.crunchyRollObjectList) {
        if ([[rollObject thumb] isKindOfClass:[UIImage class]]) {
            AFHTTPRequestOperation *operation = [thumbOperations objectAtIndex:indexToThumbOperations];
            NSLog(@"%d", indexToThumbOperations);
            NSData *thumbData = [operation responseObject];
            UIImage *thumbImage = [UIImage imageWithData:thumbData];
            rollObject.thumb = thumbImage;
            indexToThumbOperations++;
        }
    }
    
    [[manager operationQueue] addOperations:originalOperations waitUntilFinished:YES];
    
    int indexToOriginalOperations = 0;
    for (CSHCrunchyRollObject *rollObject in self.crunchyRollObjectList) {
        if ([[rollObject original] isKindOfClass:[UIImage class]]) {
            AFHTTPRequestOperation *operation = [originalOperations objectAtIndex:indexToOriginalOperations];
            //NSLog("%d", indexToOriginalOperations);
            NSData *originalData = [operation responseObject];
            UIImage *originalImage = [UIImage imageWithData:originalData];
            rollObject.original = originalImage;
            indexToOriginalOperations++;
        }
    }
    
    //Now the list has been populated with all the correct values.
    
    NSLog(@"Completed download of objects. crunchyRollObjectList now populated.");
    [[NSNotificationCenter defaultCenter] postNotification:[[NSNotification alloc] initWithName:@"download complete" object:nil userInfo:nil]];

}

#pragma data access.

  /*
 Design Note: There's a lot of ways to organize the code here.  If this project got a lot bigger, I would probably refactor the code here and break it into two architectural levels.
    1) a data manager level that can deal with the lower-level data acquisition from third-party systems, database-level calls and network requests.
    2) a service level object that can deal with internal objects accessing data
 
 Currently, this is a better design because we can minimize the number of classes in the design and because this is a simple app.
 */


@end
