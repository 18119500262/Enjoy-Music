//
//  LCReDesCell.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCReDesCell.h"
#import "LCRecomDetaiModel.h"
#import "UIView+frame.h"

@interface LCReDesCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *descripLabel;

@end

@implementation LCReDesCell

- (void)setModel:(LCRecomDetaiModel *)model {
    
    _model = model;
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.text = model.title;
    self.nameLabel.text = [NSString stringWithFormat:@"作者:%@",model.nickName];
    self.timeLabel.text = [NSString stringWithFormat:@"更新时间:%@",model.updateTime];
    self.countLabel.text = [NSString stringWithFormat:@"播放次数:%@",model.totalViews];
    self.saveLabel.text = [NSString stringWithFormat:@"收藏:%@",model.totalFavorites];
    self.scoreLabel.text = [NSString stringWithFormat:@"获得积分:%@",model.integral];
    
    self.descripLabel.text = model.descrip;
    
    self.descripLabel.font = [UIFont systemFontOfSize:15];
   CGFloat height = [model.descrip boundingRectWithSize:CGSizeMake(self.descripLabel.width, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    
    self.descripLabel.height = height;
    self.descripLabel.numberOfLines = 0;
     self.cellHeight = self.descripLabel.maxY+5;
}


@end
