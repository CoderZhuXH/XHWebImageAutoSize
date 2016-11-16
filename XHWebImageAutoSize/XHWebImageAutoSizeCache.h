//
//  XHWebImageAutoSizeCache.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XHWebImageAutoSizeCacheCompletionBlock)(BOOL result);

@interface XHWebImageAutoSizeCache : NSObject

+(BOOL)cacheImageSizeWithImage:(UIImage *)image URL:(NSURL *)url;
+(CGSize)readImageSizeCacheWithURL:(NSURL *)url;

+(BOOL)readReloadStateWithURL:(NSURL *)url;
+(BOOL)cacheReloadState:(BOOL)state URL:(NSURL *)url;
+(void)cacheReloadState:(BOOL)state URL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

@end
