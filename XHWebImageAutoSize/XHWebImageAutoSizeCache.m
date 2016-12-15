//
//  XHWebImageAutoSizeCache.m
//  XHWebImageHeightLayoutExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "XHWebImageAutoSizeCache.h"
#import <CommonCrypto/CommonDigest.h>

#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

@interface NSString (CacheFileName)

@property(nonatomic,copy ,readonly)NSString * sizeKeyName;
@property(nonatomic,copy ,readonly)NSString * reloadKeyName;
@property(nonatomic,copy ,readonly)NSString * md5String;

@end

@implementation NSString (CacheKeyName)

-(NSString *)sizeKeyName{

    NSString *keyName = [NSString stringWithFormat:@"sizeKeyName:%@",self];
    return keyName.md5String;
    
}
-(NSString *)reloadKeyName{
    
    NSString *keyName = [NSString stringWithFormat:@"reloadKeyName:%@",self];
    return keyName.md5String;
}
-(NSString *)md5String
{
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
@end


@interface XHWebImageAutoSizeCache()

@property(nonatomic,strong)NSCache * memCache;
@property(nonnull,strong)NSFileManager *fileManager;

@end
@implementation XHWebImageAutoSizeCache

+(XHWebImageAutoSizeCache *)shardCache{
    
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
        
        self.memCache = [[NSCache alloc] init];
        self.fileManager = [NSFileManager defaultManager];
    }
    return self;
}

-(BOOL)storeImageSize:(UIImage *)image forKey:(NSString *)key{

    if(!image || !key) return NO;
    
    CGSize imgSize = image.size;
    NSDictionary *sizeDict = @{@"width":@(imgSize.width),@"height":@(imgSize.height)};
    NSData *data = [self dataFromDict:sizeDict];
    NSString *keyName = key.sizeKeyName;
    [self.memCache setObject:data forKey:keyName];
    return [self.fileManager createFileAtPath:[self sizeCachePathForKey:keyName] contents:data attributes:nil];
    
}

-(void)storeImageSize:(UIImage *)image forKey:(NSString *)key completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result = [self storeImageSize:image forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(completedBlock)
            {
                completedBlock(result);
            }
        });
    });
    
}
-(BOOL)storeReloadState:(BOOL)state forKey:(NSString *)key{
    
    if(!key) return NO;
    NSString *stateString = @"0";
    if(state) stateString = @"1";
    NSDictionary *stateDict = @{@"reloadSate":stateString};
    NSData *data = [self dataFromDict:stateDict];
    NSString *keyName = key.reloadKeyName;
    [self.memCache setObject:data forKey:keyName];
    return [self.fileManager createFileAtPath:[self reloadCachePathForKey:keyName] contents:data attributes:nil];
}
-(void)storeReloadState:(BOOL)state forKey:(NSString *)key completed:(XHWebImageAutoSizeCacheCompletionBlock)completedBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL result = [self storeReloadState:state forKey:key];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(completedBlock)
            {
                completedBlock(result);
            }
        });
    });
    
}
-(CGSize)imageSizeFromCacheForKey:(NSString *)key{

    NSString *keyName = key.sizeKeyName;
    NSData *data = [self dataFromMemCacheForKey:keyName];
    if(!data)
    {
       data = [self dataFromDiskCacheForKey:keyName isSizeCache:YES];
    }
    NSDictionary *sizeDict = [self dictFromData:data];
    CGFloat width = [sizeDict[@"width"] floatValue];
    CGFloat height = [sizeDict[@"height"] floatValue];
    CGSize size = CGSizeMake(width, height);
    return size;
}

-(BOOL)reloadStateFromCacheForKey:(NSString *)key{

    NSString *keyName = key.reloadKeyName;
    NSData *data = [self dataFromMemCacheForKey:keyName];
    if(!data)
    {
       data = [self dataFromDiskCacheForKey:keyName isSizeCache:NO];
    }
    NSDictionary *reloadDict = [self dictFromData:data];
    NSInteger state = [reloadDict[@"reloadSate"] integerValue];
    if(state ==1) return YES;
    return NO;
}

#pragma mark - XHWebImageAutoSizeCache (private)

-(NSData *)dataFromMemCacheForKey:(NSString *)key{

    return [self.memCache objectForKey:key];
}
-(NSData *)dataFromDiskCacheForKey:(NSString *)key isSizeCache:(BOOL)isSizeCache{

    NSString *path = [self sizeCachePathForKey:key];
    
    if(!isSizeCache) path =[self reloadCachePathForKey:key];

    if ([self.fileManager fileExistsAtPath:path isDirectory:nil] == YES) {
        
         return [self.fileManager contentsAtPath:path];
    }
    return nil;
   
}
-(NSData *)dataFromDict:(NSDictionary *)dict
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
-(NSDictionary *)dictFromData:(NSData *)data
{
    if(data==nil) return nil;
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

-(NSString *)sizeCachePathForKey:(NSString *)key
{
    return [self cachePathForKey:key inPath:[self sizeCacheDirectory]];
}

-(NSString *)reloadCachePathForKey:(NSString *)key
{
    return [self cachePathForKey:key inPath:[self reloadCacheDirectory]];
}
- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path {
    
    [self checkDirectory:path];
    return [path stringByAppendingPathComponent:key];
}

-(NSString *)sizeCacheDirectory
{
    return [[self baseCacheDirectory] stringByAppendingPathComponent:@"SizeCache"];
}

-(NSString *)reloadCacheDirectory
{
    return [[self baseCacheDirectory] stringByAppendingPathComponent:@"ReloadCache"];
}
-(NSString *)baseCacheDirectory
{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"XHWebImageAutoSizeCache"];
    return path;
    
}
-(void)checkDirectory:(NSString *)path {

    BOOL isDir;
    if (![self.fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        
        if (!isDir) {
            NSError *error = nil;
            [self.fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}
- (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        DebugLog(@"create cache directory failed, error = %@", error);
    } else {
        
        //DebugLog(@"path = %@",path);
        [self addDoNotBackupAttribute:path];
    }
}
- (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        DebugLog(@"error to set do not backup attribute, error = %@", error);
    }
}

@end

