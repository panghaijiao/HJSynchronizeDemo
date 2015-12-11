//
//  HJSynchronizeSerial.h
//  TTPod
//
//  Created by haijiao on 15/10/29.
//
//

#import <Foundation/Foundation.h>

@interface HJSynchronizeSerial : NSObject

+ (void)execSyncBlock:(void (^)())block;
+ (void)execAsynBlock:(void (^)())block;

- (void)execSyncBlock:(void (^)())block;
- (void)execAsynBlock:(void (^)())block;

@end
