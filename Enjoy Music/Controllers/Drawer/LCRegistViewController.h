//
//  LCRegistViewController.h
//  Enjoy Music
//
//  Created by qianfeng on 16/4/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCRegistViewController : UIViewController

@property (nonatomic,copy) void (^userBlock)(NSString *userName);
@end