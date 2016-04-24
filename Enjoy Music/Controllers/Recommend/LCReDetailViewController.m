//
//  LCReDetailViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCReDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "LCListModel.h"
#import "LCRecomDetaiModel.h"
#import "LCReDesCell.h"
#import "AxcSegmentedView.h"
#import "LCListCell.h"
#import "LCButton.h"
#import "DownLoadViewController.h"
#import "UMSocial.h"
#import "LCLoginViewController.h"

typedef NS_ENUM(NSInteger,segStatus) {
    
    segStatusZero=0,
    segStatusOne
};

@interface LCReDetailViewController ()<UITableViewDataSource,UITableViewDelegate,AxcSegmentedViewDelegate>

@property (nonatomic,strong) AVPlayerViewController *playerController;
@property (nonatomic,strong) AVPlayer *avPlayer;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *listData;
@property (nonatomic,strong) NSArray *desData;
@property (nonatomic,strong) NSMutableArray *conmentData;
@property (nonatomic,strong) AxcSegmentedView *seg;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *modelTitle;
@property (nonatomic,copy) NSString *artistName;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,assign) segStatus status;


@end

@implementation LCReDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    [self toolBarItem];
    [self mvPlayer:@""];
    [self createEffect];
    
    [self addSegment];
    [self createTableView];
    [self loadData];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
}
// toolBarItems
- (void)toolBarItem {

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

#pragma mark ------ ToolBar的Action ------
// 收藏
- (void)save {
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (!bUser) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LCLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"logincontroller"];
        login.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:login animated:YES];
    }
    else {
        BmobQuery *bQuery = [BmobQuery queryWithClassName:@"userSave"];
        [bQuery whereKey:@"title" equalTo:self.modelTitle];
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
    [saveModel setObject:self.modelTitle forKey:@"title"];
    [saveModel setObject:self.artistName forKey:@"artistName"];
    [saveModel setObject:self.url forKey:@"url"];
    
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    NSData * data =  UIImagePNGRepresentation(image);
    
    BmobFile * file1 = [[BmobFile alloc] initWithClassName:@"userSave"withFileName:@"image.db" withFileData:data];
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

// 下载
- (void)download {
   
    DownLoadViewController * down = [DownLoadViewController downLoadWithUrl:self.url];
    down.titleUrl = [NSString stringWithFormat:@"%@-%@",self.modelTitle,self.artistName];
    [self.navigationController pushViewController:down animated:YES];
}
// 分享
- (void)share {
    NSString *titleAndUrl = [NSString stringWithFormat:@"%@/n%@",self.modelTitle,self.url];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGAPPKEY shareText:titleAndUrl shareImage:image shareToSnsNames:@[UMShareToSina,UMShareToWechatSession,UMShareToQQ] delegate:nil];
    
}

// 蒙玻璃特效
- (void)createEffect {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.posPic]];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.equalTo(self.view);
    }];
    
    // 蒙版特效
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 蒙版视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = imageView.bounds;
    [imageView addSubview:effectView];
    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageView);
    }];
}

- (void)mvPlayer:(NSString*)url {
    
    _playerController = [[AVPlayerViewController alloc] init];

    _playerController.showsPlaybackControls = YES;
    _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view addSubview:_playerController.view];
    // 自动布局
    [_playerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@220);
    }];
    
        NSURL *avUrl = [NSURL URLWithString:url];
        _avPlayer = [AVPlayer playerWithURL:avUrl];
        _playerController.player = _avPlayer;
        [_playerController.player play];
}

// 多段选择器
- (void)addSegment {
    
    self.seg = [[AxcSegmentedView alloc] initWithFrame:CGRectMake(SCREENWIDTH/4, 310, SCREENWIDTH/2,30) titles:@[@"悦单描述",@"悦单列表"]];
    self.seg.delegate = self;
    [self.view addSubview:self.seg];
    [self.seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.playerController.view.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(SCREENWIDTH/2));
        make.height.equalTo(@30);
    }];
}

#pragma mark ----- seg的协议方法 ------
// 点击回调
- (void)axcSegmentedView:(AxcSegmentedView *)XSSegmentedView selectTitleInteger:(NSInteger)integer{
    if (integer == 0) {
        self.status = segStatusZero;
    }
    else if (integer == 1){
        self.status = segStatusOne;
    }
    [self.tableView reloadData];
}
// 是否可选
- (BOOL)axcSegmentedView:(AxcSegmentedView *)XSSegmentedView didSelectTitleInteger:(NSInteger)integer{
    
    return YES;
}

// 创建tableView、
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UINib *nib = [UINib nibWithNibName:@"LCReDesCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"nibCell"];
    
    UINib *listNib = [UINib nibWithNibName:@"LCListCell" bundle:nil];
    [self.tableView registerNib:listNib forCellReuseIdentifier:@"listCell"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.seg.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark ---- tableView的协议方法 ----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.status == segStatusZero) {
        return 1;
    }
    else {
        return self.listData.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.status == segStatusZero) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        LCReDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nibCell"];
         LCRecomDetaiModel *model = self.desData[indexPath.row];
         cell.model = model;
        return cell;
    }
    else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        LCListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell"];
        cell.model = self.listData[indexPath.row];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.status == segStatusZero) {
        LCReDesCell *cell = (LCReDesCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
    else {
        return 90;
    }
}

// 点击回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.status == segStatusOne) {
        [self.playerController.view removeFromSuperview];
        LCListModel *model = self.listData[indexPath.row];
        
        [self mvPlayer:model.hdUrl];
        self.url = model.url;
        self.modelTitle = model.title;
        self.artistName = model.artistName;
        self.imageUrl = model.playListPic;
    }
}


#pragma mark --- 数据处理 ----
- (void)loadData {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:FIRST_DETAIL parameters:@{@"id":self.Id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 悦单描述
        LCRecomDetaiModel *desModel = [[LCRecomDetaiModel alloc] initWithDictionary:responseObject error:nil];
        desModel.nickName = responseObject[@"creator"][@"nickName"];
        self.desData = @[desModel];
        
        // 悦单列表
        NSArray *list = responseObject[@"videos"];
        [self.listData addObjectsFromArray:[LCListModel arrayOfModelsFromDictionaries:list]];
        LCListModel *model = self.listData[0];
        [self mvPlayer:model.hdUrl];
        self.url = model.url;
        self.modelTitle = model.title;
        self.artistName = model.artistName;
        self.imageUrl = model.playListPic;
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

#pragma mark ---- 懒加载 ------
- (NSMutableArray *)listData {
    
    if (!_listData) {
        
        _listData = [[NSMutableArray alloc] init];
    }
    return _listData;
}

- (NSMutableArray *)conmentData {
    
    if (!_conmentData) {
        _conmentData = [[NSMutableArray alloc] init];
    }
    return _conmentData;
}







@end
