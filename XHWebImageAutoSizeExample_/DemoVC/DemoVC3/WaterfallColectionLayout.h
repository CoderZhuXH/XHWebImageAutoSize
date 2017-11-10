//
//  WaterfallColectionLayout.h
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef  CGFloat(^itemHeightBlock)(NSIndexPath* index);
@interface WaterfallColectionLayout : UICollectionViewLayout

@property(nonatomic,strong )itemHeightBlock heightBlock ;
@property(nonatomic,assign,readonly) CGFloat itemWidth;

-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block;

@end
