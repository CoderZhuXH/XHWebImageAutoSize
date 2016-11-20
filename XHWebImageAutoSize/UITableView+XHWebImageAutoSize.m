//
//  UITableView+XHWebImageAutoSize.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "UITableView+XHWebImageAutoSize.h"
#import "XHWebImageAutoSize.h"

@implementation UITableView (XHWebImageAutoSize)

-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths URL:(NSURL *)url
{
    [self xh_reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone URL:url];
}

-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation URL:(NSURL *)url
{
    BOOL reloadState = [XHWebImageAutoSize reloadStateFromCacheForURL:url];
    if(!reloadState)
    {
        //NSLog(@"执行了reloadRowsAtIndexPaths");
        [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [XHWebImageAutoSize storeReloadState:YES forURL:url completed:nil];

    }
}

@end
