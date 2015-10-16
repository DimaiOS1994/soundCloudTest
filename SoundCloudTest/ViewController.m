//
//  ViewController.m
//  SoundCloudTest
//
//  Created by Дима on 09.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "SoundCloudAPI.h"
#import "MusicModel.h"
#import "MusicTableViewCell.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray* array;
@property (strong, nonatomic) AVQueuePlayer* audio;
@property (strong, nonatomic) SoundCloudAPI* api;

@end

static UIActivityIndicatorView* activity;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setCenter:self.tableView.center];
    [activity setColor:[UIColor blackColor]];
    [self.tableView addSubview:activity];
    [self.tableView bringSubviewToFront:activity];

    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.array.count;
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MusicTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Music"];
    
    if (!cell) {
        
       cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Music"];
    }
    
    MusicModel* musicModel = self.array[indexPath.row];
    cell.title.text = musicModel.title;
    cell.userButton.titleLabel.text = musicModel.userName;

    
    [self.api getImageForMusicWithUrl:musicModel.imageUrl completionBlock:^(UIImage *image) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            cell.image.image = image;
            
        });
        
    }];
    
   
    
    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicModel* musicModel = self.array[indexPath.row];
    
    NSURL* streamUrl = [self.api getMusicStreamUrl:musicModel.streamUrl];
    
    AVPlayerItem* item = [AVPlayerItem playerItemWithURL:streamUrl];

    
    
    self.audio = [[AVQueuePlayer alloc] initWithPlayerItem:item];
    
    self.audio.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    
    
    
    AVPlayerViewController* vc = [[AVPlayerViewController alloc] init];
    [vc setPlayer:self.audio];
    
    
    [self presentViewController:vc animated:YES completion:nil];
    [vc.player play];
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    
    
    self.api = [[SoundCloudAPI alloc] init];
    
    [activity startAnimating];
    
    [self.api getMusicsForSearchString:searchText completionBlock:^(NSArray *array, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.array = array;
            [self.tableView reloadData];
            [activity stopAnimating];
            
        });
        
        
    }];

    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
}



@end
