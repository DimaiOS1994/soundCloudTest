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


//{
//    "artwork_url" = "https://i1.sndcdn.com/artworks-000091641111-z9w81a-large.jpg";
//    "attachments_uri" = "https://api.soundcloud.com/tracks/167444670/attachments";
//    bpm = "<null>";
//    "comment_count" = 11824;
//    commentable = 1;
//    "created_at" = "2014/09/12 19:20:10 +0000";
//    description = "#IDFWU\nhttp://smarturl.it/iIDFWU";
//    "download_count" = 0;
//    "download_url" = "<null>";
//    downloadable = 0;
//    duration = 284865;
//    "embeddable_by" = all;
//    "favoritings_count" = 1095854;
//    genre = "big sean";
//    id = 167444670;
//    isrc = "";
//    "key_signature" = "";
//    kind = track;
//    "label_id" = "<null>";
//    "label_name" = "";
//    "last_modified" = "2015/10/11 04:53:49 +0000";
//    license = "all-rights-reserved";
//    "likes_count" = 1095854;
//    "monetization_model" = "NOT_APPLICABLE";
//    "original_content_size" = 50233068;
//    "original_format" = wav;
//    permalink = idfwu;
//    "permalink_url" = "https://soundcloud.com/bigsean-1/idfwu";
//    "playback_count" = 57674959;
//    policy = ALLOW;
//    "purchase_title" = "<null>";
//    "purchase_url" = "http://smarturl.it/iIDFWU";
//    release = "";
//    "release_day" = "<null>";
//    "release_month" = "<null>";
//    "release_year" = "<null>";
//    "reposts_count" = 146201;
//    sharing = public;
//    state = finished;
//    "stream_url" = "https://api.soundcloud.com/tracks/167444670/stream";
//    streamable = 0;
//    "tag_list" = "\"dj mustard\" \"kanye west\" \"dj dahi\" Detroit \"finally famous\" \"good music\" \"roc nation\"";
//    title = "I Don't Fuck With You (Ft. E-40)(Prod. DJ Mustard & Kanye West / Co-Prod. DJ Dahi & keY Wane)";
//    "track_type" = "";
//    uri = "https://api.soundcloud.com/tracks/167444670";
//    user =         {
//        "avatar_url" = "https://i1.sndcdn.com/avatars-000130906949-ctamje-large.jpg";
//        id = 4803918;
//        kind = user;
//        "last_modified" = "2015/08/17 18:56:50 +0000";
//        permalink = "bigsean-1"; 
//        "permalink_url" = "http://soundcloud.com/bigsean-1";
//        uri = "https://api.soundcloud.com/users/4803918";
//        username = "Big Sean";
//    };
//    "user_favorite" = 0;
//    "user_id" = 4803918;
//    "user_playback_count" = "<null>";
//    "video_url" = "<null>";
//    "waveform_url" = "https://w1.sndcdn.com/SciMN2ThpTed_m.png";
//},


- (IBAction)button:(UIButton *)sender {
    
    //https://api.soundcloud.com/tracks/7548396/stream?client_id=830a5aeb830452c40a70c14f1ac090df
    
    //https://api.soundcloud.com/me/tracks?q=SEARCHTEXT&format=json
    
    //NSData *data =[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://api.soundcloud.com/tracks/7548396/stream?client_id=830a5aeb830452c40a70c14f1ac090df"]];
    
    //AVPlayer* player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"https://api.soundcloud.com/tracks/7548396/stream?client_id=830a5aeb830452c40a70c14f1ac090df"]];
//    
    //AVAsset* avAsset = [AVAsset assetWithURL:[NSURL URLWithString:@"https://api.soundcloud.com/tracks/53354103/stream?client_id=830a5aeb830452c40a70c14f1ac090df"]] ;

    
    NSString *streamingString = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks/7548396/stream.json?client_id=830a5aeb830452c40a70c14f1ac090df"];
    NSURL *streamingURL = [NSURL URLWithString:streamingString];
    
    NSString *streamingString1 = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks/188589889/stream.json?client_id=830a5aeb830452c40a70c14f1ac090df"];
    NSURL *streamingURL1 = [NSURL URLWithString:streamingString1];
    
    
    
    
    AVPlayerItem* item1 = [AVPlayerItem playerItemWithURL:streamingURL];
    AVPlayerItem* item = [AVPlayerItem playerItemWithURL:streamingURL1];
    
    
    
    AVAsset* asset = [[AVAsset alloc] init];
    
    self.audio = [[AVQueuePlayer alloc] initWithItems:[NSArray arrayWithObjects:item, item1, nil]];
    
    
    [self.audio canInsertItem:item afterItem:item1];
   

    self.audio.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;
    
    AVPlayerViewController* vc = [[AVPlayerViewController alloc] init];
    [vc setPlayer:self.audio];

    
    [self presentViewController:vc animated:YES completion:nil];

    
}



@end
