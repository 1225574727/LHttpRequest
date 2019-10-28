//
//  LHttpManager+RAC.m
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/27.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "LHttpManager+RAC.h"

@implementation LHttpManager (RAC)

- (RACSignal *)signalTaskWithConfiguration:(LNetworkTaskConfiguration *)config {
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSNumber *taskIdentifier = [self dispatchTaskWithConfiguration:config completionHandler:^(id result, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            }else {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [self cancelTask:taskIdentifier];
        }];
    }].deliverOnMainThread;
}

@end
