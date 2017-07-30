//
//  UIView+HiddenEx.h
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYWeakObject.h"

@interface UIView (HiddenEx)

@property (nonatomic, strong) NSMutableArray<WeakReference> *wy_classWhitelist;
@property (nonatomic, strong) NSMutableArray<WeakReference> *wy_objWhitelist;

- (void)wy_hideOtherViewAndShowView:(UIView *)view;
- (void)wy_showOtherViewAndHideView:(UIView *)view;

@end
