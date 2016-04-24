//
//  LCRecomViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRecomViewController.h"
#import "LCRecomTableViewCell.h"
#import "LCRecomMOdel.h"
#import "LCReDetailViewController.h"
#import "LCWebDetailViewController.h"

typedef  NS_ENUM(NSInteger,refreshStatus){
    
    refreshStatusUnkown=0,
    refreshStatusRefresh,
    refreshStatusLoadMore
};

@interface LCRecomViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) NSInteger offset;
@property (nonatomic,assign) refreshStatus status;
@end

@implementation LCRecomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.offset = 0;
    [self createTableView];
    [self loadData];
    [self refresh];
    
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[LCRecomTableViewCell class] forCellReuseIdentifier:@"cell"];
    __weak typeof(self) weakSelf = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
     }];
}

#pragma mark ----- tableViewDelegate ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCRecomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    LCRecomMOdel * model = self.dataSource[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([model.type isEqualToString:@"PLAYLIST"]) {
        cell.typeLabel.text = @"悦单";
        cell.typeLabel.backgroundColor = UIColorRGB(81, 178, 165);
    }
    else {
        cell.typeLabel.text = @"活动";
        cell.typeLabel.backgroundColor = UIColorRGB(221, 86, 117);
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 300;
}
// 点击回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LCRecomMOdel *model = self.dataSource[indexPath.row];
    if ([model.type isEqualToString:@"ACTIVITY"]) {
        
        LCWebDetailViewController *webVC = [[LCWebDetailViewController alloc] init];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        webVC.title = model.title;
        webVC.url = model.url;
    }
    else {
        
        LCReDetailViewController *recomDail = [[LCReDetailViewController alloc] init];
        recomDail.Id = model.Id;
        recomDail.posPic = model.posterPic;
        recomDail.title = model.title;
        recomDail.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:recomDail animated:YES];
    }
}

#pragma mark ------ 数据处理 -----
- (void)refresh {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.status = refreshStatusRefresh;
        [self loadData];
    }];
    self.tableView.header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.status = refreshStatusLoadMore;
        [self loadData];
    }];
    self.tableView.footer = footer;
}
- (void)loadData {
    [self showHUb];
    if (self.status == refreshStatusLoadMore) {
        self.offset +=20;
    }
    else if (self.status == refreshStatusRefresh){
        self.offset = 0;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dic = @{@"offset":@(self.offset)};
   [manager GET:URL(FIRST_URL) parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
       if (self.status == refreshStatusRefresh) {
           
           [self.dataSource removeAllObjects];
       }
       
       for (NSDictionary *dic in responseObject) {
           
           LCRecomMOdel *model = [[LCRecomMOdel alloc] initWithDictionary:dic error:nil];
           if ([model.type isEqualToString:@"PLAYLIST"]||[model.type isEqualToString:@"ACTIVITY"]) {
               [self.dataSource addObject:model];
               [self.tableView reloadData];
           }
       }
       [self hidenHUb];
       [self.tableView.header endRefreshing];
       [self.tableView.footer endRefreshing];
   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       NSLog(@"%@",error);
       [self hidenHUb];
       [self.tableView.header endRefreshing];
       [self.tableView.footer endRefreshing];
   }];
}
#pragma  mark ----- 懒加载 -------
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


@end
