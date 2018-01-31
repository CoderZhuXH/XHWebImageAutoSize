//
//  XHWebImageAutoSize.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
// https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "XHWebImageAutoSize.h"

static CGFloat const estimateDefaultHeight = 100;
static CGFloat const estimateDefaultWidth = 90;

@implementation XHWebImageAutoSize

+(CGFloat)imageHeightForURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight{
    CGFloat showHeight = estimateDefaultHeight;
    if(estimateHeight) showHeight = estimateHeight;
    if(!url || !layoutWidth) return showHeight;
    CGSize size = [self imageSizeFromCacheForURL:url];
    CGFloat imgWidth = size.width;
    CGFloat imgHeight = size.height;
    if(imgWidth>0 && imgHeight >0){
        showHeight = layoutWidth/imgWidth*imgHeight;
    }
    return showHeight;
}

+(CGFloat)imageWidthForURL:(NSURL *)url layoutHeight:(CGFloat)layoutHeight estimateWidth:(CGFloat )estimateWidth{
    CGFloat showWidth = estimateDefaultWidth;
    if(estimateWidth) showWidth = estimateWidth;
    if(!url || !layoutHeight) return showWidth;
    CGSize size = [self imageSizeFromCacheForURL:url];
    CGFloat imgWidth = size.width;
    CGFloat imgHeight = size.height;
    if(imgWidth>0 && imgHeight >0){
        showWidth = layoutHeight/imgHeight*imgWidth;
    }
    return showWidth;
}

+(void)storeImageSize:(UIImage *)image forURL:(NSURL *)url completed:(nullable XHWebImageAutoSizeCacheCompletionBlock)completedBlock{
    [[XHWebImageAutoSizeCache shardCache] storeImageSize:image forKey:[self cacheKeyForURL:url] completed:completedBlock];
}

+(void)storeReloadState:(BOOL)state forURL:(NSURL *)url completed:(nullable XHWebImageAutoSizeCacheCompletionBlock)completedBlock{
    [[XHWebImageAutoSizeCache shardCache] storeReloadState:state forKey:[self cacheKeyForURL:url] completed:completedBlock];
}

+(CGSize )imageSizeFromCacheForURL:(NSURL *)url{
    return [[XHWebImageAutoSizeCache shardCache] imageSizeFromCacheForKey:[self cacheKeyForURL:url]];
}

+(BOOL)reloadStateFromCacheForURL:(NSURL *)url{
  return [[XHWebImageAutoSizeCache shardCache] reloadStateFromCacheForKey:[self cacheKeyForURL:url]];
}

#pragma mark - XHWebImageAutoSize (private)
+(NSString *)cacheKeyForURL:(NSURL *)url{
    return [url absoluteString];
}

@end
