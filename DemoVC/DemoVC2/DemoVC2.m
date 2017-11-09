//
//  DemoVC2.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/20.
//  Copyright © 2016年 it7090.com. All rights reserved.
//

#import "DemoVC2.h"
#import "DemoVC2Cell.h"
#import "XHWebImageAutoSize.h"
#import "UIImageView+WebCache.h"
#import "YYModel.h"
#import "NewsModel.h"

static NSString *const cellId = @"DemoVC2Cell";

@interface DemoVC2 ()
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation DemoVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];

}
-(NSArray *)dataArray{
    if(!_dataArray){
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"news" ofType:@"json"]];
        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        _dataArray = json[@"data"];
        _dataArray = [NSArray yy_modelArrayWithClass:[NewsModel class] json:_dataArray];
    }
    return _dataArray;
}
#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   NewsModel *model = self.dataArray[indexPath.row];
    /**
     *  参数1:图片URL
     *  参数2:imageView 宽度
     *  参数3:预估高度,(此高度仅在图片尚未加载出来前起作用,不影响真实高度)
     */
    CGFloat imageHeight = [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:model.top_image] layoutWidth:[UIScreen mainScreen].bounds.size.width-16 estimateHeight:200];
    //cell高度 = 上间隙8+image高度+文字高度60+下间隙8
    return 8+imageHeight+60+8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoVC2Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[DemoVC2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NewsModel *model = self.dataArray[indexPath.row];
    cell.titleLab.text = model.title;
    cell.sourceLab.text = [NSString stringWithFormat:@"来源:%@",model.source];
    cell.countLab.text = [NSString stringWithFormat:@"回复:%ld",model.reply_count];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.top_image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        /**  缓存image size */
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            /** reload */
            if(result)  [tableView xh_reloadDataForURL:imageURL];
        }];
        
    }];
    return cell;
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
