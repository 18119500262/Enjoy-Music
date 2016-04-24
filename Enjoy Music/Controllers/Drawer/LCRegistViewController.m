//
//  LCRegistViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRegistViewController.h"

@interface LCRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *passWordT;

@end

@implementation LCRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    
}
- (IBAction)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)registAction:(id)sender {
    
    if (self.userName.text.length<=0 || self.passWord.text.length<=0||self.passWordT.text.length<=0) {
        [Auxiliary alertWithTitle:@"请补全信息" message:nil button:1 done:nil];
    }else if (![self.passWord.text isEqualToString:self.passWordT.text]){
        
        [Auxiliary alertWithTitle:@"注册失败" message:@"请重新确认密码" button:1 done:nil];
    }
    else {
        BmobUser *bUser = [[BmobUser alloc] init];
        [bUser setUsername:self.userName.text];
        [bUser setPassword:self.passWord.text];
        [bUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [Auxiliary alertWithTitle:@"注册成功" message:nil button:1 done:^{
                    [BmobUser logout];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            else {
                [Auxiliary alertWithTitle:@"注册失败" message:@"用户已存在" button:1 done:nil];
            }
        }];
    }
    
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
