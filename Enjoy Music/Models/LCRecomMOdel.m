//
//  LCRecomMOdel.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRecomMOdel.h"

@implementation LCRecomMOdel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"Id",@"description":@"des"}];
}

@end
