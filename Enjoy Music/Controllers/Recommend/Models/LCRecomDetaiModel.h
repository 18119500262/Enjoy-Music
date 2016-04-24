//
//  LCRecomDetaiModel.h
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRootModel.h"

@interface LCRecomDetaiModel : LCRootModel

@property (nonatomic, copy) NSString  *title;
// 作者
@property (nonatomic, copy) NSString  *nickName;
// 更新时间
@property (nonatomic, copy) NSString  *updateTime;
// 播放次数
@property (nonatomic, copy) NSString  *totalViews;
// 收藏
@property (nonatomic, copy) NSString  *totalFavorites;
// 积分
@property (nonatomic, copy) NSString  *integral;
// 描述
@property (nonatomic, copy) NSString  *descrip;





@end
