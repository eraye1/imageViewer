//
//  CSHScrollViewController.m
//  imageViewer
//
//  Created by Minjian Wang on 7/22/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import "CSHScrollViewController.h"
#import "CSHDataManager.h"
#import "CSHScrollView.h"

@interface CSHScrollViewController ()

@property (weak, nonatomic) IBOutlet CSHScrollView *scrollView;

@end

@implementation CSHScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.scrollView.bounces = NO;
    
    UIImage *image = self.rollObject.original;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);

    self.scrollView.imageView = imageView;
    self.scrollView.offset = self.navigationController.navigationBar.frame.size.height;
    
    if (![self.rollObject.caption isKindOfClass:[NSNull class]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" style:UIBarButtonItemStylePlain target:self action:@selector(triggerCaption)];
    }
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(respondToTapGesture)];
    
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.scrollView.contentSize = image.size;
    
}

#pragma selectors
- (void)triggerCaption {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Caption"
                                                    message:self.rollObject.caption
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)respondToTapGesture {
    if (self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
        self.scrollView.offset = self.navigationController.navigationBar.frame.size.height;
        [self.scrollView layoutSubviews];
    } else {
        self.navigationController.navigationBarHidden = YES;
        self.scrollView.offset = 0;
        [self.scrollView layoutSubviews];
    }
}

@end
