//
//  ViewController.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/15.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewCell.h"
#import "UIImageView+WebCache.h"
#import "XHWebImageAutoSize.h"


#define MainScreen [[UIScreen mainScreen] bounds]
#define MWIDTH MainScreen.size.width
#define MHEIGHT MainScreen.size.height


static NSString *const cellId = @"ImageViewCell";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.myTableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
    
    // Do any additional setup after loading the view from its nib.
}
-(NSMutableArray *)dataArray{
    if(_dataArray==nil)
    {
        _dataArray = [[NSMutableArray alloc] init];
         NSArray *imgArray = @[@"http://img01.taopic.com/151027/234753-15102G5360846.jpg",
                               @"http://img05.tooopen.com/images/20140714/sy_66108847664.jpg",
                               @"http://img.zcool.cn/community/010deb5639b56e32f87512f66e39c7.jpg",
                               @"http://pic2.ooopic.com/13/22/59/71bOOOPIC78_1024.jpg",
                               @"http://img01.taopic.com/150404/234768-15040410164141.jpg",
                               @"http://img.zcool.cn/community/0199e656173af332f875313dd11645.jpg",
                               @"http://pic2.ooopic.com/13/50/88/14bOOOPIC24_1024.jpg",
                               @"http://img.taopic.com/uploads/allimg/140221/234971-14022116093840.jpg",
                               @"http://img.zcool.cn/community/013a9e56e2990232f875520f523924.jpg",
                               @"http://img.zcool.cn/community/019fee55eb02696ac7251df87bef4a.jpg",
                               @"http://img.zcool.cn/community/01347a56eaa25432f875a944272fd1.jpg",
                               @"http://pic.35pic.com/normal/09/33/34/8929646_115357591146_2.jpg"];
        [_dataArray addObjectsFromArray:imgArray];
    }
    return _dataArray;
}
#pragma mark-tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = self.dataArray[indexPath.row];
    return [XHWebImageAutoSize imageHeightWithURL:[NSURL URLWithString:url] layoutWidth:MWIDTH-16 estimateHeight:200];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[ImageViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *url = self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [XHWebImageAutoSize cacheImageSizeWithImage:image URL:imageURL completed:^(BOOL result) {
            
            [tableView xh_reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] URL:imageURL];

        }];
        
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
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
