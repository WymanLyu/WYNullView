//
//  WYWeakObject.h
//  12-12WYEvent
//
//  Created by wyman on 2017/2/10.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^WeakReference)(void);

/**
 *  给定对象进行装箱，返回装箱后的弱引用对象
 */
extern WeakReference makeWeakReference(id object);
/**
 *  给定弱引用对象进行解包，返回解包后的对象
 */
extern id weakReferenceNonretainedObjectValue(WeakReference ref);

