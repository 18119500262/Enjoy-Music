//
//  LCListModel.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCListModel.h"

@implementation LCListModel

+(JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"Id"}];
}

@end
