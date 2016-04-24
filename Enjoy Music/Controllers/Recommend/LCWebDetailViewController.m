//
//  LCWebDetailViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCWebDetailViewController.h"

@interface LCWebDetailViewController ()

@end

@implementation LCWebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLRequest *resqust = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [web loadRequest:resqust];
    [self.view addSubview:web];
}


@end
