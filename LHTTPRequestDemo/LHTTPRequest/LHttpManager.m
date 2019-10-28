//
//  LHttpManager.m
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/18.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "LHttpManager.h"
#import "LHttpTool.h"
#import "LNetworkCacheManager.h"

@implementation LHttpConfiguration

@end

@implementation LNetworkTaskConfiguration

@end

@interface LHttpManager ()

@property (nonatomic, retain) NSMutableArray *taskQueue;

@end

@implementation LHttpManager

- (instancetype)init {
    if (self = [super init]) {
        self.taskQueue = [NSMutableArray array];
    }
    return self;
}

- (void)cancelAllTask {
    for (NSNumber *identifier in self.taskQueue) {
        [[LNetworkTask sharedInstance] cancelTaskWithIdentifier:identifier];
    }
    [self.taskQueue removeAllObjects];
}

- (void)cancelTask:(NSNumber *)taskIdentifier {
    [[LNetworkTask sharedInstance] cancelTaskWithIdentifier:taskIdentifier];
    [self.taskQueue removeObject:taskIdentifier];
}

- (NSNumber *)dispatchTaskWithConfiguration:(LNetworkTaskConfiguration *)config  completionHandler:(LNetworkTaskCompletionHandler)handler {
    
    NSString *cacheKey;
    if (config.cacheValidTimeInterval  > 0){
        NSMutableString *mutableString = [NSMutableString stringWithString:config.url];
        NSMutableArray *paramsKeys = [config.params.allKeys mutableCopy];
        if (paramsKeys.count > 1) {
            [paramsKeys sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
            
            [paramsKeys enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [mutableString appendFormat:@"&%@=%@", obj, config.params[obj]];
            }];
            
            cacheKey = [LHttpTool lMd5String:[mutableString copy]];
            
            LNetworkCache *cache = [[LNetworkCacheManager sharedManager]objectForKey:cacheKey];
            //查看内存中是否有
            if (!cache.isValid) {
                [[LNetworkCacheManager sharedManager] removeObjectForKey:cacheKey];
            } else {
                NSLog(@"内存有效，内存中获取数据");
                handler ? handler(cache.data, nil) : nil;
                return @(-1);
            }
        }
    }
    
    NSNumber *taskIdentifier = [[LNetworkTask sharedInstance] dispatchTaskWithURL:config.url
                                                                           method:config.requestType
                                                                           params:config.params
                                                                          hearder:config.header
                                                                completionHandler:^(NSURLResponse * _Nullable response, id responseObject, NSError * _Nullable error) {
                                                                    
                                                                    id result = responseObject;
                                                                    //error通用层 处理error
                                                                    NSError *formatError;
                                                                    if (error != nil) {
                                                                        
                                                                        int code = [result[@"code"] intValue];
                                                                        if (code != LHttpRequestSuccesss) {
                                                                            formatError = [NSError errorWithDomain:result[@"msg"]?:LNoDataErrorTip code:code userInfo:nil];
                                                                        }
                                                                    }
                                                                    if (formatError == nil && config.modelClass != nil) {
                                                                        
                                                                        NSDictionary *json = responseObject;
                                                                        
                                                                        LNetworkCache *cache =[LNetworkCache cacheWithData:responseObject validTimeInterval:config.cacheValidTimeInterval];
                                                                        [[LNetworkCacheManager sharedManager] setObject:cache forKey:cacheKey];
                                                                        
                                                                        if (config.valuePath.length > 0) {
                                                                            json = [json valueForKey:config.valuePath];
                                                                        }
                                                                        
                                                                        if ([json isKindOfClass:[NSDictionary class]]) {
                                                                            if (json) {
                                                                                //数据转模型
                                                                                result = [config.modelClass yy_modelWithJSON:json];
                                                                            }else {
                                                                                formatError = [NSError errorWithDomain:LNoDataErrorTip code:LNetworkTaskErrorNoData userInfo:nil];                                                                            }
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                    !handler?: handler(result, formatError);
                                                                }];
    [self.taskQueue addObject:taskIdentifier];
    return taskIdentifier;
}

@end
