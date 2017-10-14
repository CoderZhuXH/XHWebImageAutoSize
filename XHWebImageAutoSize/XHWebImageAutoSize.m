//
//  XHWebImageAutoSize.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
// https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "XHWebImageAutoSize.h"


static CGFloat const estimateDefaultHeight = 100;

@implementation XHWebImageAutoSize

+(CGFloat)imageHeightForURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight{
    
    CGFloat showHeight = estimateDefaultHeight;
    if(estimateHeight) showHeight = estimateHeight;
    if(!url || !layoutWidth) return showHeight;
    CGSize size = [self imageSizeFromCacheForURL:url];
    CGFloat imgWidth = size.width;
    CGFloat imgHeight = size.height;
    if(imgWidth>0 && imgHeight >0)
    {
        showHeight = layoutWidth/imgWidth*imgHeight;
    }
    return showHeight;
}
+(void)storeImageSize:(UIImage *)image forURL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock{
    
    [[XHWebImageAutoSizeCache shardCache] storeImageSize:image forKey:[self cacheKeyForURL:url] completed:completedBlock];
    
}
+(void)storeReloadState:(BOOL)state forURL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock{

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


@implementation UITableView (XHWebImageAutoSize)

-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url
{
    
    [self xh_reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone forURL:url];

}
-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation forURL:(NSURL *)url
{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState)
    {
        [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
        
    }
}
#pragma mark-过期
-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url
{
    [self xh_reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone forURL:url];
}

-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation forURL:(NSURL *)url
{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState)
    {
        [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
        
    }
}

@end


@implementation UICollectionView (XHWebImageAutoSize)

-(void)xh_reloadItemAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url
{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState)
    {
        [self reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
        
    }
}
#pragma mark- 过期
-(void)xh_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url
{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState)
    {
        [self reloadItemsAtIndexPaths:indexPaths];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
        
    }
}

@end




