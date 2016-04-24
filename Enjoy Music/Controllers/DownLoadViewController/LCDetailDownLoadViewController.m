//
//  LCDetailDownLoadViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCDetailDownLoadViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface LCDetailDownLoadViewController ()
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerViewController *playerViewController;
@end

@implementation LCDetailDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = self.view.bounds;
    [self.view addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //设置模糊透明度
    effectView.alpha = .97f;
    effectView.userInteractionEnabled = NO;
    
    _playerViewController = [[AVPlayerViewController alloc] init];
    _player = [AVPlayer playerWithURL:_url];
    _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerViewController.player = _player;
    _playerViewController.showsPlaybackControls  =  YES;
    [self.view addSubview:_playerViewController.view];
    [_playerViewController.player play];
    

    
    __weak typeof(self)weakSelf = self;
    [_playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
   }

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
