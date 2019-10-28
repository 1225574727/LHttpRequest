//
//  LHttpManager.h
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/18.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNetworkTask.h"
#import "LHttpRequestError.h"

NS_ASSUME_NONNULL_BEGIN
@interface LHttpConfiguration : NSObject

@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) NSDictionary *params;
@property (nonatomic, retain) NSDictionary *header;
@property (nonatomic, assign) LNetworkRequestType requestType;

@end

@interface LNetworkTaskConfiguration : LHttpConfiguration

@property (nonatomic, copy) NSString *valuePath; //取值的key
@property (nonatomic, retain) Class modelClass;
@property (nonatomic, assign) NSTimeInterval cacheValidTimeInterval;

@end

@interface LHttpManager : NSObject

- (void)cancelAllTask;
- (void)cancelTask:(NSNumber *)taskIdentifier;

- (NSNumber *)dispatchTaskWithConfiguration:(LNetworkTaskConfiguration *)config  completionHandler:(LNetworkTaskCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
