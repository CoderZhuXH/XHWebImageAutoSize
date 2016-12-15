//
//  XHWebImageAutoSizeCache.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XHWebImageAutoSizeCacheCompletionBlock)(BOOL result);

@interface XHWebImageAutoSizeCache : NSObject

/**
 * Return global shared cache instance
 *
 * @return XHWebImageAutoSizeCache global instance
 */
+(XHWebImageAutoSizeCache *)shardCache;

/**
 *  Store an imageSize into memory and disk cache at the given key.
 *
 *  @param image The image to store
 *  @param key   The unique imageSize cache key, usually it's image absolute URL
 *
 *  @return result
 */
-(BOOL)storeImageSize:(UIImage *)image forKey:(NSString *)key;

/**
 *  Store an imageSize into memory and disk cache at the given key.
 *
 *  @param image          The image to store
 *  @param key            The unique imageSize cache key, usually it's image absolute URL
 *  @param completedBlock An block that should be executed after the imageSize has been saved (optional)
 */
-(void)storeImageSize:(UIImage *)image forKey:(NSString *)key completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

/**
 *  Query the disk cache synchronously after checking the memory cache
 *
 *  @param key  The unique key used to store the wanted imageSize
 *
 *  @return imageSize
 */
-(CGSize)imageSizeFromCacheForKey:(NSString *)key;

/**
 *  Store an reloadState into memory and disk cache at the given key.
 *
 *  @param state reloadState
 *  @param key   The unique reloadState cache key, usually it's image absolute URL
 *
 *  @return result
 */
-(BOOL)storeReloadState:(BOOL)state forKey:(NSString *)key;

/**
 *  Store an reloadState into memory and disk cache at the given key
 *
 *  @param state          reloadState
 *  @param key            The unique reloadState cache key, usually it's image absolute URL
 *  @param completedBlock An block that should be executed after the reloadState has been saved (optional)
 */
-(void)storeReloadState:(BOOL)state forKey:(NSString *)key completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

/**
 *  Query the disk cache synchronously after checking the memory cache
 *
 *  @param key The unique key used to store the wanted reloadState
 *
 *  @return reloadState
 */
-(BOOL)reloadStateFromCacheForKey:(NSString *)key;

@end
