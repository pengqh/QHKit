//
//  Thread.m
//  QHKit
//
//  Created by pengquanhua on 2018/12/14.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "Thread.h"

#define LOCK(...) dispatch_semaphore_wait(self->_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(self->_lock);

@implementation Thread

@end
