//
//  SoundCloudAPI.m
//  SoundCloudTest
//
//  Created by Дима on 15.10.15.
//  Copyright © 2015 Дима. All rights reserved.
//

#import "SoundCloudAPI.h"
#import "MusicModel.h"
#import <UIKit/UIKit.h>

#define CLIENT_ID @"830a5aeb830452c40a70c14f1ac090df"


@implementation SoundCloudAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
        
    }
    return self;
}


- (void) getMusicsForSearchString: (NSString*) searchString completionBlock:(void(^)(NSArray* array, NSError* error)) completion{
    
    NSMutableArray* resultArray = [NSMutableArray array];
    
    NSURL* urlString = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/tracks?q=%@&format=json&client_id=%@",searchString, CLIENT_ID ]];
    
    
    [[self.session dataTaskWithURL:urlString completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSArray* array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        

        NSLog(@"%@", [array description]);
        
        
        for (NSDictionary* dictionary in array) {
            
            NSDictionary* dictUser = [dictionary objectForKey:@"user"];
            
            
            MusicModel* musicModel = [[MusicModel alloc] init];
            musicModel.purchaseUrl = [dictionary objectForKey:@"purchase_url"];
            musicModel.title = [dictionary objectForKey:@"title"];
            musicModel.streamUrl = [dictionary objectForKey:@"stream_url"];
            musicModel.userName = [dictUser objectForKey:@"username"];
            musicModel.userID = [dictUser objectForKey:@"id"];
            musicModel.imageUrl = [dictUser objectForKey:@"avatar_url"];
            
            [resultArray addObject:musicModel];
            
        }
        
        completion(resultArray, error);
        
        
    }] resume];
    
    
    
}

- (void) getImageForMusicWithUrl: (NSString*) url completionBlock:(void(^)(UIImage* image)) completion{

    

    [[self.session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        UIImage* image = [UIImage imageWithData:data];
        
        completion(image);
        
    }] resume];
    
    
}

- (void) getUserMusicForUserID: (NSString*) userID completionBlock:(void(^)(NSArray* array, NSError* error)) completion{
    
    
    
}

- (NSURL*) getMusicStreamUrl: (NSString*) musicModel{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@.json?client_id=%@", musicModel, CLIENT_ID]];
    
    return url;
    
}



@end
