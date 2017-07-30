//
//  GlobleNullViewRef.m
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "GlobleNullViewRef.h"

@implementation GlobleNullViewRef

static GlobleNullViewRef *_nullViewRef = nil;

+ (instancetype)shareGlobleNullViewRef {
    if (nil == _nullViewRef) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _nullViewRef = [GlobleNullViewRef new];
        });
    }
    return _nullViewRef;
}

@end
