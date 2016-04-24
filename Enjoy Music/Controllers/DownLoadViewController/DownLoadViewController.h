//
//  DownLoadViewController.h
//  Enjoy the sound
//
//  Created by qianfeng on 16/3/11.
//  Copyright © 2016年 Strong delegation. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

@interface DownLoadViewController : UIViewController
@property (nonatomic,strong)NSString *backimg;

+ (DownLoadViewController *)downLoadWithUrl:(NSString *)downUrl;


/**
 *  传递url
 *
 *  @param url 字符串类型的url
 *
 *  @return 自身
 */
- (instancetype)initWithUrl:(NSString *)url;



- (void)starDownLoadMask:(NSString *)downurl;


@property(nonatomic,strong)NSString *titleUrl;


+ (DownLoadViewController *)pushDownLoad;


@end
