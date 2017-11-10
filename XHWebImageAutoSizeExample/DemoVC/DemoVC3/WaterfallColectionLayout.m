//
//  WaterfallColectionLayout.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//


#define colSpace 5
//列数
#define colCount 3

#import "WaterfallColectionLayout.h"

@interface WaterfallColectionLayout ()
//数组存放每列的总高度
@property(nonatomic,strong)NSMutableArray* colsHeight;
//单元格宽度
@property(nonatomic,assign)CGFloat colWidth;

@end

@implementation WaterfallColectionLayout
-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block{
    if ([super init]) {
        self.heightBlock = block;
    }
    return self;
}
-(void)prepareLayout{
    [super prepareLayout];
    self.colWidth = self.itemWidth;
    self.colsHeight = nil;
}
-(CGFloat)itemWidth
{
    return (self.collectionView.frame.size.width - (colCount+1)*colSpace )/colCount;
}
-(CGSize)collectionViewContentSize{
    NSNumber * longest = self.colsHeight[0];
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(longest.floatValue<rolHeight.floatValue){
            longest = rolHeight;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, longest.floatValue);
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    NSNumber * shortest = self.colsHeight[0];
    NSInteger  shortCol = 0;
    for (NSInteger i =0;i<self.colsHeight.count;i++) {
        NSNumber* rolHeight = self.colsHeight[i];
        if(shortest.floatValue>rolHeight.floatValue){
            shortest = rolHeight;
            shortCol=i;
        }
    }
    CGFloat x = (shortCol+1)*colSpace+ shortCol * self.colWidth;
    CGFloat y = shortest.floatValue+colSpace;
    
    //获取cell高度
    CGFloat height=0;
    NSAssert(self.heightBlock!=nil, @"未实现计算高度的block ");
    if(self.heightBlock){
        height = self.heightBlock(indexPath);
    }
    attr.frame= CGRectMake(x, y, self.colWidth, height);
    self.colsHeight[shortCol]=@(shortest.floatValue+colSpace+height);
   
    return attr;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray* array = [NSMutableArray array];
    NSInteger items = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<items;i++) {
        UICollectionViewLayoutAttributes* attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attr];
    }
    return array;
}
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
-(NSMutableArray *)colsHeight{
    if(!_colsHeight){
        NSMutableArray * array = [NSMutableArray array];
        for(int i =0;i<colCount;i++){
            //这里可以设置初始高度
            [array addObject:@(0)];
        }
        _colsHeight = [array mutableCopy];
    }
    return _colsHeight;
}
@end
