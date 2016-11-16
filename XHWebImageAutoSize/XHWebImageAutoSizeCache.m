//
//  XHWebImageAutoSizeCache.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 ruiec.cn. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "XHWebImageAutoSizeCache.h"
#import <CommonCrypto/CommonDigest.h>

#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

@interface XHWebImageAutoSizeCache()

@property(nonatomic,strong)NSCache * cache;

@end
@implementation XHWebImageAutoSizeCache

+(XHWebImageAutoSizeCache *)shardManger{
    
    static XHWebImageAutoSizeCache *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken,^{
        
        instance = [[XHWebImageAutoSizeCache alloc] init];
        
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.cache = [[NSCache alloc] init];
    }
    return self;
}
+(CGFloat)imageHeightWithURL:(NSURL *)url layoutWidth:(CGFloat)layoutWidth estimateHeight:(CGFloat )estimateHeight
{
    CGFloat showHeight = estimateHeight;
    CGSize size = [self readImageSizeCacheWithURL:url];
    CGFloat imgWidth = size.width;
    CGFloat imgHeight = size.height;
    if(imgWidth>0 && imgHeight >0)
    {
        showHeight = layoutWidth/imgWidth*imgHeight;
    }
    return showHeight;
}
//存储size
+(BOOL)cacheImageSizeWithImage:(UIImage *)image URL:(NSURL *)url
{
    CGSize imgSize = image.size;
    NSDictionary *sizeDict = @{@"width":@(imgSize.width),@"height":@(imgSize.height)};
    NSData *data = [self dataFromDict:sizeDict];
   [[self shardManger].cache setObject:data forKey:[self sizeKeyWithURL:url]];
   return [[NSFileManager defaultManager] createFileAtPath:[self sizeKeyPathWithURL:url] contents:data attributes:nil];
}

//存储reload
+(BOOL)cacheReloadState:(BOOL)state URL:(NSURL *)url
{
    NSString *stateString = @"0";
    if(state) stateString = @"1";
    NSDictionary *stateDict = @{@"reloadSate":stateString};
    NSData *data = [self dataFromDict:stateDict];
    [[self shardManger].cache setObject:data forKey:[self reloadKeyWithURL:url]];
    return [[NSFileManager defaultManager] createFileAtPath:[self reloadKeyPathWithURL:url] contents:data attributes:nil];
}
+(void)cacheReloadState:(BOOL)state URL:(NSURL *)url completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result=[self cacheReloadState:state URL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(completedBlock)
            {
                completedBlock(result);
            }
        });
    });
}

//读取缓存size
+(CGSize)readImageSizeCacheWithURL:(NSURL *)url
{
    NSDictionary *sizeDict;
    NSData *data = [[XHWebImageAutoSizeCache shardManger].cache objectForKey:[self sizeKeyWithURL:url]];
    if(data)
    {
        sizeDict = [self dictFromData:data];
    }
    else
    {
        sizeDict = [self dictFromCacheKeyPath:[self sizeKeyPathWithURL:url]];
    }
    CGFloat width = [sizeDict[@"width"] floatValue];
    CGFloat height = [sizeDict[@"height"] floatValue];
    CGSize size = CGSizeMake(width, height);
    return size;
}
//读取reload状态
+(BOOL)readReloadStateWithURL:(NSURL *)url
{
    NSDictionary *reloadDict;
    NSData *data = [[XHWebImageAutoSizeCache shardManger].cache objectForKey:[self reloadKeyWithURL:url]];
    if(data)
    {
        reloadDict = [self dictFromData:data];
    }
    else
    {
        reloadDict = [self dictFromCacheKeyPath:[self reloadKeyPathWithURL:url]];
    }
    NSString * state = reloadDict[@"reloadSate"];
    if([state isEqualToString:@"1"]) return YES;
    return NO;
}
+(NSDictionary *)dictFromCacheKeyPath:(NSString *)cacheKeyPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cacheKeyPath isDirectory:nil] == YES) {
        NSData *data = [fileManager contentsAtPath:cacheKeyPath];
        return [self dictFromData:data];
    }
    return nil;
}
+(NSData *)dataFromDict:(NSDictionary *)dict
{
    if(dict==nil) return nil;
    NSError *error;
    NSData *data =[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        DebugLog(@"ERROR, faild to get json data");
        return nil;
    }
    return data;
}
+(NSDictionary *)dictFromData:(NSData *)data
{
    if(data==nil) return nil;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}
+ (NSString *)md5StringFromString:(NSString *)string {
    
    if(string == nil || [string length] == 0)  return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+(void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}
+ (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        DebugLog(@"create cache directory failed, error = %@", error);
    } else {
        
        DebugLog(@"path = %@",path);
        [self addDoNotBackupAttribute:path];
    }
}
+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        DebugLog(@"error to set do not backup attribute, error = %@", error);
    }
}
//size keyPath
+ (NSString *)sizeKeyPathWithURL:(NSURL *)url{
    
    NSString *path = [self sizeCacheDirectory];
    [self checkDirectory:path];
    NSString *sizeKey = [self sizeKeyWithURL:url];
    path = [path stringByAppendingPathComponent:sizeKey];
    return path;
}
//reload KeyPath
+ (NSString *)reloadKeyPathWithURL:(NSURL *)url{
    
    NSString *path = [self reloadCacheDirectory];
    [self checkDirectory:path];
    NSString *reloadKey = [self reloadKeyWithURL:url];
    path = [path stringByAppendingPathComponent:reloadKey];
    return path;
}

//url key
+(NSString *)sizeKeyWithURL:(NSURL *)url
{
    NSString *urlString = url.absoluteString;
    NSString *urlName = [NSString stringWithFormat:@"sizeUrlName=%@",urlString];
    NSString *urlKey = [self md5StringFromString:urlName];
    return urlKey;
}
//reload key
+(NSString *)reloadKeyWithURL:(NSURL *)url
{
    NSString *urlString = url.absoluteString;
    NSString *urlName = [NSString stringWithFormat:@"reloadUrlName=%@",urlString];
    NSString *reloadKey = [self md5StringFromString:urlName];
    return reloadKey;
}

//size缓存文件夹
+(NSString *)sizeCacheDirectory
{
    return [[self baseCacheDirectory] stringByAppendingPathComponent:@"sizeCache"];
}
//reload缓存文件夹
+(NSString *)reloadCacheDirectory
{
    return [[self baseCacheDirectory] stringByAppendingPathComponent:@"reloadCache"];
}
+(NSString *)baseCacheDirectory
{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"XHWebImageAutoSizeCache"];
    return path;

}

@end
