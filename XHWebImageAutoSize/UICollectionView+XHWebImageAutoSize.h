//
//  UICollectionView+XHWebImageAutoSize.h
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2017/10/25.
//  Copyright © 2017年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <UIKit/UIKit.h>
#import "XHWebImageAutoSizeConst.h"

@interface UICollectionView (XHWebImageAutoSize)

/**
 Reload collectionView
 
 @param url imageURL
 */
-(void)xh_reloadDataForURL:(NSURL *)url;

#pragma mark - 过期
/**
 *  Reload item
 *
 *  @param indexPath indexPath
 *  @param url        imageURL
 */
-(void)xh_reloadItemAtIndexPath:(NSIndexPath *)indexPath forURL:(NSURL *)url XHWebImageAutoSizeDeprecated("请使用xh_reloadDataForURL:");

/**
 *  Reload items
 *
 *  @param indexPaths indexPaths
 *  @param url        imageURL
 */
-(void)xh_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url  XHWebImageAutoSizeDeprecated("请使用xh_reloadDataForURL:");

@end
