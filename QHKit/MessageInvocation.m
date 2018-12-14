//
//  MessageInvocation.m
//  QHKit
//
//  Created by pengquanhua on 2018/12/14.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "MessageInvocation.h"
#import <objc/runtime.h>

@interface BBMessageForwardProxy : NSObject

- (void)bb_dealNotRecognizedMessage:(NSString *)debugInfo;

@end

@implementation BBMessageForwardProxy

- (void)bb_dealNotRecognizedMessage:(NSString *)debugInfo
{
    NSLog(@"%@",debugInfo);
}

@end

@implementation MessageInvocation

void dynamicMethodIMP(id self, SEL _cmd)
{
    NSLog(@"dynamicMethodIMP");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"sel is %@", NSStringFromSelector(sel));
    if (sel == @selector(setName:)) {
        class_addMethod([self class], sel, (IMP)dynamicMethodIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
//    //如果代理对象能处理，则转接给代理对象
//    if ([proxyObj respondsToSelector:aSelector]) {
//        return proxyObj;
//    }
//    //不能处理进入转发流程
    return nil;
    
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *sig = [BBMessageForwardProxy instanceMethodSignatureForSelector:@selector(bb_dealNotRecognizedMessage:)];
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSString *debugInfo = [NSString stringWithFormat:@"[debug]unRecognizedMessage:[%@] sent to [%@]",NSStringFromSelector(anInvocation.selector),NSStringFromClass([self class])];
    //重定向方法
    [anInvocation setSelector:@selector(bb_dealNotRecognizedMessage:)];
    //传递调用信息
    [anInvocation setArgument:&debugInfo atIndex:2];
    //BBMessageForwardProxy对象接收转发的消息并打印调用信息
    [anInvocation invokeWithTarget:[BBMessageForwardProxy new]];
}


@end
