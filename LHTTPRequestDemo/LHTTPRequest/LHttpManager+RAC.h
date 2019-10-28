//
//  LHttpManager+RAC.h
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/27.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "LHttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHttpManager (RAC)

- (RACSignal *)signalTaskWithConfiguration:(LNetworkTaskConfiguration *)config;

@end

NS_ASSUME_NONNULL_END
