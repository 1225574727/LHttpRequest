//
//  LHttpRequestConfig.h
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/17.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#ifndef LHttpRequestConfig_h
#define LHttpRequestConfig_h

typedef enum : NSUInteger {
    LNetworkRequestTypeGET,
    LNetworkRequestTypePOST
} LNetworkRequestType;

#define RequestTimeoutInterval 30
#define DataValidTimeInterval 60*60

#endif /* LHttpRequestConfig_h */
