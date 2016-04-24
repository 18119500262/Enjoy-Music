//
//  LCRootViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRootViewController.h"
#import "MBProgressHUD.h"
#import "LCSabeViewController.h"
#import "DownLoadViewController.h"
#import "LCLoginViewController.h"

@interface LCRootViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
// 下载进度视图
@property (nonatomic,strong) MBProgressHUD *hub;
@property (nonatomic,strong) RESideMenu *sideMenu;
@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UIImagePickerController *picker;

@end


@implementation LCRootViewController
{
    UIImageView *_imageView;
    UIButton *_loginButton;
    UIButton *_registButton;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(leftAction:)];
    [self createPicker];
    
}
- (void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:YES];
[self.navigationItem.leftBarButtonItem setEnabled:YES];
  self.navigationController.toolbarHidden = YES;
}
- (void)createPicker {
    
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
}

// navigation 的左Item
- (void)leftAction:(UIBarButtonItem *)leftItem {
    
    [leftItem setEnabled:NO];
    RESideMenuItem *item0 = [[RESideMenuItem alloc] initWithTitle:@"首页" image:nil highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
        [self.sideMenu hide];
        [leftItem setEnabled:YES];
    }];
    RESideMenuItem *item1 = [[RESideMenuItem alloc] initWithTitle:@"下载" image:nil highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
        
            DownLoadViewController *loadVC = [[DownLoadViewController alloc] init];
            loadVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loadVC animated:YES];
             [self.sideMenu hide];
        [leftItem setEnabled:YES];
    }];
    RESideMenuItem *item2 = [[RESideMenuItem alloc] initWithTitle:@"收藏" image:nil highlightedImage:nil action:^(RESideMenu *menu, RESideMenuItem *item) {
        BmobUser *user = [BmobUser getCurrentUser];
        if (user) {
            
            LCSabeViewController *save = [[LCSabeViewController alloc] init];
            save.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:save animated:YES];
        }else {
            [self jupLogin];
        }
        [self.sideMenu hide];
        [leftItem setEnabled:YES];
    }];
    
    
    self.sideMenu = [[RESideMenu alloc] initWithItems:@[item0,item1,item2]];
    self.sideMenu.tapBlock = ^(BOOL isShow){
        if (isShow) {
            [leftItem setEnabled:YES];
        }
    };
    self.sideMenu.headerView = self.header;

    [self.sideMenu show];
    
    if (self.sideMenu.isShowing) {
         [leftItem setEnabled:NO];
        [self getCurrentUser];
    }
}
- (void)getCurrentUser {
    // 获取当前用户
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        // 用户存在
        NSString *user = [NSString stringWithFormat:@"%@",bUser.username];
        [_loginButton setTitle:user forState:UIControlStateNormal];
        if (@selector(settingAction:)) {
         [_loginButton removeTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_loginButton addTarget:self action:@selector(outAction:) forControlEvents:UIControlEventTouchUpInside];
       
        //查询当前用户的类
        BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:bUser.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            
            BmobObject *object = array[0];
            BmobFile *file = (BmobFile *)[object objectForKey:@"userImage"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.url]];
            if (!data) {
                _imageView.image = [UIImage imageNamed:@"music.jpg"];
            }else{
            _imageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    else {
        //用户不存在
        [_loginButton setTitle:@"个人设置" forState:UIControlStateNormal];
        if (@selector(outAction:)) {
           
            [_loginButton removeTarget:self action:@selector(outAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [_loginButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
        _imageView.image = [UIImage imageNamed:@"music.jpg"];
    }
}
// 显示下载进度
- (void)showHUb {
    [self.hub show:YES];
}
// 隐藏下载进度
- (void)hidenHUb {
    [self.hub hide:YES];
}
// 当前时间
- (NSString *)date {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:date];
}

#pragma  mark ---- 懒加载 -----
// 下载进度视图
- (MBProgressHUD *)hub {
    if (!_hub) {
        
        _hub = [[MBProgressHUD alloc] initWithView:self.view];
        _hub.labelText = @"加载中";
        [self.view addSubview:_hub];
    }
    return _hub;
}

// 抽屉头视图
- (UIView *)header {
    
    if (!_header) {
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 150)];
        [self imageView];
        [self settingButton];
    }
    return _header;
}

// 头像
- (void)imageView {
    
       _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"music.jpg"]];
     [self.header addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.header.mas_centerY);
        make.left.equalTo(self.header.mas_left).with.offset(30);
        make.height.equalTo(@60);
        make.width.equalTo(@60);
    }];
    _imageView.layer.cornerRadius = 30;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [_imageView addGestureRecognizer:tap];
}
// 头像的触发事件
- (void)tapAction:(UITapGestureRecognizer *)tap{
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (bUser) {
        
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle: UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        
        __weak typeof(self) weakSelf = self;
        UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [weakSelf presentViewController:weakSelf.picker animated:YES completion:nil];
        }];
        [alert addAction:photo];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
                weakSelf.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [weakSelf presentViewController:weakSelf.picker animated:YES completion:nil];
            }
        }];
        [alert addAction:camera];
        [alert addAction:cancel];
    [self.sideMenu hide];
        [self presentViewController:alert animated:YES completion:nil];

    }else {
        [self.sideMenu hide];
        [self jupLogin];
    
    }
 }

#pragma mark ---- picker的协议方法 -----

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
   
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    _imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
     [self.sideMenu show];
    [self saveImage:image];
}
/** 保存用户头像 */
- (void)saveImage:(UIImage *)image {
    BmobUser *user = [BmobUser getCurrentUser];
    NSString *imageFile = [NSString stringWithFormat:@"%@image.db",user.username];
    if (user) {
        BmobQuery *query = [BmobQuery queryWithClassName:@"_User"];
        [query whereKey:@"username" equalTo:user.username];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobObject *object = array[0];
            
            NSData *data = UIImagePNGRepresentation(image);
            BmobFile *file = [[BmobFile alloc] initWithClassName:@"_User" withFileName:imageFile withFileData:data];
            [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                   
                    [object setObject:file forKey:@"userImage"];
                    [object updateInBackground];
                }
            }];
        }];
    }
}

// 登录按钮
- (void)settingButton {
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.header addSubview:_loginButton];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_loginButton setBackgroundColor:[UIColor blackColor]];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    _loginButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _loginButton.layer.cornerRadius = 5;

    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView.mas_right);
        make.centerY.equalTo(self.header.mas_centerY);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
    }];
    
}


// 设置按钮触发的事件
- (void)settingAction:(UIButton *)button {
    
    [self jupLogin];
    [self.sideMenu hide];
}

// 退出登录
- (void)outAction:(UIButton *)button {
    
    [Auxiliary alertWithTitle:@"退出登录?" message:nil button:2 done:^{
        [self jupLogin];
        [self.sideMenu hide];
        // 清楚缓存用户对象
        [BmobUser logout];
    }];
}

/** 用户不存在调到登录界面 */
- (void)jupLogin {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LCLoginViewController *login = [storyboard instantiateViewControllerWithIdentifier:@"logincontroller"];
    login.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:login animated:YES];
    
}
@end
