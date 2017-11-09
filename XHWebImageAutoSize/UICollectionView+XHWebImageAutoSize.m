//
//  UICollectionView+XHWebImageAutoSize.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2017/10/25.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "UICollectionView+XHWebImageAutoSize.h"
#import "XHWebImageAutoSize.h"

@implementation UICollectionView (XHWebImageAutoSize)
-(void)xh_reloadDataForURL:(NSURL *)url{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState){
        [self reloadData];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
    }
}

#pragma mark- 过期
-(void)xh_reloadItemAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState){
        [self reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
    }
}

-(void)xh_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState){
        [self reloadItemsAtIndexPaths:indexPaths];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
    }
}
@end
