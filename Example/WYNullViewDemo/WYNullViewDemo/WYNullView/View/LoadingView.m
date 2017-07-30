//
//  LoadingView.m
//  HeiPa
//
//  Created by wyman on 2017/3/14.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView ()

@property (nonatomic, weak) CAShapeLayer *cycleLayer;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // 圆圈
        CAShapeLayer *cycleLayer = [CAShapeLayer new];
        cycleLayer.lineCap = kCALineCapRound;
        cycleLayer.lineJoin = kCALineJoinRound;
        cycleLayer.fillColor = [UIColor clearColor].CGColor;
        cycleLayer.strokeColor = [UIColor blackColor].CGColor;
        cycleLayer.lineWidth = 4.0;
        cycleLayer.strokeEnd = 0;
        [self.layer addSublayer:cycleLayer];
        _cycleLayer = cycleLayer;
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.cycleLayer.frame = self.bounds;
    self.cycleLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
}

- (void)startLoading {
    
    if (self.isLoading) {
        return;
    }
    
    self.isLoading = YES;
    self.alpha = 1.0;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animation];
    strokeStartAnimation.keyPath = @"strokeStart";
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1.0);
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animation];
    strokeEndAnimation.keyPath = @"strokeEnd";
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1.0);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 1;
    animationGroup.repeatCount = MAXFLOAT;
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    [self.cycleLayer addAnimation:animationGroup forKey:@"animationGroup"];

}

- (void)stopLoading {
    
    if (!self.isLoading) {
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cycleLayer removeAllAnimations];
        _isLoading = NO;
    }];
    
}

@end
