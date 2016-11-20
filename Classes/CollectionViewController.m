//
//  CollectionViewController.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "XHWebImageAutoSize.h"
#import "UIImageView+WebCache.h"
#import "WaterfallColectionLayout.h"

static NSString *const cellId = @"CollectionViewCell";

@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property(nonatomic,strong)UICollectionViewLayout* layout;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    self.myCollectionView.collectionViewLayout = self.layout;

}
-(UICollectionViewLayout *)layout{
    if(!_layout){
        
        __weak __typeof(self) weakSelf = self;
        _layout = [[WaterfallColectionLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {

            return [weakSelf itemHeightAtIndexPath:index];
            
        }];
        
    }
    return _layout;
}

-(CGFloat )itemHeightAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = self.dataArray[indexPath.row];
    CGFloat itemWidth = [self itemWidth];
    
    /**
     *  参数1:图片URL
     *  参数2:imageView 宽度
     *  参数3:预估高度,此高度越接近真实高度效果越好
     */
    
    CGFloat itemHeight = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:itemWidth estimateHeight:200];
    
    return itemHeight;
}
-(CGFloat )itemWidth
{
    return ([UIScreen mainScreen].bounds.size.width-3*5)/3.0;
}
-(NSArray *)dataArray{
    if(_dataArray==nil)
    {
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"images" ofType:@"json"]];
        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        _dataArray = json[@"data"];
        
    }
    return _dataArray;
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
 
    NSString *url = self.dataArray[indexPath.item];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        /**
         *  缓存imageSize
         */
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            
            /**
             *  reload item
             */
           [collectionView xh_reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath] URL:imageURL];
            
        }];
        
    }];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
