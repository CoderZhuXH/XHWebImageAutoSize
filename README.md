
# XHWebImageAutoSize

### 网络图片尺寸/高度自适应解决方案

[![AppVeyor](https://img.shields.io/appveyor/ci/gruntjs/grunt.svg?maxAge=2592000)](https://github.com/CoderZhuXH/XHWebImageAutoSize)
[![Version Status](https://img.shields.io/cocoapods/v/XHWebImageAutoSize.svg?style=flat)](http://cocoadocs.org/docsets/XHWebImageAutoSize)
[![Support](https://img.shields.io/badge/support-iOS%207%2B-brightgreen.svg)](https://github.com/CoderZhuXH/XHWebImageAutoSize)
[![Pod Platform](https://img.shields.io/cocoapods/p/XHWebImageAutoSize.svg?style=flat)](http://cocoadocs.org/docsets/XHWebImageAutoSize/)
[![Pod License](https://img.shields.io/cocoapods/l/XHWebImageAutoSize.svg?style=flat)](https://github.com/CoderZhuXH/XHWebImageAutoSize/blob/master/LICENSE)

==============

### 前言:
*   1.iOS开发中,常碰到网络图片需要做尺寸适配(使显示出来的图片不变形)
*   2.最好的解决方案是:后台把图片的分辨率拼接在图片的URL地址中,我们截取获得分辨率,从而根据宽高比,来适配imageView尺寸.
*   3.但往往有些时候由于各种原因,图片分辨率后台那边加不上去,没办法只好我们自己来解决了.
*   4.XHWebImageAutoSize就是解决3中的这种情况.

### 特性:
* 1.异步缓存网络图片尺寸,优先从缓存中获取图片尺寸.
* 2.UITableView,UICollectionView UI动态更新.

### 技术交流群(群号:537476189).


## 效果
![](/ScreenShot/Demo1.png) ![](/ScreenShot/Demo2.png) ![](/ScreenShot/Demo3.png)


## 使用方法

####    1.此处以在UITableView中使用,UITableViewCell上仅有一个UIImageView为例(其他示例详见DEMO)
```objc
   
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = self.dataArray[indexPath.row];
    /**
     *  参数1:图片URL
     *  参数2:imageView 宽度
     *  参数3:预估高度(此高度仅在图片尚未加载出来前起作用,不影响真实高度)
     */
    return [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width-16 estimateHeight:200];
}   

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DemoVC1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[DemoVC1Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *url = self.dataArray[indexPath.row];
    //加载网络图片使用SDWebImage
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        /** 缓存image size */
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            /** reload  */
            if(result)  [tableView  xh_reloadDataForURL:imageURL];
        }];
    }];
    return cell;
}
```
##  API

*   1.获取图片高度/尺寸及缓存相关

```objc
/**
 *   Get image height
 *
 *  @param url            imageURL
 *  @param layoutWidth    layoutWidth
 *  @param estimateHeight estimateHeight(default 100)
 *
 *  @return imageHeight
 */
+(CGFloat)imageHeightForURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight;

/**
 *  Get image width
 *
 *  @param url            imageURL
 *  @param layoutHeight   layoutHeight
 *  @param estimateWidth estimateWidth(default 90)
 *
 *  @return imageHeight
 */
+(CGFloat)imageWidthForURL:(NSURL *)url layoutHeight:(CGFloat)layoutHeight estimateWidth:(CGFloat )estimateWidth;

/**
 *  Get image size from cache,query the disk cache synchronously after checking the memory cache
 *
 *  @param url imageURL
 *
 *  @return imageSize
 */
+(CGSize )imageSizeFromCacheForURL:(NSURL *)url;

/**
 *  Store an imageSize into memory and disk cache
 *
 *  @param image          image
 *  @param url            imageURL
 *  @param completedBlock An block that should be executed after the imageSize has been saved (optional)
 */
+(void)storeImageSize:(UIImage *)image forURL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock;

```

*   2.tableView reload

```objc

/**
 Reload tableView

 @param url imageURL
 */
-(void)xh_reloadDataForURL:(NSURL *)url;

```

*   3.collectionView reload

```objc

/**
 Reload collectionView
 
 @param url imageURL
 */
-(void)xh_reloadDataForURL:(NSURL *)url;

```
##  安装
### 1.手动添加:<br>
*   1.将 XHWebImageAutoSize 文件夹添加到工程目录中<br>
*   2.导入 XHWebImageAutoSize.h

### 2.CocoaPods:<br>
*   1.在 Podfile 中添加 pod 'XHWebImageAutoSize'<br>
*   2.执行 pod install 或 pod update<br>
*   3.导入 XHWebImageAutoSize.h

##  Tips
*   1.如果发现pod search XHWebImageAutoSize 搜索出来的不是最新版本，需要在终端执行cd ~/desktop退回到desktop，然后执行pod setup命令更新本地spec缓存（需要几分钟），然后再搜索就可以了
*   2.如果你发现你执行pod install后,导入的不是最新版本,请删除Podfile.lock文件,在执行一次 pod install
*   3.如果在使用过程中遇到BUG，希望你能Issues我，谢谢（或者尝试下载最新的代码看看BUG修复没有）

##  系统要求
*   该项目最低支持 iOS 7.0 和 Xcode 7.0

##  许可证
XHWebImageAutoSize 使用 MIT 许可证，详情见 LICENSE 文件