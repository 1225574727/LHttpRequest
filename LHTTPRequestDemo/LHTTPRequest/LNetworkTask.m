//
//  LNetworkTask.m
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/17.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "LNetworkTask.h"

static dispatch_semaphore_t lock;

@interface LNetworkTask()

@property (nonatomic, retain) AFHTTPSessionManager *sessionManager;

@property (nonatomic, retain) NSMutableDictionary <NSNumber *, NSURLSessionTask *>*taskTable;

@end

@implementation LNetworkTask

+ (instancetype)sharedInstance {
    static LNetworkTask *lNetwork;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = dispatch_semaphore_create(1);
        lNetwork = [[LNetworkTask alloc]init];
    });
    return lNetwork;
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    return [self sharedInstance];
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.securityPolicy.validatesDomainName = NO;
        self.sessionManager.securityPolicy.allowInvalidCertificates = YES;
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithURL:(NSString *)urlPath
                                   method:(LNetworkRequestType)method
                                   params:(NSDictionary *)params
                                  hearder:(NSDictionary *)header
                        completionHandler:(LCompletionHandle)completionHandle{
    
    NSString *methodType = method == LNetworkRequestTypeGET ? @"GET": @"POST";
    
    NSMutableURLRequest *request =[[LURLRequest sharedInstance] requestWithURL:urlPath method:methodType params:params header:header];
    
    NSNumber *taskIdentifer;
    
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        //从task表中删除已经请求的任务
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [self.taskTable removeObjectForKey:taskIdentifer];
        dispatch_semaphore_signal(lock);
        
        !completionHandle?: completionHandle(response, responseObject, error);
    }];
    taskIdentifer = @(task.taskIdentifier);
    return task;
}

- (NSNumber *)dispatchTaskWithURL:(NSString *)urlPath
                         method:(LNetworkRequestType)method
                         params:(NSDictionary *)params
                        hearder:(NSDictionary *)header
              completionHandler:(LCompletionHandle)completionHandler {
    return [self identifierForTask:[self dataTaskWithURL:urlPath method:method params:params hearder:header completionHandler:completionHandler]];
}

- (NSNumber *)identifierForTask:(NSURLSessionDataTask *)task {
    if (!task) return @(-1);
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.taskTable setObject:task forKey:@(task.taskIdentifier)];
    dispatch_semaphore_signal(lock);
    
    [task resume];
    return @(task.taskIdentifier);
}

- (void)cancelAllTask {
    for (NSURLSessionTask *task in self.taskTable.allValues) {
        [task cancel];
    }
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.taskTable removeAllObjects];
    dispatch_semaphore_signal(lock);
}

-(void)cancelTaskWithIdentifier:(NSNumber *)taskIdentifier {
    [self.taskTable[taskIdentifier] cancel];
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.taskTable removeObjectForKey:taskIdentifier];
    dispatch_semaphore_signal(lock);
}

@end
