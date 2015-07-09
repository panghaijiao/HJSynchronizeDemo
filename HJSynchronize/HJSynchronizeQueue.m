//
//  HJSynchronizeQueue.m
//  HJSynchronizeManager
//
//  Created by haijiao on 15/7/7.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import "HJSynchronizeQueue.h"

@implementation HJSynchronizeQueue

+ (HJSynchronizeQueue *)synchronizeQueue
{
    static HJSynchronizeQueue * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.maxConcurrentOperationCount = 1;
    }
    return self;
}

+ (void)cancelAllOperations
{
    [[HJSynchronizeQueue synchronizeQueue] cancelAllOperations];
}

#pragma mark - sync
+ (void)execSyncBlock:(void (^)())block
{
    [[HJSynchronizeQueue synchronizeQueue] execSyncBlock:block];
}

- (void)execSyncBlock:(void (^)())block
{
    if (NSOperationQueue.currentQueue == self) {
        block();
    } else {
        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
        [self addOperations:@[operation] waitUntilFinished:YES];
    }
}

#pragma mark - asyn
+ (NSOperation *)execAsynBlock:(void (^)())block
{
    return [[HJSynchronizeQueue synchronizeQueue] execAsynBlock:block];
}

- (NSOperation *)execAsynBlock:(void (^)())block
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:block];
    [self addOperation:operation];
    return operation;
}

@end
