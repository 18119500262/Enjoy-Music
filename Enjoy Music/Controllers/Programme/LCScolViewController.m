//
//  LCProgrammeViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//
//后面四个tabbar 继承自改viewcontroller
#import "LCScolViewController.h"
#import "LCSBModel.h"
#import "LCSBTableViewCell.h"
#import "LCDetailViewController.h"
//MV首页(scrollView)
#define MVSBSCROLL @"http://mapi.yinyuetai.com/video/get_mv_areas.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D"
//MV首播 的网址 有日期  和area  eg:日本
#define  SHOUBO @"http://mapi.yinyuetai.com/video/list.json?deviceinfo=%7B%22aid%22%3A%2210201022%22%2C%22os%22%3A%22Android%22%2C%22ov%22%3A%224.1.2%22%2C%22rn%22%3A%22480*800%22%2C%22dn%22%3A%22Jiayu%20G2H%22%2C%22cr%22%3A%2246002%22%2C%22as%22%3A%22WIFI%22%2C%22uid%22%3A%226c9d15f9e4fead03f9bfe8c9f3a14735%22%2C%22clid%22%3A110004000%7D&size=20"

@interface LCScolViewController ()<UITableViewDataSource,UITableViewDelegate>
typedef  NS_ENUM(NSInteger,refreshStatus){
    
    refreshStatusUnkown=0,
    refreshStatusRefresh,
    refreshStatusLoadMore
};
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)NSArray *scrollDataSource;
@property (nonatomic,strong)NSMutableArray *scrollDataSourceCode;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)NSInteger currentItem;
@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,assign)NSInteger offset;
@property (nonatomic,assign)refreshStatus status;
@end

@implementation LCScolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
//    请求MV首播小的Scroll的数据
    [self reloadMVSBScrollData];
//加入tableViewTwo
    [self addTableView];
    [self refresh];
    

    
}
#pragma mark -------刷新数据---
- (void)refresh{
MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    self.status = refreshStatusRefresh;
    [self reloadMCSBData];
}];
    self.tabelView.header = header;
 
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.status = refreshStatusLoadMore;
        [self reloadMCSBData];
    }];
    self.tabelView.footer = footer;
}

- (void)addTableView{
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SRC_W, SRC_H) style:UITableViewStylePlain];
   self.tabelView.delegate = self;
   self.tabelView.dataSource = self;
   [self.view addSubview:self.tabelView];
    
    __weak typeof(self)weakSelf = self;
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];

}

#pragma mark ---- tabelview 的代理方法--

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.dataSource.count;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LCSBTableViewCell *cell = [tableView    dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"LCSBTableViewCell" owner:self options:nil].firstObject;
      }
    if(self.dataSource.count){
    cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}


- (void)reloadMVSBScrollData{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:self.scrollUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.scrollDataSource = responseObject;
        //    MV首播小的Scroll
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SRC_W, 40)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:self.scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(self.view.mas_top);
            make.right.equalTo(self.view.mas_right);
            make.height.equalTo(@(40));
        }];
                for (int i =0; i < self.scrollDataSource.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * 80, 0, 40, 40)];
            label.text = self.scrollDataSource[i][@"name"];
            label.textColor = [UIColor whiteColor];
            [self.scrollDataSourceCode addObject:self.scrollDataSource[i][@"code"]];
            [self.scrollView addSubview:label];
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
            label.tag = 100  + i;
            [label addGestureRecognizer:tap];
            _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(label.frame), 40);
        }
        //    请求MV首播的数据
        //    刚开始的时候给他一个默认的数据
        self.currentItem = 0;
        [self  reloadMCSBData];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


//点击scrollview 上的label  点击手势   只能传手势本身
- (void)click:(UITapGestureRecognizer*)sender{
    self.currentItem = sender.view.tag  - 100;
//    UILabel *label = (UILabel *)sender.view;
//    label.textColor = [UIColor redColor];
    [self.dataSource removeAllObjects];
    [ self reloadMCSBData];
}

- (void)reloadMCSBData{
    [self showHUb];
    if (self.status == refreshStatusRefresh) {
//        从第几个开始读
        self.offset = 0;
        [self.dataSource removeAllObjects];
    }else if (self.status == refreshStatusLoadMore){
    
        self.offset += 20;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
//    判断i  决定是否拼接area
    NSDictionary *dic = @{@"area":self.scrollDataSourceCode[_currentItem],@"offset":@(self.offset)};
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if(self.i){
      dict[@"area"]  =  [NSString stringWithFormat:@"POP_%@",dict[@"area"]];
    }
    
    [manager GET:self.url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        for (NSDictionary *dict in responseObject[@"videos"]) {
        

        [self.dataSource addObjectsFromArray:[LCSBModel arrayOfModelsFromDictionaries:responseObject[@"videos"]]];
        [self.tabelView reloadData];
        [self.tabelView.header endRefreshing];
        [self.tabelView.footer endRefreshing];
        [self hidenHUb];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [self.tabelView.header endRefreshing];
        [self.tabelView.footer endRefreshing];
        [self hidenHUb];

    }];
    
}


//设置cell的高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 180;
}

//点击cell进入二级界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LCDetailViewController *detail = [[LCDetailViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
//把CLSBModel 整个传过去
    if (self.dataSource.count) {
        LCSBModel *model = self.dataSource[indexPath.row];
        detail.model = model;
        [self.navigationController pushViewController:detail animated:YES];
    }
}


//scroll
- (NSArray *)scrollDataSource{

    if (_scrollDataSource == nil) {
        _scrollDataSource = [NSArray array];
    }
    return _scrollDataSource;
}


- (NSMutableArray *)scrollDataSourceCode{
    if (_scrollDataSourceCode == nil) {
        _scrollDataSourceCode = [NSMutableArray array];
    }
    return _scrollDataSourceCode;

}

- (NSMutableArray *)dataSource{
 if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
     return _dataSource;
}
@end
