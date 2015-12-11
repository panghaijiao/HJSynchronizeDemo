//
//  ViewController.m
//  HJSynchronizeDemo
//
//  Created by haijiao on 15/7/9.
//  Copyright (c) 2015年 olinone. All rights reserved.
//

#import "ViewController.h"
#import "HJSynchronize.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray     *testGCDArrays;
@property (nonatomic, strong) NSArray     *testQueueArrays;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.testGCDArrays = @[@"串行同步", @"并行同步"];
    self.testQueueArrays = @[@"串行同步", @"并行同步", @"并行同步取消其它任务"];
}

- (void)test_multiTask {
    NSLog(@"\n\n 多线程 \n");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self execTaskA];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self execTaskB];
    });
}

#pragma mark - GCD
- (void)test_gcd_serialSyn {
    NSLog(@"\n\n GCD 串行执行，堵塞线程 \n");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeSerial execSyncBlock:^{
            [self execTaskA];
            NSLog(@"A Finish");
        }];
        NSLog(@"A GOON EXEC");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeSerial execSyncBlock:^{
            [self execTaskB];
            NSLog(@"B Finish");
        }];
        NSLog(@"B GOON EXEC");
    });
}

- (void)test_gcd_concurrentSyn {
    NSLog(@"\n\n GCD 并行执行，不堵塞线程 \n");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeSerial execAsynBlock:^{
            [self execTaskA];
            NSLog(@"A Finish");
        }];
        NSLog(@"A GOON EXEC");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeSerial execAsynBlock:^{
            [self execTaskB];
            NSLog(@"B Finish");
        }];
        NSLog(@"B GOON EXEC");
    });
}

#pragma mark - Queue
- (void)test_serialSyn {
    NSLog(@"\n\n Queue 串行执行，堵塞线程 \n");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeQueue execSyncBlock:^{
            [self execTaskA];
            NSLog(@"A Finish");
        }];
        NSLog(@"A GOON EXEC");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeQueue execSyncBlock:^{
            [self execTaskB];
            NSLog(@"B Finish");
        }];
        NSLog(@"B GOON EXEC");
    });
}

- (void)test_concurrentSyn {
    NSLog(@"\n\n Queue 并行执行，不堵塞线程 \n");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeQueue execAsynBlock:^{
            [self execTaskA];
            NSLog(@"A Finish");
        }];
        NSLog(@"A GOON EXEC");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeQueue execAsynBlock:^{
            [self execTaskB];
            NSLog(@"B Finish");
        }];
        NSLog(@"B GOON EXEC");
    });
}

- (void)test_concurrentSynCancel {
    NSLog(@"\n\n Queue 并行执行的时候可以取消其它任务 \n");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeQueue execAsynBlock:^{
            NSLog(@"B Cancel");
            [HJSynchronizeQueue cancelAllOperations];
            [self execTaskA];
            NSLog(@"A Finish");
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HJSynchronizeQueue execAsynBlock:^{
            NSLog(@"A Cancel");
            [HJSynchronizeQueue cancelAllOperations];
            [self execTaskB];
            NSLog(@"B Finish");
        }];
    });
}

#pragma mark -
- (void)execTaskA {
    for (u_int8_t i = 0; i < 5; i++) {
        NSLog(@"A %d", i);
    }
}

- (void)execTaskB {
    for (u_int8_t i = 0; i < 5; i++) {
        NSLog(@"B %d", i);
    }
}

#pragma mark - 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self test_multiTask];
        return;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self test_gcd_serialSyn];
                break;
            case 1:
                [self test_gcd_concurrentSyn];
                break;
            default:
                break;
        }
        return;
    }
    switch (indexPath.row) {
        case 0:
            [self test_serialSyn];
            break;
        case 1:
            [self test_concurrentSyn];
            break;
        case 2:
            [self test_concurrentSynCancel];
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:return @"";
        case 1:return @"GCD";
        case 2:return @"Queue";
        default:return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:return 1;
        case 1:return self.testGCDArrays.count;
        case 2:return self.testQueueArrays.count;
        default:return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"多线程";
            break;
        case 1:
            cell.textLabel.text = self.testGCDArrays[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = self.testQueueArrays[indexPath.row];
            break;
    }
    
    return cell;
}

@end
