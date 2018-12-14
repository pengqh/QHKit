//
//  QHWeakProxy.m
//  QHKit
//
//  Created by pengquanhua on 2018/12/14.
//  Copyright © 2018年 pengquanhua. All rights reserved.
//

#import "QHWeakProxy.h"
/*
 * 当target存在时，发送给_YYImageWeakProxy实例的方法能正常的转发给target。
 * 当target释放时，forwardingTargetForSelector:重定向失败，会调用methodSignatureForSelector:尝试获取有效的方法，而若获取的方法无效，将会抛出异常，所以这里随便返回了一个init方法。
 * 当methodSignatureForSelector:获取到一个有效的方法过后，会调用forwardInvocation:方法开始消息转发。而这里作者给[invocation setReturnValue:&null];一个空的返回值，让最外层的方法调用者不会得到不可控的返回值。虽然这里不调用方法默认会返回 null ，但是为了保险起见，能尽量人为控制默认值就不要用系统控制。
 */

@implementation QHWeakProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}
+ (instancetype)proxyWithTarget:(id)target {
    return [[QHWeakProxy alloc] initWithTarget:target];
}
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}
- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}
- (NSUInteger)hash {
    return [_target hash];
}
- (Class)superclass {
    return [_target superclass];
}
- (Class)class {
    return [_target class];
}
- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}
- (BOOL)isProxy {
    return YES;
}
- (NSString *)description {
    return [_target description];
}
- (NSString *)debugDescription {
    return [_target debugDescription];
}


@end
