//
//  DemoVC3.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//

#import "DemoVC3.h"
#import "DemoVC3Cell.h"
#import "XHWebImageAutoSize.h"
#import "UIImageView+WebCache.h"
#import "WaterfallColectionLayout.h"

static NSString *const cellId = @"DemoVC3Cell";

@interface DemoVC3 ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property(nonatomic,strong)WaterfallColectionLayout* layout;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation DemoVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    self.myCollectionView.collectionViewLayout = self.layout;

}
-(WaterfallColectionLayout *)layout{
    if(!_layout){
        __weak __typeof(self) weakSelf = self;
        _layout = [[WaterfallColectionLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {
            return [weakSelf itemHeightAtIndexPath:index];
        }];
    }
    return _layout;
}

-(CGFloat )itemHeightAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = self.dataArray[indexPath.row];
    /**
     *  参数1:图片URL
     *  参数2:imageView 宽度
     *  参数3:预估高度,(此高度仅在图片尚未加载出来前起作用,不影响真实高度)
     */
    return [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:self.layout.itemWidth estimateHeight:200];
}

-(NSArray *)dataArray{
    if(!_dataArray){
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image02" ofType:@"json"]];
        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        _dataArray = json[@"data"];
    }
    return _dataArray;
}
#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DemoVC3Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSString *url = self.dataArray[indexPath.item];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        /**  缓存imageSize */
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            /** reload */
            if(result) [collectionView xh_reloadDataForURL:imageURL];
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
