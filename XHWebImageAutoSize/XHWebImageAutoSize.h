//
//  XHWebImageAutoSize.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XHWebImageAutoSizeCache.h"

// 过期提醒
#define XHWebImageAutoSizeDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

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

@interface UITableView (XHWebImageAutoSize)

/**
 *  Reload row
 *
 *  @param indexPath indexPath
 *  @param url        imageURL
 */
-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url;

/**
 *  Reload row withRowAnimation
 *
 *  @param indexPath indexPath
 *  @param animation UITableViewRowAnimation
 *  @param url       imageURL
 */
-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation forURL:(NSURL *)url;

#pragma mark - 过期
/**
 *  Reload rows
 *
 *  @param indexPaths indexPaths
 *  @param url        imageURL
 */
-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url XHWebImageAutoSizeDeprecated("请使用xh_reloadRowAtIndexPath:forURL:");
;

@end

@interface UICollectionView (XHWebImageAutoSize)

/**
 *  Reload item
 *
 *  @param indexPath indexPath
 *  @param url        imageURL
 */
-(void)xh_reloadItemAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url;

#pragma mark - 过期
/**
 *  Reload items
 *
 *  @param indexPaths indexPaths
 *  @param url        imageURL
 */
-(void)xh_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url  XHWebImageAutoSizeDeprecated("请使用xh_reloadItemAtIndexPath:forURL:");
@end
