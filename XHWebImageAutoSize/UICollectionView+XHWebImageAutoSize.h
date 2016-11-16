//
//  UICollectionView+XHWebImageAutoSize.h
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <UIKit/UIKit.h>

@interface UICollectionView (XHWebImageAutoSize)

-(void)xh_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths URL:(NSURL *)url;

@end
