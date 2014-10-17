//
//  CSHCrunchyRollObject.h
//  imageViewer
//
//  Created by Minjian Wang on 7/18/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSHCrunchyRollObject : NSObject

@property (nonatomic, strong) NSString * caption;
@property (nonatomic, strong) UIImage * original;
@property (nonatomic, strong) UIImage * thumb;

- (instancetype)initWithCaption:(NSString *)caption;

@end
