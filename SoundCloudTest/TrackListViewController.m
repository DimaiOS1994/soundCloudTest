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

@interface TrackListViewController ()

@property(strong, nonatomic) NSMutableArray *array;
@property(strong, nonatomic) AVQueuePlayer *audio;
@property(strong, nonatomic) SoundCloudAPI *api;
@property(strong, nonatomic) NSString* searchText;


@end

static UIActivityIndicatorView *activity;
static UIActivityIndicatorView *activityTable;

@implementation TrackListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    


  activityTable = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [activityTable setFrame:CGRectMake(self.view.center.x-15, self.view.frame.size.height-30, 30, 30)];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TrackListCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"TrackListCell"];

  if (!cell) {
    cell = [[TrackListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:@"Music"];
      
      
  }
    //NSLog(@"%i %i", indexPath.row, self.array.count);
    
    if (indexPath.row+1 == self.array.count) {
        
        [activityTable startAnimating];
        
        
        [self.api getMusicsWithSearchString:self.searchText withLimit:6 withOffset:self.array.count completionBlock:^(NSArray *array, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.array addObjectsFromArray:array];
                [self.tableView reloadData];
                [activityTable stopAnimating];
            });
        }];
        
        
    }

  Track *musicModel = self.array[indexPath.row];
  cell.title.text = musicModel.title;
  [cell.userButton setTitle:musicModel.userName forState:UIControlStateNormal ] ;

    NSLog(@"%@", musicModel.userName);
    
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

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
  self.api = [[SoundCloudAPI alloc] init];

    self.searchText = searchText;
  [activity startAnimating];

                      
    [self.api getMusicsWithSearchString:self.searchText withLimit:6 withOffset:0 completionBlock:^(NSArray *array, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.array = [NSMutableArray arrayWithArray:array];
            [self.tableView reloadData];
            [activity stopAnimating];
            
        });
        
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
