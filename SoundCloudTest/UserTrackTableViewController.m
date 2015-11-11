//
//  UserTrackTableViewController.m
//  SoundCloudTest
//
//  Created by Дима on 23.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import "UserTrackTableViewController.h"
#import "TrackListCell.h"
#import "SoundCloudAPI.h"
#import "Track.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

@interface UserTrackTableViewController ()

@property(strong, nonatomic) SoundCloudAPI *api;
@property(strong, nonatomic) NSMutableArray *array;
@property(strong, nonatomic) AVQueuePlayer *audio;

@end

static UIActivityIndicatorView *activity;
static UIActivityIndicatorView *activityTable;

@implementation UserTrackTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.title = self.userName;

  activityTable = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [activityTable
      setFrame:CGRectMake(self.view.center.x - 15,
                          self.tableView.frame.size.height - 30, 30, 30)];
  [activityTable setColor:[UIColor blackColor]];
  [self.view addSubview:activityTable];
  [self.view bringSubviewToFront:activityTable];

  activity = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [activity setCenter:self.view.center];
  [activity setColor:[UIColor blackColor]];
  [self.view addSubview:activity];
  [self.view bringSubviewToFront:activity];

  [activity startAnimating];

  self.api = [[SoundCloudAPI alloc] init];
  [self.api getMusicsWithSearchString:@""
                               orUser:self.userId
                            withLimit:6
                           withOffset:0
                      completionBlock:^(NSArray *array, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                          self.array = [NSMutableArray arrayWithArray:array];
                          [self.tableView reloadData];
                          [activity stopAnimating];

                        });

                      } noResult:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TrackListCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"TrackListCell"];

  if (!cell) {
    cell = [[TrackListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:@"TrackListCell"];
  }

  if (indexPath.row + 1 == self.array.count) {
    [activityTable startAnimating];

    [self.api getMusicsWithSearchString:@""
                                 orUser:self.userId
                              withLimit:6
                             withOffset:self.array.count
                        completionBlock:^(NSArray *array, NSError *error) {
                          dispatch_async(dispatch_get_main_queue(), ^{

                            [self.array addObjectsFromArray:array];
                            [self.tableView reloadData];
                            [activityTable stopAnimating];
                          });
                        } noResult:nil];
  }

  Track *musicModel = self.array[indexPath.row];
  cell.title.text = musicModel.title;

  cell.userButton.hidden = YES;

  [self.api getImageForMusicWithUrl:musicModel.imageUrl
                    completionBlock:^(UIImage *image) {

                      dispatch_async(dispatch_get_main_queue(), ^{

                        cell.image.image = image;

                      });

                    }];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  Track *musicModel = self.array[indexPath.row];

  NSURL *streamUrl = [self.api getMusicStreamUrl:musicModel.streamUrl];

  AVPlayerItem *item = [AVPlayerItem playerItemWithURL:streamUrl];

  self.audio = [[AVQueuePlayer alloc] initWithPlayerItem:item];

  self.audio.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;

  AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
  [vc setPlayer:self.audio];

  [self presentViewController:vc animated:YES completion:nil];
  [vc.player play];
}

- (void)dealloc {
  NSLog(@"UserTableViewController");
}
@end
