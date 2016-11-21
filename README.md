

###网络图片尺寸/高度自适应

==============

###前言:
*   1.iOS开发中,常碰到网络图片需要做尺寸适配(使显示出来的图片不变形)
*   2.最好的解决方案是:后台把图片的分辨率拼接在图片的URL地址中,我们截取获得分辨率,从而根据宽高比,来适配imageView尺寸.
*   3.但当后台所给图片URL地址中没有分辨率,他又不肯加时,只好我们自己来解决了.
*   4.XHWebImageAutoSize就是解决3中的这种情况.

###特性:
* 1.异步动态缓存网络图片尺寸,优先从缓存中获取图片尺寸.
* 2.支持UITableView,UICollectionView动态刷新调整imageView尺寸.

###技术交流群(群号:537476189).

### 更新记录:
*    2016.11.21 -- v1.0

## 效果
![](/Demo1.png) ![](/Demo2.png) ![](/Demo3.png)

##API

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

/**
 *  Reload rows
 *
 *  @param indexPaths indexPaths
 *  @param url        imageURL
 */
-(void)xh_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url;

/**
 *  Reload items
 *
 *  @param indexPaths indexPaths
 *  @param url        imageURL
 */
-(void)xh_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths forURL:(NSURL *)url;

```
## 使用方法

####1.UITableView中使用(此处以UITableViewCell 上仅有一个UIImageView为例)(其他示例详见DEMO)
```objc
   
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = self.dataArray[indexPath.row];
    /**
     *  参数1:图片URL
     *  参数2:imageView 宽度
     *  参数3:预估高度,此高度越接近真实高度效果越好
     */
    return [XHWebImageAutoSize imageHeightForURL:[NSURL URLWithString:url] layoutWidth:[UIScreen mainScreen].bounds.size.width-16 estimateHeight:200];
}   

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DemoVC1Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell)
    {
        cell = [[DemoVC1Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    NSString *url = self.dataArray[indexPath.row];
    //加载网络图片使用SDWebImage
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        /**
         *  缓存image size
         */
        [XHWebImageAutoSize storeImageSize:image forURL:imageURL completed:^(BOOL result) {
            
           /**
            *  尺寸缓存成功,刷新该cell
            */
            if(result)  [tableView xh_reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] forURL:imageURL];
            
        }];
        
    }];
    return cell;
}
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