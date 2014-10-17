//
//  CSHCrunchyRollObject.m
//  imageViewer
//
//  Created by Minjian Wang on 7/18/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import "CSHCrunchyRollObject.h"

//This should be more specific, but there wasn't a better generic name for this.
@implementation CSHCrunchyRollObject

- (instancetype)initWithCaption:(NSString *)caption {
    self.caption = caption;
    return self;
}

@end
