//
//  CSHTableViewController.m
//  imageViewer
//
//  Created by Minjian Wang on 7/18/14.
//  Copyright (c) 2014 crunchyroll. All rights reserved.
//

#import "CSHTableViewController.h"
#import "CSHScrollViewController.h"
#import "CSHDataManager.h"
#import "CSHCrunchyRollObject.h"
#import "CSHTableViewCell.h"

@interface CSHTableViewController ()

@end

@implementation CSHTableViewController
- (id)initWithCoder:(NSCoder *)aDecoder {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadedData) name:@"download complete" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CSHTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.backBarButtonItem = backButton;
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[CSHDataManager sharedManager] crunchyRollObjectList] count] - 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    CSHCrunchyRollObject *rollObject = [[[CSHDataManager sharedManager] crunchyRollObjectList] objectAtIndex:indexPath.row+1];
    
    cell.image.image = rollObject.thumb;
    cell.image.contentMode = UIViewContentModeScaleAspectFill;
    cell.image.clipsToBounds = YES;
    cell.text.text = [[[[CSHDataManager sharedManager] crunchyRollObjectList] objectAtIndex:indexPath.row+1] caption];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CSHScrollViewController *fullImageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"imageViewController"];
    fullImageVC.rollObject = [[[CSHDataManager sharedManager] crunchyRollObjectList] objectAtIndex:indexPath.row + 1];
    [self.navigationController pushViewController:fullImageVC animated:YES];
}

#pragma helpers
- (void)downloadedData {
    //assume first will always be logo.
    UIImage *image = [[[[CSHDataManager sharedManager] crunchyRollObjectList] objectAtIndex:0] thumb];
    
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *original = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:original style:UIBarButtonItemStylePlain target:nil action:nil];
    barButtonItem.enabled = NO;
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    
    [self.navigationItem setTitle: [[[[CSHDataManager sharedManager] crunchyRollObjectList] objectAtIndex:0] caption]];
    
    [self.tableView reloadData];
}

@end
