//
//  NSString+TextHeight.m
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSString+TextHeight.h"

@implementation NSString (TextHeight)

/** 给定最大宽度和字号 返回实际高度 */
- (CGFloat)wy_getHeightWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font{
    CGSize textMaxSize = CGSizeMake(maxWidth, MAXFLOAT);
    NSDictionary *textFontDict = @{NSFontAttributeName:font};
    CGRect textContentRect = [self boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    return textContentRect.size.height;
}

@end
