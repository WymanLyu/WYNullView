//
//  UIView+HiddenEx.m
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIView+HiddenEx.h"
#import <objc/runtime.h>
#import "NSBundle+WY.h"

@implementation UIView (HiddenEx)

#pragma mark - 静默视图
static const void *wy_classWhitelistValueKey = &wy_classWhitelistValueKey;
static const void *wy_objWhitelistValueKey = &wy_objWhitelistValueKey;

- (void)setWy_classWhitelist:(NSMutableArray *)wy_classWhitelist {
    objc_setAssociatedObject(self, wy_classWhitelistValueKey, wy_classWhitelist, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)wy_classWhitelist {
    NSMutableArray *classWhitelist = objc_getAssociatedObject(self,wy_classWhitelistValueKey);
    if (!classWhitelist) {
        classWhitelist = [NSMutableArray array];
        [self setWy_classWhitelist:classWhitelist];
        NSMutableArray *whitelistInPlist = [self _loadWhitePlist];
        Class class = nil;
        for (NSString *className in whitelistInPlist) {
            if (className.length) {
                class = NSClassFromString(className);
            }
            if (class) {
                [classWhitelist addObject:makeWeakReference(class)];
            }
        }
    }
    return classWhitelist;
}

- (void)setWy_objWhitelist:(NSMutableArray *)wy_objWhitelist{
    objc_setAssociatedObject(self, wy_objWhitelistValueKey, wy_objWhitelist, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)wy_objWhitelist {
    NSMutableArray *objWhitelist = objc_getAssociatedObject(self, wy_objWhitelistValueKey);
    if (!objWhitelist) {
        objWhitelist = [NSMutableArray array];
        [self setWy_objWhitelist:objWhitelist];
    }
    return objWhitelist;
}

- (void)wy_hideOtherViewAndShowView:(UIView *)view {
    for (UIView *subView in self.subviews) {
        if ([self _isInClasswhitelist:subView]) {
            continue;
        }
        if ([self _isInObjwhitelist:subView]) {
            continue;
        }
        [subView setHidden:YES];
    }
    view.hidden = NO;
}

- (void)wy_showOtherViewAndHideView:(UIView *)view {
    for (UIView *subView in self.subviews) {
        if ([self _isInClasswhitelist:subView]) { // 屏蔽下拉刷新
            continue;
        }
        if ([self _isInObjwhitelist:subView]) {
            continue;
        }
        [subView setHidden:NO];
    }
    view.hidden = YES;
}

#pragma mark - 私有方法
- (NSMutableArray *)_loadWhitePlist {
    return [NSBundle wy_classWhitelistArrayM];
}

- (BOOL)_isInClasswhitelist:(id)obj {
    BOOL flag = NO;
    for (WeakReference weakClass in self.wy_classWhitelist) {
        Class class = weakReferenceNonretainedObjectValue(weakClass);
        if (class) {
            flag = [obj isKindOfClass:weakReferenceNonretainedObjectValue(weakClass)];
        }
        if (flag) {
            break;
        }
    }
    return flag;
}

- (BOOL)_isInObjwhitelist:(id)obj  {
    BOOL flag = NO;
    for (WeakReference weakClass in self.wy_objWhitelist) {
        id whiteObj = weakReferenceNonretainedObjectValue(weakClass);
        if (obj == whiteObj) {
            flag = YES;
            break;
        }
    }
    return flag;
}


@end
