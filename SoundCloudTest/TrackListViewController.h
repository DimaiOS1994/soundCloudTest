//
//  ViewController.h
//  SoundCloudTest
//
//  Created by Дима on 09.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackListCell.h"
#define DOCUMENTS                                                             \
  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, \
                                       YES) lastObject]

@interface TrackListViewController
    : UIViewController<UISearchBarDelegate, UITableViewDataSource,
                       UITableViewDelegate, TrackListCellDelegate>

@property(strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property(strong, nonatomic) IBOutlet UITableView *tableView;

@end
