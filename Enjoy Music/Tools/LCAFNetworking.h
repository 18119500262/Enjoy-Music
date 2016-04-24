//
//  LCAFNetworking.h
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface LCAFNetworking : AFHTTPRequestOperationManager

+ (instancetype)sharedClient;

//- (void)GETRequest:(NSString *)path
//        parameters:(NSDictionary *)parameters
//           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//            failer:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failer;

@end
