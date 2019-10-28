//
//  LURLRequest.h
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/17.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHttpRequestConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LURLRequest : NSObject

+(instancetype)sharedInstance;


- (NSMutableURLRequest *)requestWithURL:(NSString *)urlPath
                                 method:(NSString *)method
                                 params:(NSDictionary *)params
                                 header:(NSDictionary *)header;



@end

NS_ASSUME_NONNULL_END
