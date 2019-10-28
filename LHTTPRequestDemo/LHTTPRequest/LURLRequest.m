//
//  LURLRequest.m
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/17.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "LURLRequest.h"

@interface LURLRequest ()

@property (nonatomic, retain) AFHTTPRequestSerializer *requestSerializer;

@end

@implementation LURLRequest

+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LURLRequest *lRequest;
    dispatch_once(&onceToken, ^{
        lRequest = [LURLRequest new];
    });
    return lRequest;
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    return [self sharedInstance];
//}

- (NSMutableURLRequest *)requestWithURL:(NSString *)urlPath
                                 method:(NSString *)method
                                 params:(NSDictionary *)params
                                 header:(NSDictionary *)header {
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:urlPath parameters:params error:nil];
    request.timeoutInterval = RequestTimeoutInterval;
    [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [request setValue:obj forHTTPHeaderField:key];
    }];
    return request;
}

#pragma makr - Lazy
- (AFHTTPRequestSerializer *) requestSerializer {
    if (!_requestSerializer) {
        _requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _requestSerializer;
}


@end
