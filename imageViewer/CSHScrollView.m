//
//  CSHScrollView.m
//  imageViewer
//
//  Created by Minjian Wang on 7/22/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import "CSHScrollView.h"

@implementation CSHScrollView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically.
    // Nav controller already offsets, so we need to compensate for that.  Set as property so we can change it back to 0 later (for example, when screen is tapped).
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2 - self.offset;
    else
        frameToCenter.origin.y = 0 - self.offset;
    
    self.imageView.frame = frameToCenter;
    
    [self addSubview:self.imageView];
}

@end
