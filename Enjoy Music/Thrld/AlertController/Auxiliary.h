//
//  auxiliary.h
//  xmppClientDemo
//  辅助工具集
//  Created by csl on 15/11/28.
//  Copyright © 2015年 csl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Auxiliary : NSObject
////警告框
+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSUInteger)buttons done:(void (^)())act;


//两个按钮
+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSArray*)buttons done:(void (^)())agree cancel:(void (^)())disagree;

+(void) alertWithTitle:(NSString*)title message:(NSString*)message button:(NSUInteger)buttons inController:(UIViewController*)controller done:(void (^)())act;

//定义转场动画
//参数：properties字典，每一个键值对描述一个动画属性，常用的有：
//     动画类型： pageCurl            向上翻一页
//              pageUnCurl          向下翻一页
//              rippleEffect        滴水效果
//              suckEffect          收缩效果，如一块布被抽走
//              cube                立方体效果
//              oglFlip             上下翻转效果
//     动画方向： kCATransitionFromRight kCATransitionFromLeft kCATransitionFromTop kCATransitionFromBottom;
//     动画时间曲线：linear(线性) easeIn() easeOut() easeInEaseOut()
//      动画时间：默认动画时间是1秒
//返回值：返回生成的过渡动画对象
//调用示例：CATransition * transition = [Auxiliary transitWithProperties:@{@"type":@"cube",@"subType":@"fromRight",@"duration":@"1"}];
//   [self.navigationController.view.layer    addAnimation:transition forKey:nil]
+(CATransition*) transitWithProperties:(NSDictionary*)properties;


//动态计算字符串高度
//参数：string：要计算的字符串
//     width：字符串要显示的宽度
//     property：字典，在字典里指定字符串的字体，颜色等属性常用的键值有：
// NSDictionary* attrs =@{NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:30],//文本的颜色 字体 大小
//NSForegroundColorAttributeName:[UIColor redColor]};//文字颜色
//返回值：指定属性字符串的高度
+(CGFloat) dynamicHeightWithString:(NSString*)string width:(CGFloat)width attribute:(NSDictionary*)attrs;

//功能：设置视图的层圆角
//参数：dest 目标层，radius，层的圆角度数，width，线宽，color 线的颜色
//返回值：无
+(void) layerCornerRadius:(CALayer*)dest radius:(float)radius width:(float)width color:(UIColor*)color;

////功能：版本检测
////参数：appid，itunes里创建时产生的app的唯一编号
////返回值：无
//+(void)checkVersion:(NSString*)appid;

//功能：正则表达式验证用户名
//参数：name 用户名,rule 验证规则
//返回值：正确返回YES，否则返回NO
+ (BOOL) validateUserName:(NSString *)name rule:(NSString*)rule;


//功能：正则表达式验证密码
//参数：password 密码,rule 验证规则
//返回值：正确返回YES，否则返回NO
+ (BOOL) validatePassword:(NSString *)passWord rule:(NSString*)rule;


//功能：手机号码验证
//参数：mobile 手机号
//返回值：正确返回YES，否则返回NO
+ (BOOL) validateMobile:(NSString *)mobile;


//功能：身份证号验证
//参数：identityCard 身份证号
//返回值：正确返回YES，否则返回NO
+ (BOOL) validateIdentityCard: (NSString *)identityCard;


//功能：邮箱验证
//参数：email 邮箱
//返回值：正确返回YES，否则返回NO
+ (BOOL) validateEmail:(NSString *)email;

//功能：世界标准时间UTC/GMT 转为当前系统时区对应的时间
//参数：anyDate UTC/GMT时间
//返回值：当前系统时区对应的时间
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
@end
