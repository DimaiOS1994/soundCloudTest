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
#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


@implementation SoundCloudAPI

- (instancetype)init {
  self = [super init];
  if (self) {
      self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] ];
      self.backgroundSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"backgroundSess"] delegate:self delegateQueue:nil];
      
      
  }
  return self;
}

- (void)getMusicsWithSearchString:(NSString *)searchString
                           orUser:(NSString *)userId
                        withLimit:(NSInteger)limit
                       withOffset:(NSInteger)offset
                  completionBlock:
                      (void (^)(NSArray *array, NSError *error))completion {
  NSMutableArray *resultArray = [NSMutableArray array];

  NSMutableURLRequest *request;

  if (![userId isEqual:@""]) {
    request = [NSMutableURLRequest
        requestWithURL:
            [NSURL
                URLWithString:[NSString stringWithFormat:
                                            @"https://api.soundcloud.com/"
                                            @"/users/%@/tracks?format=json&"
                                            @"client_id=%@&limit=%i&offset=%i",
                                            userId, CLIENT_ID, limit, offset]]];

  } else {
    request = [NSMutableURLRequest
        requestWithURL:
            [NSURL URLWithString:
                       [NSString stringWithFormat:
                                     @"https://api.soundcloud.com/"
                                     @"tracks?q=%@&format=json&"
                                     @"client_id=%@&limit=%i&offset=%i",
                                     searchString, CLIENT_ID, limit, offset]]];
  }

  [[self.session
      dataTaskWithRequest:request
        completionHandler:^(NSData *_Nullable data,
                            NSURLResponse *_Nullable response,
                            NSError *_Nullable error) {

          NSArray *array =
              [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

          for (NSDictionary *dictionary in array) {
            if ([[dictionary objectForKey:@"streamable"] integerValue] == 1) {
              NSDictionary *dictUser = [dictionary objectForKey:@"user"];
                
                NSLog(@"%@", [dictionary description]);

              Track *musicModel = [[Track alloc] init];
              musicModel.purchaseUrl =
                  [dictionary objectForKey:@"purchase_url"];
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

- (void) downloadFileWithUrl:(NSString*) url withFinishName:(NSString*)name withCompletionBlock : (void (^)(NSURL* location))completion {
    
    
    self.fileName = name;
    
    [[self.backgroundSession downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?client_id=%@",url,CLIENT_ID]]] ]resume];
    //self.completion = completion;
     
}



- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
   
    
    
    
    BOOL musicDirectory;
    
    musicDirectory = [[NSFileManager defaultManager] fileExistsAtPath:[DOCUMENTS stringByAppendingPathComponent:@"/Music"]];
    
    if (musicDirectory) {
        
         NSError* error;
        
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:[DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"/Music/%@.mp3",self.fileName]] error:&error];
        NSLog(@"%@",error);
        
        NSArray* array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[DOCUMENTS stringByAppendingPathComponent:@"/Music"] error:nil];
        
        NSLog(@"%@", [array description]);
        
        
    }else{
        
        NSError* error;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[DOCUMENTS stringByAppendingPathComponent:@"/Music"] withIntermediateDirectories:YES attributes:nil error:&error];
        
        
        
    }
    
    
    
}

- (void)getImageForMusicWithUrl:(NSString *)url
                completionBlock:(void (^)(UIImage *image))completion {
  [[self.session dataTaskWithURL:[NSURL URLWithString:url]
               completionHandler:^(NSData *_Nullable data,
                                   NSURLResponse *_Nullable response,
                                   NSError *_Nullable error) {

                 UIImage *image = [UIImage imageWithData:data];

                 completion(image);

               }] resume];
}

- (void)getUserMusicForUserID:(NSString *)userID
              completionBlock:
                  (void (^)(NSArray *array, NSError *error))completion {
}

- (NSURL *)getMusicStreamUrl:(NSString *)musicModel {
  NSURL *url =
      [NSURL URLWithString:[NSString stringWithFormat:@"%@.json?client_id=%@",
                                                      musicModel, CLIENT_ID]];

  return url;
}

@end
