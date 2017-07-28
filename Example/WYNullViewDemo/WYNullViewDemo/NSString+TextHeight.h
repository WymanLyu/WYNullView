//
//  NSString+TextHeight.h
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TextHeight)

/** 给定最大宽度和字号 返回实际高度 */
- (CGFloat)wy_getHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font;

@end
