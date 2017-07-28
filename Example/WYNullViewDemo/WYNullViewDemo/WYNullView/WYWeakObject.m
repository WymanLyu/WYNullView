//
//  WYWeakObject.m
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "WYWeakObject.h"

extern WeakReference makeWeakReference(id object) {
    __weak id weakref = object;
    return ^{
        return weakref;
    };
}

extern id weakReferenceNonretainedObjectValue(WeakReference ref) {
    return ref ? ref() : nil;
}
