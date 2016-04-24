//
//  LCTabBarController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCTabBarController.h"
#import "LCScolViewController.h"
#import "LCFirstViewController.h"
#import "LCPopuViewController.h"

@interface LCTabBarController ()

@end

@implementation LCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)addWithClassName:(NSString *)className withTitle:(NSString *)title withImage:(NSString *)imageName withHightImage:(NSString *)hightImage {
   
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    
    if ([vc isKindOfClass:[LCScolViewController class]]) {
        LCScolViewController *scolVc = (LCScolViewController *)vc;
        if ([scolVc  isKindOfClass:[LCFirstViewController class]]) {
            
            scolVc.url = SHOUBO;
            scolVc.scrollUrl = MVSBSCROLL;
        }
         else if ( [scolVc isKindOfClass:[LCPopuViewController class]] ){
            scolVc.url = POPULAR;
            scolVc.i = 1;
            scolVc.scrollUrl = MVSBSCROLL;
        }
                vc = scolVc;
    }
    
    
    
    vc.title = title;
    
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:hightImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    vc.tabBarItem = item;
    [self addChildViewController:naVC];
}




@end
