//
//  UICollectionView+XHWebImageAutoSize.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "UICollectionView+XHWebImageAutoSize.h"
#import "XHWebImageAutoSize.h"

@implementation UICollectionView (XHWebImageAutoSize)

-(void)xh_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths URL:(NSURL *)url
{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState)
    {
        //NSLog(@"执行了reloadItemsAtIndexPaths");
        [self reloadItemsAtIndexPaths:indexPaths];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
        
    }
}

@end
