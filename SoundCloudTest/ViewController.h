//
//  ViewController.h
//  SoundCloudTest
//
//  Created by Дима on 09.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

