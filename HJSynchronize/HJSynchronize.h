//
//  HJSynchronize.h
//  HJSynchronizeDemo
//
//  Created by Haijiao on 15/7/9.
//  Copyright (c) 2015年 olinone. All rights reserved.
//


#import "HJSynchronizeSerial.h"
#import "HJSynchronizeQueue.h"

static inline void onMainThreadAsync(void (^block)())
{
    if ([NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_main_queue(), block);
}

static inline void onMainThreadSync(void (^block)())
{
    if ([NSThread isMainThread]) block();
    else dispatch_sync(dispatch_get_main_queue(), block);
}

static inline void onGlobalThreadAsync(void (^block)())
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static inline void onMainThreadDelayExec(NSTimeInterval second, void (^block)())
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}
