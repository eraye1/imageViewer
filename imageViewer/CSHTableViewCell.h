//
//  CSHTableViewCell.h
//  imageViewer
//
//  Created by Minjian Wang on 7/21/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSHTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *text;

@end
