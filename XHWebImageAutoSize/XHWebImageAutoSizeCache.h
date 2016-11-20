//
//  XHWebImageAutoSizeCache.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XHWebImageAutoSizeCacheCompletionBlock)(BOOL result);

@interface XHWebImageAutoSizeCache : NSObject

+(XHWebImageAutoSizeCache *)shardCache;
-(BOOL)storeImageSize:(UIImage *)image forKey:(NSString *)key;
-(void)storeImageSize:(UIImage *)image forKey:(NSString *)key completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;
-(CGSize)imageSizeFromCacheForKey:(NSString *)key;

-(BOOL)storeReloadState:(BOOL)state forKey:(NSString *)key;
-(void)storeReloadState:(BOOL)state forKey:(NSString *)key completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;
-(BOOL)reloadStateFromCacheForKey:(NSString *)key;

@end
