//
//  LCSBModel.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/6.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCSBModel.h"

@implementation LCSBModel
+(JSONKeyMapper*)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"ID",@"description":@"desc"}];
}
@end
