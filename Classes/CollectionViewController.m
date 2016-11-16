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

#define MainScreen [[UIScreen mainScreen] bounds]
#define MWIDTH MainScreen.size.width
#define MHEIGHT MainScreen.size.height

//RGB 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//随机色
#define Color_Other  RGBCOLOR(arc4random()%255, arc4random()%255, arc4random()%255)

static NSString *const cellId = @"CollectionViewCell";

@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property(nonatomic,strong)UICollectionViewLayout* layout;
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UICollectionView+XHWebImageAutoSize";
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellWithReuseIdentifier:cellId];
    self.myCollectionView.collectionViewLayout = self.layout;

}
-(UICollectionViewLayout *)layout{
    if(!_layout){
        _layout = [[WaterfallColectionLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {

            return [self itemHeightAtIndexPath:index];
            
        }];
        
    }
    return _layout;
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
#pragma mark ---- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
 
    NSString *url = self.dataArray[indexPath.item];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [XHWebImageAutoSize cacheImageSizeWithImage:image URL:imageURL completed:^(BOOL result) {
            
            
            [collectionView xh_reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath] URL:imageURL];
            
        }];
        
    }];
    
    return cell;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
-(CGFloat )itemHeightAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = self.dataArray[indexPath.row];
    CGFloat itemWidth = [self itemWidth];
    CGFloat itemHeight = [XHWebImageAutoSize imageHeightWithURL:[NSURL URLWithString:url] layoutWidth:itemWidth estimateHeight:200];
    return itemHeight;
}
-(CGFloat )itemWidth
{
    return (MWIDTH-3*5)/3.0;
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
