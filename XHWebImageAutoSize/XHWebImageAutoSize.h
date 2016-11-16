//
//  XHWebImageAutoSize.h
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UITableView+XHWebImageAutoSize.h"

typedef void(^XHWebImageAutoSizeCompletionBlock)(BOOL result);

@interface XHWebImageAutoSize : NSObject

+(CGFloat)imageHeightWithURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight;

+(void)cacheImageSizeWithImage:(UIImage *)image URL:(NSURL *)url completed:(XHWebImageAutoSizeCompletionBlock)completedBlock;

@end
