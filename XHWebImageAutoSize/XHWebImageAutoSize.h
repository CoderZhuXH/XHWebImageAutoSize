//
//  XHWebImageAutoSize.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableView+XHWebImageAutoSize.h"
#import "UICollectionView+XHWebImageAutoSize.h"
#import "XHWebImageAutoSizeCache.h"

@interface XHWebImageAutoSize : NSObject

/**
 *   Get image height
 *
 *  @param url            imageURL
 *  @param layoutWidth    layoutWidth
 *  @param estimateHeight estimateHeight(default 100)
 *
 *  @return imageHeight
 */
+(CGFloat)imageHeightForURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight;

/**
 *  Get image size from cache,query the disk cache synchronously after checking the memory cache
 *
 *  @param url imageURL
 *
 *  @return imageSize
 */
+(CGSize )imageSizeFromCacheForURL:(NSURL *)url;

/**
 *  Store an imageSize into memory and disk cache
 *
 *  @param image          image
 *  @param url            imageURL
 *  @param completedBlock An block that should be executed after the imageSize has been saved (optional)
 */
+(void)storeImageSize:(UIImage *)image forURL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

/**
 *  Get reload state from cache,query the disk cache synchronously after checking the memory cache
 *
 *  @param url imageURL
 *
 *  @return reloadState
 */
+(BOOL)reloadStateFromCacheForURL:(NSURL *)url;

/**
 *  Store an reloadState into memory and disk cache
 *
 *  @param state          reloadState
 *  @param url            imageURL
 *  @param completedBlock An block that should be executed after the reloadState has been saved (optional)
 */
+(void)storeReloadState:(BOOL)state forURL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

@end


