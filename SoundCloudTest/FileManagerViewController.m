//
//  ViewController.m
//  SoundCloudTest
//
//  Created by Дима on 23.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import "FileManagerViewController.h"
#define DOCUMENTS                                                             \
  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, \
                                       YES) lastObject]

@interface FileManagerViewController ()

@property(strong, nonatomic) NSArray *array;
@property(strong, nonatomic) AVQueuePlayer *audio;

@end

@implementation FileManagerViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.array = [NSArray array];

  self.array = [[NSFileManager defaultManager]
      contentsOfDirectoryAtPath:[DOCUMENTS
                                    stringByAppendingPathComponent:@"/Music"]
                          error:nil];
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *str = [DOCUMENTS
      stringByAppendingPathComponent:
          [NSString stringWithFormat:@"/Music/%@", self.array[indexPath.row]]];

  AVPlayerItem *item =
      [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:str]];

  self.audio = [[AVQueuePlayer alloc] initWithPlayerItem:item];

  self.audio.actionAtItemEnd = AVPlayerActionAtItemEndAdvance;

  AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
  [vc setPlayer:self.audio];

  [self presentViewController:vc animated:YES completion:nil];
  [vc.player play];
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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"Cell"];
  }

  cell.textLabel.text = [self.array objectAtIndex:indexPath.row];

  return cell;
}

@end
