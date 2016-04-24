//
//  UIView+frame.h
//  fly-label
//
//  Created by luds on 15/11/23.
//  Copyright © 2015年 luds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

/**
 *  x
 */
@property (nonatomic, assign) CGFloat x;

/**
 *  y
 */
@property (nonatomic, assign) CGFloat y;

/**
 *  width
 */
@property (nonatomic, assign) CGFloat width;

/**
 *  height
 */
@property (nonatomic, assign) CGFloat height;

/**
 *  水平方向最大值
 */
@property (nonatomic, assign, readonly) CGFloat maxX;

/**
 *  垂直方向最大值
 */
@property (nonatomic, assign, readonly) CGFloat maxY;

/** 
 *  水平中间点 
 */
@property (nonatomic, assign, readonly) CGFloat midX;

/** 
 *  垂直中间点
 */
@property (nonatomic, assign, readonly) CGFloat midY;





@end
