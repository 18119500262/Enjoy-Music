//
//  LCButton.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/11.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCButton.h"

@implementation LCButton

#pragma mark 设置button 内部图片的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imgeW = contentRect.size.width *0.8;
    CGFloat imgeH = contentRect.size.height*0.7;
    return CGRectMake(0, 0, imgeW, imgeH);
}
#pragma mark 设置button 内部文字的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height*0.7;
    CGFloat titleW = contentRect.size.width *0.9;
    CGFloat titleH = contentRect.size.height*0.3;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
