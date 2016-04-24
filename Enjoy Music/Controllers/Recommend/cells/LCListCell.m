//
//  LCListCell.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCListCell.h"
#import "LCListModel.h"
@interface LCListCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end
@implementation LCListCell

- (void)setModel:(LCListModel *)model {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    _model = model;
    
    [self.imageLabel sd_setImageWithURL:[NSURL URLWithString:model.playListPic]];
    self.imageLabel.contentMode = UIViewContentModeScaleAspectFill;
    self.imageLabel.layer.masksToBounds = YES;
    
    self.titleLabel.text = model.title;
    self.artistName.text = model.artistName;
    self.totalLabel.text = [NSString stringWithFormat:@"播放次数:%@",model.totalViews];
}


@end
