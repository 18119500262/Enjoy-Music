//
//  DownLoadViewController.m
//  Enjoy the sound
//
//  Created by qianfeng on 16/3/11.
//  Copyright © 2016年 Strong delegation. All rights reserved.
//

#import "DownLoadViewController.h"
#import "LCDetailDownLoadViewController.h"


@interface DownLoadViewController ()<NSURLSessionDownloadDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSString *downLoadurl;
    NSURLSession *_session;
    NSURLSessionDownloadTask *_downloadTask;
    UIProgressView *_progressView;
    NSArray *_arrayM;
    UILabel *label;
    NSMutableArray *_titleArratM;
    BOOL _bol;
    UIView *view;
    NSURL *fileURL;
    NSURL *documentsDirectoryURL;
    UIButton *btn;
}

@end

static DownLoadViewController *_downLoad;

@implementation DownLoadViewController

+ (DownLoadViewController *)downLoadWithUrl:(NSString *)downUrl{
    
    if (_downLoad == nil) {
        _downLoad  = [[DownLoadViewController alloc]initWithUrl:downUrl];
    }else{
        [_downLoad starDownLoadMask:downUrl];
    }
    return _downLoad;
}

- (instancetype)initWithUrl:(NSString *)url{
    if (self = [super init]) {
        downLoadurl = url;
        [self starDownLoadMask:url];
    }

    return self;
}

- (void)starDownLoadMask:(NSString *)path{
    
    [self downLoadFileDUANWithPath:path];
}


- (void)downLoadFileDUANWithPath:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path];
    
    // 使用硬盘来缓存数据（程序退出，缓存的数据还存在）
    NSURLSessionConfiguration *configurgation = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 队列
    NSOperationQueue *queueB = [[NSOperationQueue alloc] init];
    
    // 设置会话的属性
    _session = [NSURLSession sessionWithConfiguration:configurgation delegate:self delegateQueue:queueB];
    // 设置下载任务(如果要让代理参与监控下载进度，不能指定完成后代码块的回调)
    _downloadTask = [_session downloadTaskWithURL:url];
    
    // 启动任务
     [_downloadTask resume];
}



+ (DownLoadViewController *)pushDownLoad{
    if (_downLoad == nil) {
        _downLoad  = [[DownLoadViewController alloc]init];
    }
    return _downLoad;
}

- (void)setTitleUrl:(NSString *)titleUrl{
    _titleUrl = titleUrl;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSString *str in _arrayM) {
        [arr addObject:[[NSUserDefaults standardUserDefaults] objectForKey:str]];
    }
    for (NSString *str in arr) {
        if ([str isEqualToString:_titleUrl]) {
         
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知" message:@"你已经下载过该MV了，是否覆盖？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
            [_downloadTask suspend];

         }
        
    }
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.backimg]]]];
    if(!self.backimg){
      self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5.jpg"]];
    }
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
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.toolbarHidden = YES;
    [self addData];
    _bol = NO;
    if (!_tableView) {
        [self creatUI];
    }
    [self addProgressViewToView];
    
    self.title = @"我的下载";
}

- (void)viewWillDisappear:(BOOL)animated{
    [UIView animateWithDuration:0.25 animations:^{
        _progressView.transform = CGAffineTransformMakeTranslation(SRC_W, 0);
    }completion:^(BOOL finished) {
        [_progressView removeFromSuperview];
    }];
    [label removeFromSuperview];
    [btn removeFromSuperview];
}

- (void)addData{
    _arrayM= [NSArray array];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/MV",NSHomeDirectory()];
    
    // 创建文件夹
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    
    _arrayM = [fileManager contentsOfDirectoryAtPath:path error:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
        
    });
    
}

- (void)creatUI{
    
    _tableView  = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80;
    _tableView.backgroundColor = [UIColor clearColor];
    view = [[UIView alloc]init];
    _tableView.tableFooterView = view;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) WeakSelf = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(WeakSelf.view.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.view.mas_left).offset(0);
        make.right.mas_equalTo(WeakSelf.view.mas_right).offset(0);
        make.bottom.mas_equalTo(WeakSelf.view.mas_bottom).offset(0);
        
    }];
    
    

    
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cc"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cc"];
    }
    cell.textLabel.text = [[NSUserDefaults standardUserDefaults]objectForKey:_arrayM[indexPath.row]];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    NSString *documentsPathMV = [NSString stringWithFormat:@"%@/MV/%@",documentsPath,_arrayM[indexPath.row]];
    
    NSURL *url = [NSURL fileURLWithPath:documentsPathMV];
    NSLog(@"%@",url);

    LCDetailDownLoadViewController *detail = [[LCDetailDownLoadViewController alloc] init];
    detail.title = [[NSUserDefaults standardUserDefaults]objectForKey:_arrayM[indexPath.row]];
    detail.url = url;
    [self.navigationController pushViewController:detail animated:YES];
}




#pragma mark - 实现NSURLSessionDownloadDelegate
#pragma mark 任务下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    // 设置文件的存放目标路径
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *documentsPathMV = [NSString stringWithFormat:@"%@/MV",documentsPath];
    documentsDirectoryURL = [NSURL fileURLWithPath:documentsPathMV];
    fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[[downloadTask.response URL] lastPathComponent]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
     if ([fileManager fileExistsAtPath:[fileURL path] isDirectory:NULL]) {
         [fileManager removeItemAtURL:fileURL error:NULL];
     }
     NSString *path = [NSString stringWithFormat:@"%@",fileURL];
    NSArray  *arr = [path componentsSeparatedByString:@"/"];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:_titleUrl forKey:[arr lastObject]];
    
    [fileManager moveItemAtURL:location toURL:fileURL error:NULL];

    [self addData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        label.text = @"下载完成";

     });
}


#pragma mark 下载进度
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
//    NSLog(@"已经下载%lld--总共大小%lld",totalBytesWritten,totalBytesExpectedToWrite);
    // 计算百分比
    CGFloat precent = (CGFloat)totalBytesWritten / (CGFloat )totalBytesExpectedToWrite;
    
    // 更新UI 在主线程
    dispatch_async(dispatch_get_main_queue(), ^{

        _progressView.progress = precent;
        
        label.text = [NSString stringWithFormat:@"%.1f %%",precent*100];
    });
}

- (void)addProgressViewToView{
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(10, 37, SRC_W-140, 10)];
    // 设置颜色
    _progressView.progressTintColor = [UIColor whiteColor];
    _progressView.trackTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(SRC_W - 110, 10, 70, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:15];
    
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(SRC_W - 70, 30, 70, 30)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"正在下载" forState:UIControlStateNormal];
    UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItems = @[btnItem,labelItem];
    
}

#pragma  mark 2.允许cell编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark 3.设置编辑样式
- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark 4.提交编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 从数据源中删除数据
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *documentsPathMV = [NSString stringWithFormat:@"%@/MV/%@",documentsPath,_arrayM[indexPath.row]];
        [fileManager removeItemAtPath:documentsPathMV error:nil];
        
        NSUserDefaults *uu = [NSUserDefaults standardUserDefaults];
        [uu removeObjectForKey:_arrayM[indexPath.row]];
        
//        NSMutableArray *arr = [NSMutableArray arrayWithArray:_titleArratM];
//        [arr removeObjectAtIndex:indexPath.row];
//        _titleArratM = arr;
        NSMutableArray *a = [NSMutableArray arrayWithArray:_arrayM];
        [a removeObjectAtIndex:indexPath.row];
        _arrayM = a;
        // 提交并刷新列表
        [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self.navigationController popViewControllerAnimated:YES];
        [_downloadTask suspend];
    }else{
        [_downloadTask resume];
    }
}


- (void)clickBtn:(UIButton *)sender{
    if (!_bol) {
        [_downloadTask suspend];
        [sender setTitle:@"已经停止" forState:UIControlStateNormal];
        _bol = YES;
    }else{
        [_downloadTask resume];
        [sender setTitle:@"正在下载" forState:UIControlStateNormal];
        _bol = NO;
    }
}

@end
    


