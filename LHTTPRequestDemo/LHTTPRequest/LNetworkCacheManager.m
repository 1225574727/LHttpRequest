//
//  LNetworkCacheManager.m
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/17.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "LNetworkCacheManager.h"

@interface LNetworkCache ()

@property (nonatomic, retain) id data;
@property (nonatomic, assign) NSTimeInterval cacheTime;
@property (nonatomic, assign) NSUInteger validTimeInterval;

@end

@implementation LNetworkCache

+ (instancetype)cacheWithData:(id)data {
    
    return [self cacheWithData:data validTimeInterval:DataValidTimeInterval];
}

+ (instancetype)cacheWithData:(id)data validTimeInterval:(NSUInteger)timeInterval {
    
    LNetworkCache *cache = [LNetworkCache new];
    cache.data = data;
    cache.cacheTime = [[NSDate date] timeIntervalSince1970];
    cache.validTimeInterval = timeInterval > 0? timeInterval : DataValidTimeInterval;
    return cache;
}

-(BOOL)isValid {
    if (self.data) {
        return [[NSDate date] timeIntervalSince1970] - self.cacheTime < self.validTimeInterval;
    }
    return NO;
}


@end

@interface LNetworkCacheManager ()

@property (nonatomic, retain) NSCache *cache;

@end

@implementation LNetworkCacheManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

+ (instancetype)sharedManager {
    static LNetworkCacheManager *cacheManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheManager = [LNetworkCacheManager new];
        cacheManager.cache = [NSCache new];
        cacheManager.cache.totalCostLimit = 1024 * 1024 * 100;
    });
    return cacheManager;
}

- (void)removeObjectForKey:(id)key {
    
    [self.cache removeObjectForKey:key];
}
- (void)setObject:(LNetworkCache *)objct forKey:(id)key {
    
    [self.cache setObject:objct forKey:key];
}

- (LNetworkCache *)objectForKey:(id)key {
    
    return [self.cache objectForKey:key];
}

@end
