//
//  UITableView+XHWebImageAutoSize.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2017/10/25.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "UITableView+XHWebImageAutoSize.h"
#import "XHWebImageAutoSizeConst.h"
#import "XHWebImageAutoSize.h"

@implementation UITableView (XHWebImageAutoSize)

-(void)xh_reloadDataForURL:(NSURL *)url{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState){
        [self reloadData];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
    }
}

#pragma mark-过期
-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url{
    [self xh_reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone forURL:url];
}

-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation forURL:(NSURL *)url{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState){
        [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:animation];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
    }
}

-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url{
    [self xh_reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone forURL:url];
}

-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation forURL:(NSURL *)url{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState){
        [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];
    }
}
@end
