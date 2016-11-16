//
//  XHWebImageAutoSize.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import "XHWebImageAutoSize.h"
#import "XHWebImageAutoSizeCache.h"

@implementation XHWebImageAutoSize

+(CGFloat)imageHeightWithURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight
{
    CGFloat showHeight = estimateHeight;
    CGSize size = [XHWebImageAutoSizeCache readImageSizeCacheWithURL:url];
    CGFloat imgWidth = size.width;
    CGFloat imgHeight = size.height;
    if(imgWidth>0 && imgHeight >0)
    {
        showHeight = layoutWidth/imgWidth*imgHeight;
    }
    return showHeight;
}

+(void)cacheImageSizeWithImage:(UIImage *)image URL:(NSURL *)url completed:(XHWebImageAutoSizeCompletionBlock)completedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result = [XHWebImageAutoSizeCache cacheImageSizeWithImage:image URL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(completedBlock)
            {
                completedBlock(result);
            }
        });
    });
}
@end
