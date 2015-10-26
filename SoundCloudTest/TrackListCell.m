//
//  MusicTableViewCell.m
//  SoundCloudTest
//
//  Created by Дима on 16.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import "TrackListCell.h"

@implementation TrackListCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (IBAction)userButtonAction:(UIButton *)sender {
    
  [self.delegate userButton:self];
    
}

- (IBAction)downloadAction:(UIButton *)sender {
    
    [self.delegate downloadButton:self];
    
}
@end
