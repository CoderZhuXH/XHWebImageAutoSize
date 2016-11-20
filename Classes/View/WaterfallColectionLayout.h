//
//  WaterfallColectionLayout.h
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  CGFloat(^itemHeightBlock)(NSIndexPath* index);
@interface WaterfallColectionLayout : UICollectionViewLayout
@property(nonatomic,strong )itemHeightBlock heightBlock ;

-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block;
@end
