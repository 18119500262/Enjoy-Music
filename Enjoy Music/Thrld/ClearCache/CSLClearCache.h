//
//  CSLClearCache.h
//  LiveAssistant
//
//  Created by csl on 15/12/24.
//  Copyright © 2015年 CSL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSLClearCache : NSObject

//功能：确定文件尺寸
//参数：filePath 文件路径
//返回值：文件大小
- (long long) fileSizeAtPath:(NSString*) filePath;

//功能：获得指定文件夹的大小（递归遍历子文件夹）
//参数：folderPath 文件夹路径
//返回值：文件夹大小
- (float ) folderSizeAtPath:(NSString*) folderPath;

//功能：清理缓存
//参数：无
//返回值：清理的缓存数量
-(float) clearCache;
@end
