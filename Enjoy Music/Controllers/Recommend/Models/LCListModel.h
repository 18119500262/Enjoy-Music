//
//  LCListModel.h
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRootModel.h"

@interface LCListModel : LCRootModel

@property (nonatomic, copy) NSString  *Id;

@property (nonatomic, copy) NSString  *playListPic;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSString  *artistName;
// 播放次数
@property (nonatomic, copy) NSString  *totalViews;
// 视频网址
@property (nonatomic, copy) NSString  *hdUrl;
@property (nonatomic,copy) NSString *url;







@end
