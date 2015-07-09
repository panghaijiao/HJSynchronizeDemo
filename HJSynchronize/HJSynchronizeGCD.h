//
//  HJSynchronizeGCD.h
//  HJSynchronizeDemo
//
//  Created by Haijiao on 15/7/9.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline void onMainThreadAsync(void (^block)())
{
    if ([NSThread isMainThread]) block();
    else dispatch_async(dispatch_get_main_queue(), block);
}

@interface HJSynchronizeGCD : NSObject

+ (void)execSyncBlock:(void (^)())block;
+ (void)execAsynBlock:(void (^)())block;

@end
