//
//  LCLoginViewController.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCLoginViewController.h"
#import "LCRegistViewController.h"


@interface LCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation LCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
}

- (IBAction)loginAction:(id)sender {
    
    if (self.userName.text.length <=0||self.passWord.text.length <=0) {
        
        [Auxiliary alertWithTitle:@"请补全信息" message:nil button:1 done:nil];
    }
    else {
        
        [BmobUser loginInbackgroundWithAccount:self.userName.text andPassword:self.passWord.text block:^(BmobUser *user, NSError *error) {
            
            if (user) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else {
                [Auxiliary alertWithTitle:@"登录失败" message:@"用户名或密码不匹配" button:1 done:nil];
            }
        }];
    }
}
- (IBAction)registerAction:(id)sender {
    
    LCRegistViewController *regist = [[LCRegistViewController alloc] init];
    regist.userBlock = ^(NSString *userName){
        self.userName.text = userName;
    };
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
