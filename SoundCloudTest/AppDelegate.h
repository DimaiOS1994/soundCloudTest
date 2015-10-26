//
//  AppDelegate.h
//  SoundCloudTest
//
//  Created by Дима on 09.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMainViewController                \
  (MainViewController *)[[(AppDelegate *)[ \
      [UIApplication sharedApplication] delegate] window] rootViewController]
#define kNavigationController                                    \
  (UINavigationController                                        \
       *)[(MainViewController *)[[(AppDelegate *)[[UIApplication \
          sharedApplication] delegate] window] rootViewController] rootViewController]

@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@end
