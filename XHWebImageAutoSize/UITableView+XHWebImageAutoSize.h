//
//  UITableView+XHWebImageAutoSize.h
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2017/10/25.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <UIKit/UIKit.h>
#import "XHWebImageAutoSizeConst.h"

@interface UITableView (XHWebImageAutoSize)

/**
 Reload tableView

 @param url imageURL
 */
-(void)xh_reloadDataForURL:(NSURL *)url;

#pragma mark - 过期
/**
 *  Reload row
 *
 *  @param indexPath indexPath
 *  @param url        imageURL
 */
-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url XHWebImageAutoSizeDeprecated("请使用xh_reloadDataForURL:");

/**
 *  Reload row withRowAnimation
 *
 *  @param indexPath indexPath
 *  @param animation UITableViewRowAnimation
 *  @param url       imageURL
 */
-(void)xh_reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation forURL:(NSURL *)url XHWebImageAutoSizeDeprecated("请使用xh_reloadDataForURL:");

/**
 *  Reload rows
 *
 *  @param indexPaths indexPaths
 *  @param url        imageURL
 */
-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url XHWebImageAutoSizeDeprecated("请使用xh_reloadDataForURL:");
;
@end
