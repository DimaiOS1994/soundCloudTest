//
//  LeftViewController.m
//  LGSideMenuControllerDemo
//
//  Created by Grigory Lutkov on 18.02.15.
//  Copyright (c) 2015 Grigory Lutkov. All rights reserved.
//

#import "LeftViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "LeftViewCell.h"
#import "TrackListViewController.h"
#import "FileManagerViewController.h"

@interface LeftViewController ()

@property(strong, nonatomic) NSArray *titlesArray;

@end

@implementation LeftViewController

- (void)awakeFromNib {
  [super awakeFromNib];

  _titlesArray = @[
    @"SoundCloud",
    @"VK",
    @"Загрузки",
  ];

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.contentInset = UIEdgeInsetsMake(20.f, 0.f, 20.f, 0.f);
  self.tableView.showsVerticalScrollIndicator = NO;
}

#pragma mark -

- (void)openLeftView {
  [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)openRightView {
  [kMainViewController showRightViewAnimated:YES completionHandler:nil];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return _titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  LeftViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

  cell.textLabel.text = _titlesArray[indexPath.row];
  cell.separatorView.hidden = YES;
  
  cell.tintColor = _tintColor;

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (indexPath.row == 0) {
    TrackListViewController *trackList =
        [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
            instantiateViewControllerWithIdentifier:@"TrackListViewController"];

    [kNavigationController setViewControllers:@[ trackList ]];

    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
  } else if (indexPath.row == 2) {
    FileManagerViewController *fileManager = [
        [UIStoryboard storyboardWithName:@"Main" bundle:nil]
        instantiateViewControllerWithIdentifier:@"FileManagerViewController"];

    [kNavigationController setViewControllers:@[ fileManager ]];

    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
  }
}

@end
