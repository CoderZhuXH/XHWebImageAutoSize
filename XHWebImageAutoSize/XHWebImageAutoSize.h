//
//  XHWebImageAutoSize.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableView+XHWebImageAutoSize.h"
#import "UICollectionView+XHWebImageAutoSize.h"
#import "XHWebImageAutoSizeCache.h"

@interface XHWebImageAutoSize : NSObject

+(CGFloat)imageHeightForURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight;

+(CGSize )imageSizeFromCacheForURL:(NSURL *)url;
+(void)storeImageSize:(UIImage *)image forURL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

+(BOOL)reloadStateFromCacheForURL:(NSURL *)url;
+(void)storeReloadState:(BOOL)state forURL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

@end
