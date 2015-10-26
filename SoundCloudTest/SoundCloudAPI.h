//
//  SoundCloudAPI.h
//  SoundCloudTest
//
//  Created by Дима on 15.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage;
@class MusicModel;

@interface SoundCloudAPI : NSObject <NSURLSessionDownloadDelegate>

@property(strong, nonatomic) NSURLSession *session;
@property(strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSString* fileName;

@property (nonatomic,copy) void(^completion)(NSURL* location);

- (void)getMusicsWithSearchString:(NSString *)searchString
                           orUser:(NSString *)userName
                        withLimit:(NSInteger)limit
                       withOffset:(NSInteger)offset
                  completionBlock:
                      (void (^)(NSArray *array, NSError *error))completion;

- (void)getUserMusicForUserID:(NSString *)userID
              completionBlock:
                  (void (^)(NSArray *array, NSError *error))completion;

- (void)getImageForMusicWithUrl:(NSString *)url
                completionBlock:(void (^)(UIImage *image))completion;

- (NSURL *)getMusicStreamUrl:(NSString *)musicModel;

- (void) downloadFileWithUrl:(NSString*) url withFinishName:(NSString*)name withCompletionBlock : (void (^)(NSURL* location))completion;

@end
