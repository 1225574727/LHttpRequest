//
//  LHttpTool.m
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/18.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "LHttpTool.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LHttpTool

+ (NSString *)lMd5String:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [self l_md5:result];
}

+ (NSString *)l_md5:(unsigned char [16]) result {
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
