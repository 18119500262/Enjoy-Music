//
//  AppDelegate.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "AppDelegate.h"
#import "LCTabBarController.h"
#import "UMSocial.h" //友盟分享
#import "UMSocialWechatHandler.h" //微信分享

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //1.实例化一个window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //2.可见
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self rootWindow];
    
    
//    友盟初始化
    [self UmentInit];
    
    // 注册Bmob云
    [Bmob registerWithAppKey:SDKKEY];
//    设置navicationbar的颜色
    [self setNavicationBar];
    return YES;
}


- (void)setNavicationBar{
    UINavigationBar *bar = [UINavigationBar appearance];
    bar.barStyle = UIBarStyleBlack;
    bar.alpha = 0.97;
    bar.barTintColor = [UIColor colorWithRed:37/255.f green:180/255.f blue:250/255.f alpha:1];
    bar.tintColor = [UIColor whiteColor];
}

- (void)rootWindow {
    
    LCTabBarController *tab = [[LCTabBarController alloc] init];
    self.window.rootViewController = tab;
    [tab addWithClassName:@"LCRecomViewController" withTitle:@"首页" withImage:@"SYG" withHightImage:@"SYL"];
    [tab addWithClassName:@"LCFirstViewController" withTitle:@"MV" withImage:@"MVG" withHightImage:@"MVL"];
    [tab addWithClassName:@"LCPopuViewController" withTitle:@"流行" withImage:@"LXG" withHightImage:@"LXL"];
   
    
    

}
//you
-(void) UmentInit{
    //初始化友盟社会化组件
    [UMSocialData setAppKey:UMENGAPPKEY];
    
    //初始化微信
    [UMSocialWechatHandler setWXAppId:@"wxe6b5b748cdcff60f" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.umeng.com/social"];
    //隐藏没有安装客户端的平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToWechatSession,UMShareToWechatTimeline]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
