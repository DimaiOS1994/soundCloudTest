//
//  MusicTableViewCell.h
//  SoundCloudTest
//
//  Created by Дима on 16.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackListCell;

@protocol TrackListCellDelegate<NSObject>

- (void)userButton:(TrackListCell *)cell;
- (void)downloadButton:(TrackListCell *)cell;

@end

@interface TrackListCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *image;
@property(strong, nonatomic) IBOutlet UILabel *title;
@property(strong, nonatomic) IBOutlet UIButton *userButton;
@property(weak, nonatomic) id<TrackListCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *downloadOutlet;

- (IBAction)userButtonAction:(UIButton *)sender;

- (IBAction)downloadAction:(UIButton *)sender;

@end
