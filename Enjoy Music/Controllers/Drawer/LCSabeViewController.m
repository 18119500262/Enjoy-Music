//
//  LCSabeViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCSabeViewController.h"
#import "LCDetailDownLoadViewController.h"

@interface LCSabeViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation LCSabeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收藏";
    [self createEff];
    [self creatTableView];
    self.navigationController.navigationBar.translucent = NO;
}

// 添加蒙版
- (void)createEff{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"saveBack.jpg"];
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

#pragma mark --  TableView 相关
-(void)creatTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

#pragma mark ---- tableView的协议方法 -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    BmobObject *object = self.dataSource[indexPath.row];

    cell.textLabel.text = [object objectForKey:@"title"];
    cell.detailTextLabel.text = [object objectForKey:@"artistName"];
    BmobFile *file = (BmobFile*)[object objectForKey:@"image"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:file.url]];
    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = image;
    return cell;
}
// 点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobObject *object = self.dataSource[indexPath.row];
    LCDetailDownLoadViewController *down = [[LCDetailDownLoadViewController alloc] init];
    NSString *url = [object objectForKey:@"url"];
    NSURL *newUrl = [NSURL URLWithString:url];
    down.url = newUrl;
    down.title = [object objectForKey:@"title"];
    [self.navigationController pushViewController:down animated:YES];
}
// cell的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
// 删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BmobObject *object = self.dataSource[indexPath.row];
    [object deleteInBackgroundWithBlock:nil];
    [self.dataSource removeObject:object];
    [self.tableView reloadData];
}
// 设置删除标题
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

#pragma mark ---- 懒加载 -----
- (NSMutableArray *)dataSource {
    BmobUser *user = [BmobUser getCurrentUser];
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        if (user) {
            BmobQuery *bQuery = [BmobQuery queryWithClassName:@"userSave"];
            [bQuery whereKey:@"userName" equalTo:user.username];
            [bQuery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                [_dataSource addObjectsFromArray:array];
                
                [self.tableView reloadData];
            }];
        }
        
    }
    return _dataSource;
}




@end
