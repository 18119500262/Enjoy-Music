//
//  LCDownLoadViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCDownLoadViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface LCDownLoadViewController ()<NSURLSessionDownloadDelegate>
@property (nonatomic,strong)UIProgressView *progress;
@property (nonatomic,strong)AVPlayerViewController *playerViewController;
@property (nonatomic,strong)AVPlayer *player;
@end

@implementation LCDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addProgress];
    [self requestData];

}

//添加Progress
- (void)addProgress{
   
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 200, 200, 110)];
    _progress.tintColor = [UIColor whiteColor];
    _progress.progressTintColor = [UIColor blackColor];
    _progress.trackTintColor = [UIColor redColor];
    _progress.progress = 0.0;
    [self.view addSubview:_progress];
}


//请求数据
- (void)requestData{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:queue];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:[NSURL URLWithString:self.url]];
    [task resume];
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *documentsPathMV = [NSString stringWithFormat:@"%@/MV",documentsPath];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPathMV];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[[downloadTask.response URL] lastPathComponent]];
    NSLog(@"%@",fileURL);
//    2016-04-09 17:15:15.374 Enjoy Music[7106:264404] /Users/qianfeng/Library/Developer/CoreSimulator/Devices/ECC47FCB-F575-4028-8617-158310095F1F/data/Containers/Data/Application/79E37D9E-8BCA-4662-B02A-7665A5AB0B8A/Documents/MV
//    2016-04-09 17:15:15.374 Enjoy Music[7106:264404] Users/qianfeng/Library/Developer/CoreSimulator/Devices/ECC47FCB-F575-4028-8617-158310095F1F/data/Containers/Data/Application/79E37D9E-8BCA-4662-B02A-7665A5AB0B8A/Documents/MV
//    2016-04-09 17:15:15.512 Enjoy Music[7106:264404] file:///Users/qianfeng/Library/Developer/CoreSimulator/Devices/ECC47FCB-F575-4028-8617-158310095F1F/data/Containers/Data/Application/79E37D9E-8BCA-4662-B02A-7665A5AB0B8A/Documents/MV/672F0153F8A2ECDFAE282A946D17AFD6.flv
   // 如果该路径下文件已经存在，就要先将其移除，在移动文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:[fileURL path] isDirectory:NULL]) {
//        [fileManager removeItemAtURL:fileURL error:NULL];
//    }
//    
    NSString *path = [NSString stringWithFormat:@"%@",fileURL];
    NSArray *arr = [path componentsSeparatedByString:@"/"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    [userDef setObject:_titleUrl forKey:[arr lastObject]];
    [fileManager moveItemAtURL:location toURL:fileURL error:NULL];
    

//    _playerViewController = [[AVPlayerViewController alloc] init];
//    _player = [AVPlayer playerWithURL:[]];
//    _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
//    _playerViewController.player = _player;
//    _playerViewController.showsPlaybackControls  = YES;
//    [self.view addSubview:_playerViewController.view];
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{

    dispatch_async(dispatch_get_main_queue(), ^{
        self.progress.progress = (float)bytesWritten/(float)totalBytesExpectedToWrite;
    });

}





@end
