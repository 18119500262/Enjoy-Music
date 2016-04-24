//
//  XBPageCell.m
//  XBScrollPageController
//
//  Created by Scarecrow on 15/10/23.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "XBPageCell.h"

@implementation XBPageCell
- (void)configCellWithController:(UIViewController *)controller
{
    controller.view.frame = self.bounds;
    [self.contentView addSubview:controller.view];
    
}
@end
