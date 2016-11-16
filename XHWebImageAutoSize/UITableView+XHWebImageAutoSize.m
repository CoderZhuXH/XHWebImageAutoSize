//
//  UITableView+XHWebImageAutoSize.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import "UITableView+XHWebImageAutoSize.h"
#import "XHWebImageAutoSizeCache.h"

@implementation UITableView (XHWebImageAutoSize)

-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths URL:(NSURL *)url
{
    [self xh_reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone URL:url];
}

-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation URL:(NSURL *)url
{
    BOOL reloadState = [XHWebImageAutoSizeCache readReloadStateWithURL:url];
    if(!reloadState)
    {
        NSLog(@"执行了reloadRowsAtIndexPaths");
        [self reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [XHWebImageAutoSizeCache cacheReloadState:YES URL:url completed:nil];

    }
}

@end
