//
//  LCRecomTableViewCell.m
//  Enjoy Music
//
//  Created by qianfeng on 16/4/5.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "LCRecomTableViewCell.h"
#import "LCRecomMOdel.h"


@interface LCRecomTableViewCell()

@property (nonatomic,strong) UIImageView *posterPic;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *desLabel;


@end

@implementation LCRecomTableViewCell

- (void)setModel:(LCRecomMOdel *)model {
    _model = model;
    [self.posterPic sd_setImageWithURL:[NSURL URLWithString:model.posterPic]];
    self.titleLabel.text = model.title;
    self.desLabel.text = model.des;
    
    
}
#pragma mark ----- 懒加载 ------
- (UIImageView *)posterPic {
    
    if (!_posterPic) {
        _posterPic = [[UIImageView alloc] init];
        [self.contentView addSubview:_posterPic];
        [_posterPic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _posterPic;
}
- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(50);
            make.right.equalTo(self.contentView.mas_right).with.offset(-50);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-50);
            make.height.equalTo(@20);
        }];
    }
    return _titleLabel;
}
- (UILabel *)desLabel {
    
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_desLabel];
        _desLabel.backgroundColor = [UIColor clearColor];
        _desLabel.textColor = [UIColor greenColor];
        _desLabel.textAlignment = NSTextAlignmentLeft;
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(50);
            make.right.equalTo(self.contentView.mas_right).with.offset(-50);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.height.equalTo(@20);
        }];
    }
    return _desLabel;
}






@end
