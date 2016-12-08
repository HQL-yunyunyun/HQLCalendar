//
//  HQLDrawGeometricShapeView.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/11.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLDrawGeometricShapeView.h"

@interface HQLDrawGeometricShapeView ()

@property (strong, nonatomic) CAShapeLayer *currentLayer;

@end

@implementation HQLDrawGeometricShapeView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    
    [self drawShape:self.shape color:color];
}

- (void)setShape:(HQLDrawGeometricShape)shape {
    _shape = shape;
    
    NSAssert(self.color != nil, @"color 不能为空");
    [self drawShape:shape color:self.color];
}

- (void)drawShape:(HQLDrawGeometricShape)shape color:(UIColor *)color {
    [self.currentLayer removeFromSuperlayer];
    self.currentLayer.strokeColor = nil;
    self.currentLayer.fillColor = color.CGColor;
    UIBezierPath *path = nil;
    
    CGFloat length = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    CGFloat width = length - 3;
    CGFloat height = length - 3;
    CGFloat x = (self.frame.size.width - width) * 0.5;
    CGFloat y = (self.frame.size.height - height) * 0.5 + 1;
    
    switch (shape) {
        case drawGeometricShapeCircular: {
            // 圆形
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width * 0.5 + x, height * 0.5 + y) radius:width * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            break;
        }
        case drawGeometricShapeRect: {
            // 正方形
            width = self.frame.size.width;
            x = (self.frame.size.width - width) * 0.5;
            path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, width, height)];
            break;
        }
        case drawGeometricShapeLeftHalfCircular:{
            // 左半圆 右半正方形
            x += width * 0.5;
            y += height * 0.5;
            CGFloat radius = width * 0.5;
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:radius startAngle:M_PI_2 endAngle:M_PI_2 + M_PI  clockwise:YES];
            [path addLineToPoint:CGPointMake(x + radius + 1.5, y - height * 0.5)];
            [path addLineToPoint:CGPointMake(x + radius + 1.5, y + height * 0.5)];
            [path closePath];
            break;
        }
        case drawGeometricShapeRightHalfCircular: {
            // 右半圆 左半正方形
            x += width * 0.5;
            y += height * 0.5;
            CGFloat radius = width * 0.5;
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:radius startAngle:M_PI_2 endAngle:M_PI_2 + M_PI  clockwise:NO];
            [path addLineToPoint:CGPointMake(x - radius - 1.5, y - height * 0.5)];
            [path addLineToPoint:CGPointMake(x - radius - 1.5, y + height * 0.5)];
            [path closePath];
            break;
        }
        case drawGeometricShapeCircularRing: {
            // 圆环
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width * 0.5 + x, height * 0.5 + y) radius:width * 0.5 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
            self.currentLayer.fillColor = nil;
            self.currentLayer.strokeColor = self.color.CGColor;
            break;
        }
        case drawGeometricShapeNone: {
            // 空白就什么都不做
            
            break;
        }
    }
    
    self.currentLayer.path = path.CGPath;
    [self.layer addSublayer:self.currentLayer];
}

- (CAShapeLayer *)currentLayer {
    if (!_currentLayer) {
        _currentLayer = [CAShapeLayer new];
        _currentLayer.frame = self.bounds;
        _currentLayer.fillColor = self.color.CGColor;
        _currentLayer.strokeColor = nil;
    }
    return _currentLayer;
}

@end
