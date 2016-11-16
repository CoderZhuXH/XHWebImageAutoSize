//
//  UITableView+XHWebImageAutoSize.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UITableView (XHWebImageAutoSize)

/**
 *  reloadRowsAtIndexPaths
 *
 *  @param indexPaths indexPaths
 *  @param url        imageURL
 */
-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths URL:(NSURL *)url;

@end
