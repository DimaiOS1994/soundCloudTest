//
//  ViewController.m
//  SoundCloudTest
//
//  Created by Дима on 09.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import "TrackListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "SoundCloudAPI.h"
#import "Track.h"
#import "TrackListCell.h"
#import "UserTrackTableViewController.h"

@interface TrackListViewController ()

@property(strong, nonatomic) NSMutableArray *array;
@property(strong, nonatomic) AVQueuePlayer *audio;
@property(strong, nonatomic) SoundCloudAPI *api;
@property(strong, nonatomic) NSString *searchText;
@property(strong, nonatomic) NSString *userId;
@property(assign, nonatomic) BOOL isDownload;

@end

static UIActivityIndicatorView *activity;
static UIActivityIndicatorView *activityTable;

@implementation TrackListViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.userId = @"";
  self.isDownload = NO;

  self.navigationItem.title = @"Поиск";

  activityTable = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [activityTable setFrame:CGRectMake(self.view.center.x - 15,
                                     self.view.frame.size.height - 30, 30, 30)];
  [activityTable setColor:[UIColor blackColor]];
  [self.view addSubview:activityTable];
  [self.view bringSubviewToFront:activityTable];

  activity = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  [activity setCenter:self.view.center];
  [activity setColor:[UIColor blackColor]];
  [self.view addSubview:activity];
  [self.view bringSubviewToFront:activity];

  self.searchBar.delegate = self;
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.array.count;
}

- (void)viewWillAppear:(BOOL)animated {
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
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

    [self.api getMusicsWithSearchString:self.searchText
        orUser:self.userId
        withLimit:6
        withOffset:self.array.count
        completionBlock:^(NSArray *array, NSError *error) {
          dispatch_async(dispatch_get_main_queue(), ^{

            [self.array addObjectsFromArray:array];
            [self.tableView reloadData];
            [activityTable stopAnimating];
          });
        }
        noResult:^(BOOL result){

        }];
  }

  Track *musicModel = self.array[indexPath.row];
  cell.title.text = musicModel.title;
  [cell.userButton setTitle:musicModel.userName forState:UIControlStateNormal];
  cell.delegate = self;

  NSArray *contentArray = [[NSFileManager defaultManager]
      contentsOfDirectoryAtPath:[DOCUMENTS
                                    stringByAppendingPathComponent:@"/Music"]
                          error:nil];

  if ([contentArray
          containsObject:[musicModel.title stringByAppendingString:@".mp3"]]) {
    cell.downloadOutlet.hidden = YES;
  }

  cell.image.image = nil;

  [self.api getImageForMusicWithUrl:musicModel.imageUrl
                    completionBlock:^(UIImage *image) {

                      dispatch_async(dispatch_get_main_queue(), ^{

                        cell.image.image = image;

                      });

                    }];

  return cell;
}

- (void)userButton:(TrackListCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

  Track *musicModel = self.array[indexPath.row];

  UIStoryboard *myboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UserTrackTableViewController *userTrack = (UserTrackTableViewController
                                                 *)[myboard
      instantiateViewControllerWithIdentifier:@"UserTrackTableViewController"];
  userTrack.userId = musicModel.userID;
  userTrack.userName = musicModel.userName;

  [self.navigationController pushViewController:userTrack animated:YES];
}

- (void)downloadButton:(TrackListCell *)cell {
  NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

  Track *musicModel = self.array[indexPath.row];

  if (self.isDownload == NO) {
    [self.api downloadFileWithUrl:musicModel.streamUrl
        withFinishName:musicModel.title
        withCompletionBlock:^() {

          dispatch_async(dispatch_get_main_queue(), ^{

            [cell.downloadOutlet setBackgroundImage:[UIImage imageNamed:@"stop"]
                                           forState:UIControlStateNormal];
            self.isDownload = YES;
          });

        }
        withCompletionDownloadBlock:^{

          dispatch_async(dispatch_get_main_queue(), ^{

            cell.downloadOutlet.hidden = YES;

          });
        }];

  } else {
    [self.api stopDownloadTask:^{

      dispatch_async(dispatch_get_main_queue(), ^{

        [cell.downloadOutlet setBackgroundImage:[UIImage imageNamed:@"download"]
                                       forState:UIControlStateNormal];
        self.isDownload = NO;
      });

    }];
  }
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

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
  self.api = [[SoundCloudAPI alloc] init];

  self.searchText = searchText;
  [activity startAnimating];

  [self.api getMusicsWithSearchString:self.searchText
      orUser:self.userId
      withLimit:6
      withOffset:0
      completionBlock:^(NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{

          self.array = [NSMutableArray arrayWithArray:array];
          [self.tableView reloadData];
          [activity stopAnimating];

        });

      }
      noResult:^(BOOL result) {

        if (result == NO) {
          dispatch_async(dispatch_get_main_queue(), ^{

            [activity stopAnimating];

          });
        }

      }];

  //}];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder];
}

@end
