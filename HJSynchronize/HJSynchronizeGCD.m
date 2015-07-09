//
//  HJSynchronizeGCD.m
//  HJSynchronizeDemo
//
//  Created by Haijiao on 15/7/9.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import "HJSynchronizeGCD.h"

#if OS_OBJECT_USE_OBJC
#define HJDispatchQueueRelease(__v)
#else
#define HJDispatchQueueRelease(__v) (dispatch_release(__v));
#endif

@interface HJSynchronizeGCD () {
    dispatch_queue_t _queue;
}

@end

@implementation HJSynchronizeGCD

+ (HJSynchronizeGCD *)synchronizeQueue
{
    static HJSynchronizeGCD * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)dealloc
{
    if (_queue) {
        HJDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
}

- (instancetype)init
{
    if (self = [super init]) {
        _queue = dispatch_queue_create("com.olinone.synchronize.serialQueue", NULL);
        dispatch_queue_t dQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_set_target_queue(_queue, dQueue);
    }
    return self;
}

#pragma mark - sync
+ (void)execSyncBlock:(void (^)())block
{
    [[HJSynchronizeGCD synchronizeQueue] execSyncBlock:block];
}

- (void)execSyncBlock:(void (^)())block
{
    dispatch_sync(_queue, ^{
        block();
    });
}

#pragma mark - asyn
+ (void)execAsynBlock:(void (^)())block
{
    [[HJSynchronizeGCD synchronizeQueue] execAsynBlock:block];
}

- (void)execAsynBlock:(void (^)())block
{
    dispatch_async(_queue, ^{
        block();
    });
}

@end
