//
//  ViewController.m
//  HJSynchronizeDemo
//
//  Created by haijiao on 15/7/9.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import "ViewController.h"
#import "HJSynchronizeQueue.h"

@interface ViewController ()

@property (nonatomic, strong) NSOperation *operationA;
@property (nonatomic, strong) NSOperation *operationB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.operationA = [HJSynchronizeQueue execAsynBlock:^{
            for (u_int8_t i = 0; i < 5; i++) {
                NSLog(@"A %d", i);
            }
            [self.operationB cancel];
        }];
        NSLog(@"A Finish");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.operationB = [HJSynchronizeQueue execAsynBlock:^{
            for (u_int8_t i = 0; i < 5; i++) {
                NSLog(@"B %d", i);
            }
            [self.operationA cancel];
        }];
        NSLog(@"B Finish");
    });
    
}

@end
