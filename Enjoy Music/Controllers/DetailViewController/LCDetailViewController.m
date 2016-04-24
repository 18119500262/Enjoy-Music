//
//  LCDetailViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/6.
//  Copyright © 2016年 qianfeng. All rights reserved.
//
#define Detail @"http://mapi.yinyuetai.com/video/show.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D&relatedVideos=true&supportHtml=false&v=2"
#import "LCDetailViewController.h"
#import "AxcSegmentedView.h"
#import "LCSBModel.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "LCXGMVTableViewCell.h"
#import "UMSocial.h"
#import "DownLoadViewController.h"
#import "LCButton.h"
#import "LCLoginViewController.h"
//MV首播，流行  的二级界面  继承自UIViewController
@interface LCDetailViewController ()<AxcSegmentedViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *imageView;
}
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerViewController *playerViewController;
@property (nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)AxcSegmentedView *segmentedView;
@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    加标题
    self.title = _model.title;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.alpha = 0.97;
//    [self setNavigationBar];
  
    //    加播放器
    [self addplayer];
    
    // 加背景图片
    [self addImageView];
    
    [self addSegment];
    
//    加视图
    [self addViews];
    
//    添加toolbar
    [self addToolBar];
}

    // 加背景图片
- (void)addImageView {
    //    加背景图片
    imageView = [[UIImageView alloc] init];
    //                 WithFrame:CGRectMake(0, 64  + SRC_H/2 - 114, SRC_W, SRC_H/2 +114)];
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.albumImg]];
    [self.view addSubview:imageView];
    
    __weak typeof(self)weakSelf = self;
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@220);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        
}];
  //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame = imageView.bounds;
    [imageView addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
    //设置模糊透明度
    effectView.alpha = .97f;
    effectView.userInteractionEnabled = NO;
}


- (void)viewWillAppear:(BOOL)animated{

 self.navigationController.toolbarHidden=NO;
}
- (void)addToolBar{
    self.navigationController.toolbar.hidden = NO;
   [self.navigationController.toolbar setBackgroundImage:nil forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    self.navigationController.toolbar.alpha = 0.97f;

    
    //重点是设置上面的按钮这些
    //和设置navigationBarItem类似
    //先设置一个UIBarButtonItem，然后组成数组，然后把这个数组赋值给self.toolbarItems
    LCButton *button1 = [[LCButton alloc] initWithFrame:CGRectMake(0, 0,40, 44)];
    [button1 setTitle:@"收藏" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    button1.titleLabel.font = [UIFont systemFontOfSize:14];
    [button1 setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    UIBarButtonItem *btn1=[[UIBarButtonItem alloc] initWithCustomView:button1];
    
    LCButton *button2 = [[LCButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [button2 setTitle:@"下载" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
     button2.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *btn2=[[UIBarButtonItem alloc] initWithCustomView:button2];
    
    LCButton *button3 = [[LCButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [button3 setTitle:@"分享" forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"3"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
     button3.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *btn3=[[UIBarButtonItem alloc]initWithCustomView:button3];
    
    UIBarButtonItem *btn4=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSArray *arr1=[[NSArray alloc]initWithObjects:btn4,btn1,btn4,btn2,btn4,btn3,btn4, nil];
    self.toolbarItems=arr1;
}

//收藏
- (void)save{

    BmobUser *bUser = [BmobUser getCurrentUser];
    if (!bUser) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LCLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"logincontroller"];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
    else {
        BmobQuery *bQuery = [BmobQuery queryWithClassName:@"userSave"];
        [bQuery whereKey:@"title" equalTo:self.model.title];
        [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count<=0) {
                [self saveAction:bUser];
            }
            else {
                [Auxiliary alertWithTitle:@"已收藏" message:nil button:1 done:nil];
            }
        }];
    }


}

- (void)saveAction:(BmobUser *)bUser {
    BmobObject *saveModel = [BmobObject objectWithClassName:@"userSave"];
    [saveModel setObject:bUser.username forKey:@"userName"];
    [saveModel setObject:self.model.title forKey:@"title"];
    [saveModel setObject:self.model.artistName forKey:@"artistName"];
    [saveModel setObject:self.model.hdUrl forKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:self.model.albumImg];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    NSData * data =  UIImagePNGRepresentation(image);
    
    BmobFile * file1 = [[BmobFile alloc] initWithClassName:@"userName"withFileName:@"image.db" withFileData:data];
    // 异步保存文件
    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            [saveModel setObject:file1  forKey:@"image"];
            // 异步保存到数据库
            [saveModel saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [Auxiliary alertWithTitle:@"收藏成功" message:nil button:1 done:nil];
                }else {
                    NSLog(@"%@",error);
                }
            }];
        }else{
            NSLog(@"%@",error);
        }
    }];
}

//下载
- (void)download{
    DownLoadViewController * down = [DownLoadViewController downLoadWithUrl:self.model.url];
    down.backimg = self.model.albumImg;
    down.titleUrl = [NSString stringWithFormat:@"%@-%@",_model.title,_model.artistName];
    [self.navigationController pushViewController:down animated:YES];
    
}

//分享
- (void)share{
 [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGAPPKEY shareText:[NSString stringWithFormat:@"%@\n%@",self.model.title,self.model.hdUrl] shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.albumImg]]] shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToQQ] delegate:nil];
}


 //    加播放器
- (void)addplayer{
    _playerViewController = [[AVPlayerViewController alloc] init];
    _player = [AVPlayer playerWithURL:[NSURL URLWithString:_model.hdUrl]];
    _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerViewController.player = _player;
    _playerViewController.showsPlaybackControls  = YES;
    [self.view addSubview:_playerViewController.view];
    
    __weak typeof(self)weakSelf = self;
    [_playerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0);
        make.height.equalTo(@220);
    }];
    [_playerViewController.player play];
}


- (void)addSegment{
    self.segmentedView = [[AxcSegmentedView alloc]initWithFrame:CGRectMake(50, 5
, SCREENWIDTH/2, 30) titles:@[@"MV描述",@"相关MV"]];
    self.segmentedView.delegate = self;
    [imageView addSubview:self.segmentedView];
    
     __weak typeof(self)weakSelf = self;
    [self.segmentedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_top).with.offset(3);
//        make.top.equalTo(weakSelf.playerViewController.view.mas_bottom).with.offset(3);
        make.width.equalTo(@(SCREENWIDTH/2));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.equalTo(@(30));
       
}];
}

- (void)setNavigationBar{
    //    设置navigationBar微透明
   
    //  创建需要的毛玻璃特效类型
    UIBlurEffect *blurEffects = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃view 视图
    UIVisualEffectView *effectViews = [[UIVisualEffectView alloc] initWithEffect:blurEffects];
    //添加到要有毛玻璃特效的控件中
    effectViews.frame = self.navigationController.navigationBar.bounds;
    //设置模糊透明度
    effectViews.userInteractionEnabled = NO;
    effectViews.alpha = .97f;
    [self.navigationController.navigationBar addSubview:effectViews];



}

- (void)addViews{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30 + 5, SRC_W, SRC_H/2 - 5)];
  
    _scrollView.backgroundColor  = [UIColor clearColor];
    [self.view  addSubview:_scrollView];

    
    //    加下面的view
    UIImageView *artistImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    artistImage.layer.masksToBounds = YES;
    artistImage.layer.cornerRadius = 30;
    [artistImage sd_setImageWithURL:[NSURL URLWithString:_model.albumImg]];
    [_scrollView addSubview:artistImage];
    
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(artistImage.frame), CGRectGetMaxY(artistImage.frame)/2 -20, 200, 40)];
    name.font = [UIFont systemFontOfSize:11];
    name.numberOfLines  = 0;
    name.textColor = [UIColor whiteColor];
    //虽然不能打enter   但是可以打空格
    name.text =  [NSString stringWithFormat:@"艺人：                                                                           %@",_model.artistName];
    [_scrollView addSubview:name];
    
    UILabel *fbTime = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(artistImage.frame)+10, 200, 20)];
    fbTime.font = [UIFont systemFontOfSize:11];
    fbTime.textColor = [UIColor whiteColor];
    fbTime.text = [NSString stringWithFormat:@"发布时间：%@",_model.regdate];
    [_scrollView addSubview:fbTime];
    
    //播放总次数
    UILabel *totalViews = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(fbTime.frame)+10, SRC_W/3, 20)];
    totalViews.font = [UIFont systemFontOfSize:11];
    totalViews.textColor = [UIColor whiteColor];
    totalViews.text = [NSString stringWithFormat:@"播放总次数：%@",_model.totalViews];
    [_scrollView addSubview:totalViews];
    
    //pC 端
    UILabel *totalPcViews = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalViews.frame), CGRectGetMaxY(fbTime.frame)+10, SRC_W/3, 20)];
    totalPcViews.font = [UIFont systemFontOfSize:11];
     totalPcViews.textColor = [UIColor whiteColor];
    totalPcViews.text = [NSString stringWithFormat:@"PC端：%@",_model.totalPcViews];
    [_scrollView addSubview:totalPcViews];
    
    //    totalMobileViews
    UILabel *totalMobileViews = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalPcViews.frame), CGRectGetMaxY(fbTime.frame)+10, SRC_W/3, 20)];
    totalMobileViews.font = [UIFont systemFontOfSize:11];
    totalMobileViews.text = [NSString stringWithFormat:@"移动端：%@",_model.totalMobileViews];
     totalMobileViews.textColor = [UIColor whiteColor];
    [_scrollView addSubview:totalMobileViews];
    
    //    desc
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(totalPcViews.frame)+10, SRC_W - 20, 200)];
    CGFloat height = [_model.desc  boundingRectWithSize:CGSizeMake(desc.frame.size.width, FLT_MAX) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
    CGRect frame = desc.frame;
    frame.size.height = height;
    desc.frame = frame;
    desc.font = [UIFont systemFontOfSize:13];
    desc.numberOfLines  = 0;
    desc.text = [NSString stringWithFormat:@"%@",_model.desc];
    desc.textColor = [UIColor whiteColor];
    [_scrollView addSubview:desc];
   __weak typeof(self)weakSelf = self;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.segmentedView.mas_bottom).with.offset(5);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-44);
        
    }];
    _scrollView.contentSize = CGSizeMake(SRC_W, CGRectGetMaxY(desc.frame));
}


#pragma mark --------TableView------
- (void)addTableView{
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0,64  + SRC_H/2 - 114+ 30 + 5 +5, SRC_W, SRC_H/2 - 5 -5 ) style:UITableViewStylePlain];
   
    self.tabelView.dataSource = self;
    self.tabelView.delegate = self;
    self.tabelView.backgroundColor = [UIColor clearColor];
    self.tabelView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tabelView];
    
  __weak typeof(self)weakSelf = self;
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0);
        make.top.equalTo(weakSelf.segmentedView.mas_bottom).with.offset(5);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-44);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSource.count;
}
- (void)reloadData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:Detail parameters:@{@"id":_model.ID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.dataSource addObjectsFromArray:[LCSBModel arrayOfModelsFromDictionaries:responseObject[@"relatedVideos"]]];
        [self.tabelView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *ID = @"xg";
    LCXGMVTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"LCXGMVTableViewCell" owner:self options:nil].firstObject;
    }
    cell.model = self.dataSource[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.playerViewController.view removeFromSuperview];
    LCSBModel *model = self.dataSource[indexPath.row];
    _model = model;
//    _model.hdUrl = model.hdUrl;
    [self addplayer];
}

#pragma mark --------- AxcSegmentedView----
- (void)axcSegmentedView:(AxcSegmentedView *)XSSegmentedView selectTitleInteger:(NSInteger)integer{
    
    if (integer == 0) {
        [self.scrollView removeFromSuperview];
        [self.tabelView removeFromSuperview];
        [self addViews];
     }else{
        [self.scrollView removeFromSuperview];
        [self reloadData];
        [self addTableView];
    }

 }

//是否可点击
- (BOOL)axcSegmentedView:(AxcSegmentedView *)XSSegmentedView didSelectTitleInteger:(NSInteger)integer{
    return YES;
}

- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
