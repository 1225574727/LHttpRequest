//
//  LNetworkCacheManager.h
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/17.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHttpRequestConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LNetworkCache : NSObject

+ (instancetype)cacheWithData:(id)data;
+ (instancetype)cacheWithData:(id)data validTimeInterval:(NSUInteger)timeInterval;

- (id)data;
-(BOOL)isValid;

@end

@interface LNetworkCacheManager : NSObject

+ (instancetype)sharedManager;
- (void)removeObjectForKey:(id)key;
- (void)setObject:(LNetworkCache *)objct forKey:(id)key;
- (LNetworkCache *)objectForKey:(id)key;

@end

NS_ASSUME_NONNULL_END
