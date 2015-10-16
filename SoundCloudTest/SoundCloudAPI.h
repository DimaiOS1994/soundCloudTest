//
//  SoundCloudAPI.h
//  SoundCloudTest
//
//  Created by Дима on 15.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;

@interface SoundCloudAPI : NSObject

@property (strong, nonatomic) NSURLSession* session;

- (void) getMusicsForSearchString: (NSString*) searchString completionBlock:(void(^)(NSArray* array, NSError* error)) completion;
- (void) getUserMusicForUserID: (NSString*) userID completionBlock:(void(^)(NSArray* array, NSError* error)) completion;
- (void) getImageForMusicWithUrl: (NSString*) url completionBlock:(void(^)(UIImage* image)) completion;
@end