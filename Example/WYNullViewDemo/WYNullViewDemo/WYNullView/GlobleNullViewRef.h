//
//  GlobleNullViewRef.h
//  WYNullViewDemo
//
//  Created by wyman on 2017/7/28.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class NullView;
typedef UIView *(^NullViewHandle)(NullView *defaultNullView);

@interface GlobleNullViewRef : NSObject

@property (nonatomic, copy) NullViewHandle globleNullViewHandle;

+ (instancetype)shareGlobleNullViewRef;

@end
