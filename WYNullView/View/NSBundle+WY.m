//
//  NSBundle+WY.m
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/30.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "NSBundle+WY.h"

@implementation NSBundle (WY)

+ (instancetype)wy_nullViewBundle {
    static NSBundle *nullViewBundle = nil;
    if (nil == nullViewBundle) {
        nullViewBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:NSClassFromString(@"NullView")] pathForResource:@"WYNullView" ofType:@"bundle"]];
    }
    return nullViewBundle;
}

+ (UIImage *)wy_nullViewImage {
//  this func can't load image from xcassets in custom bundle   i dont know why? 在bundle的xcassets怎么加载图片，这样我需要加载3x、2x要自己判断
//  rerurn [UIImage imageNamed:@"null_img" inBundle:[self wy_nullViewBundle] compatibleWithTraitCollection:nil];
    static UIImage *nullImage = nil;
    if (nil == nullImage) {
        nullImage = [UIImage imageWithContentsOfFile:[[self wy_nullViewBundle] pathForResource:@"null_img@2x" ofType:@"png"]];
    }
    return nullImage;
}

+ (NSMutableArray *)wy_classWhitelistArrayM {
    NSString *plistPath = [[self wy_nullViewBundle] pathForResource:@"ClassWhitelist" ofType:@"plist"];
    return [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

@end
