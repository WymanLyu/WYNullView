//
//  LoadingView.h
//  HeiPa
//
//  Created by wyman on 2017/3/14.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LOADING_WIDTH 50
#define LOADING_HEIGHT 50

@interface LoadingView : UIView

- (void)startLoading;
- (void)stopLoading;

@end
