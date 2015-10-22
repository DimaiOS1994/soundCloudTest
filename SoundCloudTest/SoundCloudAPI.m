//
//  SoundCloudAPI.m
//  SoundCloudTest
//
//  Created by Дима on 15.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import "SoundCloudAPI.h"
#import "Track.h"
#import <UIKit/UIKit.h>

#define CLIENT_ID @"830a5aeb830452c40a70c14f1ac090df"

@implementation SoundCloudAPI

- (instancetype)init {
  self = [super init];
  if (self) {
    self.session = [NSURLSession sharedSession];
  }
  return self;
}

- (void)getMusicsWithSearchString:(NSString*)searchString withLimit:(NSInteger) limit withOffset: (NSInteger) offset
                  completionBlock:
(void (^)(NSArray* array, NSError* error))completion {
    
    NSMutableArray* resultArray = [NSMutableArray array];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/"
                                                                                             @"tracks?q=%@&format=json&"
                                                                                             @"client_id=%@&limit=%i&offset=%i",
                                                                                             searchString, CLIENT_ID,limit,offset]]];
    
    [[self.session
      dataTaskWithRequest:request
      completionHandler:^(NSData* _Nullable data,
                          NSURLResponse* _Nullable response,
                          NSError* _Nullable error) {
          
          NSArray* array =
          [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          
          
          for (NSDictionary* dictionary in array) {
              
              if ([[dictionary objectForKey:@"streamable"] integerValue]==1) {
             // NSLog(@"%@", [dictionary description]);
                                
                  NSDictionary* dictUser = [dictionary objectForKey:@"user"];
                  
                  Track* musicModel = [[Track alloc] init];
                  musicModel.purchaseUrl = [dictionary objectForKey:@"purchase_url"];
                  musicModel.title = [dictionary objectForKey:@"title"];
                  musicModel.streamUrl = [dictionary objectForKey:@"stream_url"];
                  musicModel.userName = [dictUser objectForKey:@"username"];
                  musicModel.userID = [dictUser objectForKey:@"id"];
                  musicModel.imageUrl = [dictUser objectForKey:@"avatar_url"];
                  
                  [resultArray addObject:musicModel];
              }
          }
          
          completion(resultArray, error);
          
      }] resume];
}

- (void)getImageForMusicWithUrl:(NSString*)url
                completionBlock:(void (^)(UIImage* image))completion {
  [[self.session dataTaskWithURL:[NSURL URLWithString:url]
               completionHandler:^(NSData* _Nullable data,
                                   NSURLResponse* _Nullable response,
                                   NSError* _Nullable error) {

                 UIImage* image = [UIImage imageWithData:data];

                 completion(image);

               }] resume];
}

- (void)getUserMusicForUserID:(NSString*)userID
              completionBlock:
                  (void (^)(NSArray* array, NSError* error))completion {
}

- (NSURL*)getMusicStreamUrl:(NSString*)musicModel {
  NSURL* url =
      [NSURL URLWithString:[NSString stringWithFormat:@"%@.json?client_id=%@",
                                                      musicModel, CLIENT_ID]];

  return url;
}

@end
