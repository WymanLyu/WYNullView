//
//  UIView+WY.h
//  5-20静默视图
//
//  Created by wyman on 2017/5/20.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NullView.h"
#import "UIView+HiddenEx.h"

typedef UIView *(^NullViewHandle)(NullView *defaultNullView);

@interface UIView (WY)

#pragma mark - 静默视图

///> 空视图
@property (nonatomic, strong) UIView *wy_nullView;

/** 配置空视图样式 */
- (void)wy_configNullView:(UIView *(^)(NullView *defaultNullView))nullViewConfig;

/** 配置空视图点击操作 */
- (void)wy_nullViewAddTarget:(id)target action:(SEL)sel;

/** 显示空视图
 * nullViewHandle : 修改空视图样式，如果为空则会按照wy_configNullView的样式, 如果没有配置wy_configNullView则是默认样式
 * offset         : 调整垂直方向的间距
 */
- (void)wy_showNullView:(UIView *(^)(NullView *defaultNullView))nullViewHandle heightOffset:(CGFloat)offset;

/** 显示空视图
 * nullViewHandle : 修改空视图样式，如果为空则会按照wy_configNullView的样式, 如果没有配置wy_configNullView则是默认样式
 */
- (void)wy_showNullView:(UIView *(^)(NullView *defaultNullView))nullViewHandle;

/** 显示空视图 */
- (void)wy_showNullView;

/** 隐藏空视图 */
- (void)wy_hideNullView;

/** 配置默认的NullView */
+ (void)wy_configGlobleNullView:(UIView *(^)(NullView *defaultNullView))nullViewHandle;

///> 加载视图
@property (nonatomic, strong) UIView *wy_loadingView;

@property (nonatomic, strong) UIView *wy_loadingMaskView;

/** 开始加载【默认是隐藏其他视图】 */
- (void)wy_startLodingHideOtherView;

/** 开始加载【默认是不隐藏其他视图】 */
- (void)wy_startLoding;

/** 停止加载 */
- (void)wy_stopLoding;

@end
