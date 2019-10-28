//
//  ViewController.m
//  LHTTPRequestDemo
//
//  Created by 刘明飞 on 2019/10/16.
//  Copyright © 2019 刘明飞. All rights reserved.
//

#import "ViewController.h"
#import "LHttpManager.h"
#import "LHttpManager+RAC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    LNetworkTaskConfiguration *configuration = [[LNetworkTaskConfiguration alloc]init];
    configuration.url = @"https://xxx.do";
    configuration.requestType = LNetworkRequestTypePOST;
    configuration.header = @{@"Content-Type":@"application/json"};
//    [[LHttpManager alloc] dispatchTaskWithConfiguration:configuration completionHandler:^(id result, NSError *error) {
//
//        NSLog(@"%@", result);
//    }];
    
    [[[LHttpManager alloc] signalTaskWithConfiguration:configuration] subscribeNext:^(id  _Nullable x) {
        NSLog(@"RAC result:%@",x);
    }];
}

@end
