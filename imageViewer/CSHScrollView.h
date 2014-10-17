//
//  CSHScrollView.h
//  imageViewer
//
//  Created by Minjian Wang on 7/22/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHScrollView : UIScrollView

@property (nonatomic, strong) UIImageView *imageView;
@property CGFloat offset;

@end
