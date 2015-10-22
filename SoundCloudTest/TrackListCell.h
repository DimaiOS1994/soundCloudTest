//
//  MusicTableViewCell.h
//  SoundCloudTest
//
//  Created by Дима on 16.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackListCell : UITableViewCell

@property(strong, nonatomic) IBOutlet UIImageView *image;
@property(strong, nonatomic) IBOutlet UILabel *title;
@property(strong, nonatomic) IBOutlet UIButton *userButton;

@end
