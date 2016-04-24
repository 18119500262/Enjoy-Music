//
//  LCSBModel.h
//  Enjoy Music
//
//  Created by qianfeng on 16/4/6.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRootModel.h"

@interface LCSBModel : LCRootModel
//"id": 2540502,11
@property (nonatomic,strong)NSString *ID;
    
//"title": "Landscape”,11
@property (nonatomic,strong)NSString *title;
//"description": "SOLIDEMO将于4月13日发行他们的第五张单曲「Landscape」，主打歌是为能登麻美子、花泽香菜、小西克幸、川原庆久、白熊宽嗣、石田彰等人配音的TV动画「フェアリーテイル」（妖精的尾巴）演唱的ED曲，完整版PV已释出！”,11
@property (nonatomic,strong)NSString *desc;
//
//"artists": [
//            
//{
//    "artistId": 33686,
//    "artistName": "SOLIDEMO"
//}
//            ],

@property (nonatomic,strong)NSString *artistName;
//"artistName": "SOLIDEMO”,11
//"posterPic": "http://img4.yytcdn.com/video/mv/160406/2540502/-M-df0f691c47ea1628db9380dab3d647ff_240x135.jpg",

@property (nonatomic,strong)NSString *thumbnailPic;
@property (nonatomic,strong)NSString *albumImg;
//"thumbnailPic": "http://img4.yytcdn.com/video/mv/160406/2540502/-M-df0f691c47ea1628db9380dab3d647ff_240x135.jpg”,11
//"albumImg": "http://img4.yytcdn.com/video/mv/160406/2540502/-M-df0f691c47ea1628db9380dab3d647ff_640x360.jpg",
@property (nonatomic,strong)NSString *regdate;
//"regdate": "2016-04-06 14:09”,11
//"videoSourceTypeName": "music_video",
@property (nonatomic,strong)NSString *totalViews;
//"totalViews": 202,11播放总次数
@property (nonatomic,strong)NSString *totalPcViews;
//"totalPcViews": 123,11PC端口
@property (nonatomic,strong)NSString * totalMobileViews;
//"totalMobileViews": 79,11移动端
//"totalComments": 3,
@property (nonatomic,strong)NSString *url;
//"url": "http://dd.yinyuetai.com/uploads/videos/common/C8C70153EA30AECA697F643800B47B22.mp4?sc=008483e1978689a1&br=621&rd=Android",
@property (nonatomic,strong)NSString *hdUrl;
//"hdUrl": "http://hc.yinyuetai.com/uploads/videos/common/B7D80153EA0C5917E2F5D4A48111CC56.flv?sc=907f3b4bdff13c61&br=1016&rd=Android”,11 mv
//"uhdUrl": "http://hd.yinyuetai.com/uploads/videos/common/D9AE0153EA30AEE4B83B0567359991FD.flv?sc=6516c1f078054c85&br=1341&rd=Android”,
//"shdUrl": "http://he.yinyuetai.com/uploads/videos/common/8B290153EA30AEDA6C18809965685411.flv?sc=88e572beb1101719&br=1989&rd=Android",
//"videoSize": 25397463,
//"hdVideoSize": 41576986,
//"uhdVideoSize": 54849140,
//"shdVideoSize": 81324990,
@property (nonatomic,strong)NSString *duration;
//"duration": 327,11  总时间
//"status": 200,
//"linkId": 0,
//"playListPic": "http://img4.yytcdn.com/video/mv/160406/2540502/-M-df0f691c47ea1628db9380dab3d647ff_240x135.jpg"

@end
