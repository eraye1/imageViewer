//
//  CSHDataManager.h
//  imageViewer
//
//  Created by Minjian Wang on 7/18/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHDataManager : NSObject

@property (nonatomic, strong) NSMutableArray *crunchyRollObjectList;

#pragma class methods
+ (instancetype)sharedManager;

#pragma instance methods
- (instancetype)init;
- (instancetype)initPrivate;
- (void)initializeCrunchyRollData;

@end
