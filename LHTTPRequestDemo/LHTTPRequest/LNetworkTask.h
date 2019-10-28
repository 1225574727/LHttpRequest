//
//  LNetworkTask.h
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/17.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LURLRequest.h"

typedef void(^LCompletionHandle) (NSURLResponse * _Nullable response, id responseObject, NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface LNetworkTask : NSObject

+ (instancetype)sharedInstance;

- (NSNumber *)dispatchTaskWithURL:(NSString *)urlPath
                         method:(LNetworkRequestType)method
                         params:(NSDictionary *)params
                        hearder:(NSDictionary *)header
              completionHandler:(LCompletionHandle)completionHandler;

-(void)cancelAllTask;
-(void)cancelTaskWithIdentifier:(NSNumber *)taskIdentifier;

@end

NS_ASSUME_NONNULL_END
