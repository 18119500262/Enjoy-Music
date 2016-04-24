//
//  LCXGMVTableViewCell.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/7.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCXGMVTableViewCell.h"
@interface LCXGMVTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *artistname;
@property (weak, nonatomic) IBOutlet UILabel *totalViews;

@end
@implementation LCXGMVTableViewCell

- (void)setModel:(LCSBModel *)model{
    _model = model;
    [_image sd_setImageWithURL:[NSURL URLWithString:model.albumImg] placeholderImage:nil];
    _title.text = model.title;
    _artistname.text = model.artistName;
    _totalViews.text = [NSString stringWithFormat:@"播放次数%@",model.totalViews];
    
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
