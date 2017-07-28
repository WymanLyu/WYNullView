//
//  UIView+WY.m
//  5-20静默视图
//
//  Created by wyman on 2017/5/20.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIView+WY.h"
#import <objc/runtime.h>
#import "LoadingView.h"
#import "GlobleNullViewRef.h"

// 屏幕适配 750×1334
#define fitW(w)  (((w)/(750.0))*([UIScreen mainScreen].bounds.size.width))
#define fitH(h)  (((h)/(1334.0))*([UIScreen mainScreen].bounds.size.height))

@implementation UIView (WY)

#pragma mark - 静默视图
static const void *wy_nullViewValueKey = &wy_nullViewValueKey;
static const void *wy_loadingViewValueKey = &wy_loadingViewValueKey;
static const void *wy_loadingMaskViewValueKey = &wy_loadingMaskViewValueKey;


- (void)setWy_nullView:(UIView *)wy_nullView {
    objc_setAssociatedObject(self, wy_nullViewValueKey, wy_nullView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)wy_nullView {
    return objc_getAssociatedObject(self,wy_nullViewValueKey);
}

- (void)setWy_loadingView:(UIView *)wy_loadingView {
    objc_setAssociatedObject(self, wy_loadingViewValueKey, wy_loadingView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)wy_loadingView {
    return objc_getAssociatedObject(self,wy_loadingViewValueKey);
}

- (void)setWy_loadingMaskView:(UIView *)wy_loadingMaskView {
    objc_setAssociatedObject(self, wy_loadingMaskViewValueKey, wy_loadingMaskView, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)wy_loadingMaskView {
    return objc_getAssociatedObject(self,wy_loadingMaskViewValueKey);
}


/// > 空视图
- (void)wy_showNullView:(UIView *(^)(NullView *defaultNullView))nullViewHandle heightOffset:(CGFloat)offset {
    
    // 0.懒加载空视图
    if (!self.wy_nullView) {
        self.wy_nullView = [NullView new];
    }
    if ([GlobleNullViewRef shareGlobleNullViewRef].globleNullViewHandle) { // 查找全局设置
        UIView *globalNullView = [GlobleNullViewRef shareGlobleNullViewRef].globleNullViewHandle((NullView *)self.wy_nullView);
        if (globalNullView) {
            self.wy_nullView = globalNullView;
        }
    }
    CGRect originRect = self.wy_nullView.frame;
    
    // 1.更新自定义的空视图
    if (nullViewHandle) {
        UIView *customNullView = nullViewHandle((NullView *)self.wy_nullView);
        if (customNullView != self.wy_nullView) {
            [self.wy_nullView removeFromSuperview];
            self.wy_nullView = customNullView;
        }
    }
    
    // 2.调整位置
    if (CGRectEqualToRect(originRect, self.wy_nullView.frame)) { // nullViewHandle中未修改frame
        self.wy_nullView.frame = CGRectMake(self.frame.size.width*0.5-NULL_WIDTH*0.5, fitH(234), NULL_WIDTH, NULL_HEIGHT);
        self.wy_nullView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    if (offset) {
        CGRect newframe = self.wy_nullView.frame;
        newframe.origin.y += offset;
        self.wy_nullView.frame = newframe;
    }
    
    // 3.添加到视图渲染层级
    if (![self.subviews containsObject:self.wy_nullView]) {
        [self addSubview:self.wy_nullView];
    }
    
    // 4.显示到最前面
    if (self.subviews.lastObject != self.wy_nullView) {
        [self bringSubviewToFront:self.wy_nullView];
    }
    
    // 5.隐藏其他视图后显示
    [self wy_hideOtherViewAndShowView:self.wy_nullView];
}

- (void)wy_showNullView:(UIView *(^)(NullView *defaultNullView))nullViewHandle {
    [self wy_showNullView:nullViewHandle heightOffset:0.0];
}

- (void)wy_showNullView {
    [self wy_showNullView:nil heightOffset:0.0];
}

- (void)wy_configNullView:(UIView *(^)(NullView *defaultNullView))nullViewConfig {
    // 0.懒加载空视图
    if (!self.wy_nullView) {
        self.wy_nullView = [NullView new];
    }
    // 配置空视图
    if (nullViewConfig) {
        UIView *customNullView = nullViewConfig((NullView *)self.wy_nullView);
        if (customNullView != self.wy_nullView) {
            [self.wy_nullView removeFromSuperview];
            self.wy_nullView = customNullView;
        }
    }
}

- (void)wy_hideNullView {
    // 0.显示其他视图并隐藏空视图
    [self wy_showOtherViewAndHideView:self.wy_nullView];
}

- (void)wy_nullViewAddTarget:(id)target action:(SEL)sel {
    // 0.懒加载空视图
    if (!self.wy_nullView) {
        self.wy_nullView = [NullView new];
    }
    [self.wy_nullView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:sel]];
}


+ (void)wy_configGlobleNullView:(UIView *(^)(NullView *defaultNullView))nullViewHandle {
    if (nullViewHandle) {
        NullView *defaultNullView = [NullView new];
        UIView *globleDefaultView = nullViewHandle(defaultNullView);
        if (globleDefaultView) { // 保存起来
            [GlobleNullViewRef shareGlobleNullViewRef].globleNullViewHandle = nullViewHandle;
        }
    }
}

/// > 加载视图

- (void)wy_startLodingHideOtherView {
    // 1.懒加载加载视图
    if (!self.wy_loadingView) {
        self.wy_loadingView = [LoadingView new];
        self.wy_loadingView.frame = CGRectMake(self.frame.size.width*0.5-LOADING_WIDTH*0.5, self.frame.size.height*0.5-LOADING_HEIGHT*0.5, LOADING_WIDTH, LOADING_HEIGHT);
    }
    // 2.添加到视图渲染层级
    if (![self.subviews containsObject:self.wy_loadingView]) {
        [self addSubview:self.wy_loadingView];
    }
    // 3.显示到最前面
    if (self.subviews.lastObject != self.wy_loadingView) {
        [self bringSubviewToFront:self.wy_loadingView];
    }
    // 4.隐藏其他视图并显示
    [self wy_hideOtherViewAndShowView:self.wy_loadingView];
    // 5.加载动画
    [(LoadingView *)self.wy_loadingView startLoading];
}

- (void)wy_startLoding {
    // 1.懒加载加载视图
    if (!self.wy_loadingView) {
        self.wy_loadingView = [LoadingView new];
        self.wy_loadingView.frame = CGRectMake(self.frame.size.width*0.5-LOADING_WIDTH*0.5, self.frame.size.height*0.5-LOADING_HEIGHT*0.5, LOADING_WIDTH, LOADING_HEIGHT);
    }
    // 2.添加到视图渲染层级
    if (![self.subviews containsObject:self.wy_loadingView]) {
        [self addSubview:self.wy_loadingView];
    }
    // 3.显示到最前面
    if (self.subviews.lastObject != self.wy_loadingView) {
        [self bringSubviewToFront:self.wy_loadingView];
    }
    // 4.添加mask阻止其他操作
    if (!self.wy_loadingMaskView) {
        UIView *maskView = [UIView new];
        maskView.frame = self.bounds;
        self.wy_loadingMaskView = maskView;
    }
    if (![self.subviews containsObject:self.wy_loadingMaskView]) {
        [self addSubview:self.wy_loadingMaskView];
        [self insertSubview:self.wy_loadingMaskView belowSubview:self.wy_loadingView];
    }
    self.wy_loadingView.hidden = NO;
    
    // 5.加载动画
    [(LoadingView *)self.wy_loadingView startLoading];
}

- (void)wy_stopLoding {
    [self wy_showOtherViewAndHideView:self.wy_loadingView];
    if (self.wy_loadingMaskView) {
        [self.wy_loadingMaskView removeFromSuperview];
    }
    [(LoadingView *)self.wy_loadingView stopLoading];
}

@end
