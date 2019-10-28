//
//  LHttpRequestError.h
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/18.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#ifndef LHttpRequestError_h
#define LHttpRequestError_h

typedef enum : NSUInteger {
    LHttpRequestSuccesss = 1,
    LHttpRequestErrorTimeOut=1001,
    LHttpRequestErrorNotConnected,
    LHttpRequestErrorCancel,
    LNetworkTaskErrorNoData,
} LHttpRequestErrorType;

typedef void (^LNetworkTaskCompletionHandler)(id result, NSError *error);

static NSString *LNoDataErrorTip = @"没有任何报错信息";

#endif /* LHttpRequestError_h */
