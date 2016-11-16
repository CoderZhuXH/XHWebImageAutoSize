//
//  XHWebImageAutoSize.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableView+XHWebImageAutoSize.h"
#import "UICollectionView+XHWebImageAutoSize.h"

typedef void(^XHWebImageAutoSizeCompletionBlock)(BOOL result);

@interface XHWebImageAutoSize : NSObject

/**
 *  图片显示高度
 *
 *  @param url            图片url
 *  @param layoutWidth    适配的宽度
 *  @param estimateHeight 预估高度
 *
 *  @return 图片显示高度
 */
+(CGFloat)imageHeightWithURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat)estimateHeight;

/**
 *  缓存图片size
 *
 *  @param image          图片
 *  @param url            图片url
 *  @param completedBlock 缓存完成回调
 */
+(void)cacheImageSizeWithImage:(UIImage *)image URL:(NSURL *)url completed:(XHWebImageAutoSizeCompletionBlock)completedBlock;

@end
