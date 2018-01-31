//
//  NSString+XHWebImageAutoSize.m
//  XHWebImageAutoSizeExample
//
//  Created by zhuxiaohui on 2016/11/16.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  https://github.com/CoderZhuXH/XHWebImageAutoSize

#import "NSString+XHWebImageAutoSize.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (XHWebImageAutoSize)
-(NSString *)sizeKeyName{
    NSString *keyName = [NSString stringWithFormat:@"sizeKeyName:%@",self];
    return keyName.md5String;
}
-(NSString *)reloadKeyName{
    NSString *keyName = [NSString stringWithFormat:@"reloadKeyName:%@",self];
    return keyName.md5String;
}
-(NSString *)md5String{
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
