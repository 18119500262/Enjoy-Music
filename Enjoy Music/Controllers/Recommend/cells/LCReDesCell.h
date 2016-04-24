//
//  LCReDesCell.h
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LCRecomDetaiModel;

@interface LCReDesCell : UITableViewCell

@property (nonatomic, strong) LCRecomDetaiModel  *model;
@property (nonatomic, assign) CGFloat  cellHeight;



@end
