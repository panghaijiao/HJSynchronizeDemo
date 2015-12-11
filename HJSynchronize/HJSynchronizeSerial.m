//
//  HJSynchronizeSerial.m
//  TTPod
//
//  Created by haijiao on 15/10/29.
//
//

#import "HJSynchronizeSerial.h"

#if OS_OBJECT_USE_OBJC
#define HJDispatchQueueRelease(__v)
#else
#define HJDispatchQueueRelease(__v) (dispatch_release(__v));
#endif

@interface HJSynchronizeSerial () {
    dispatch_queue_t _queue;
}

@end

@implementation HJSynchronizeSerial

+ (HJSynchronizeSerial *)synchronizeQueue {
    static HJSynchronizeSerial * _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)dealloc {
    if (_queue) {
        HJDispatchQueueRelease(_queue);
        _queue = 0x00;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        NSString *identifier = [@"com.ttpod.music." stringByAppendingString:[self randomBitString]];
        _queue = dispatch_queue_create([identifier UTF8String], DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t dQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
        dispatch_set_target_queue(_queue, dQueue);
    }
    return self;
}

- (NSString *)randomBitString {
    u_int8_t length = 10;
    char data[length];
    for (int x = 0; x< length; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

#pragma mark - sync
+ (void)execSyncBlock:(void (^)())block {
    [[HJSynchronizeSerial synchronizeQueue] execSyncBlock:block];
}

- (void)execSyncBlock:(void (^)())block {
    dispatch_sync(_queue, ^{
        block();
    });
}

#pragma mark - asyn
+ (void)execAsynBlock:(void (^)())block {
    [[HJSynchronizeSerial synchronizeQueue] execAsynBlock:block];
}

- (void)execAsynBlock:(void (^)())block {
    dispatch_async(_queue, ^{
        block();
    });
}

@end
