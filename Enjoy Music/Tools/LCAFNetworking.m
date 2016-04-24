//
//  LCAFNetworking.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCAFNetworking.h"
#import "Header.h"

@implementation LCAFNetworking

+ (instancetype)sharedClient {
    
    static LCAFNetworking * client= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        client = [[LCAFNetworking alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    return client;
}


@end
