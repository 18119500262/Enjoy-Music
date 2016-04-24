//
//  LCRecomDetaiModel.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRecomDetaiModel.h"

@implementation LCRecomDetaiModel

+ (JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description":@"descrip"}];
}

@end
