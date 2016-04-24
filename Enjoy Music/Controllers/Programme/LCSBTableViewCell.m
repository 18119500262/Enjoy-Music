//
//  LCSBTableViewCell.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/6.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCSBTableViewCell.h"
@interface LCSBTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *atistName;
@property (weak, nonatomic) IBOutlet UILabel *totalViews;

@end
@implementation LCSBTableViewCell


- (void)setModel:(LCSBModel *)model {
    _model = model;
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:model.albumImg] placeholderImage:nil];
    self.title.text = model.title;
    self.atistName.text = model.artistName;
    self.totalViews.text = [NSString stringWithFormat:@"总浏览量%@",model.totalViews];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
