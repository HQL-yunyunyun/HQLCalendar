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

- (void)setShape:(HQLDrawGeometricShape)shape {
    _shape = shape;
    
    NSAssert(self.color != nil, @"color 不能为空");
    [self drawShape:shape color:self.color];
}

- (void)drawShape:(HQLDrawGeometricShape)shape color:(UIColor *)color {
    [self.currentLayer removeFromSuperlayer];
    self.currentLayer.fillColor = color.CGColor;
    UIBezierPath *path = nil;
    
    CGFloat width = self.frame.size.width - 2;
    CGFloat height = self.frame.size.height - 2;
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
            [path addLineToPoint:CGPointMake(x + radius + 1, y - height * 0.5)];
            [path addLineToPoint:CGPointMake(x + radius + 1, y + height * 0.5)];
            [path closePath];
            break;
        }
        case drawGeometricShapeRightHalfCircular: {
            // 右半圆 左半正方形
            x += width * 0.5;
            y += height * 0.5;
            CGFloat radius = width * 0.5;
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(x, y) radius:radius startAngle:M_PI_2 endAngle:M_PI_2 + M_PI  clockwise:NO];
            [path addLineToPoint:CGPointMake(x - radius - 1, y - height * 0.5)];
            [path addLineToPoint:CGPointMake(x - radius - 1, y + height * 0.5)];
            [path closePath];
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

/*- (void)drawRect:(CGRect)rect {
     [super drawRect:rect];
     CGFloat width = self.frame.size.width - 2;
     CGFloat height = self.frame.size.height - 2;
     CGFloat x = (self.frame.size.width - width) * 0.5;
     CGFloat y = (self.frame.size.height - height) * 0.5 + 1;
     
     switch (self.shape) {
         case drawGeometricShapeCircular: {
             // 圆形
             CGContextRef con = UIGraphicsGetCurrentContext();
             CGContextAddEllipseInRect(con, CGRectMake(x, y, width, height));
             CGContextSetFillColorWithColor(con, self.color.CGColor);
             CGContextFillPath(con);
             break;
         }
         case drawGeometricShapeRect: {
             // 正方形
             width = self.frame.size.width;
             x = (self.frame.size.width - width) * 0.5;
             
             CGContextRef con = UIGraphicsGetCurrentContext();
             CGContextSetFillColorWithColor(con, self.color.CGColor);
             CGContextFillRect(con, CGRectMake(x, y, width, height));
             CGContextFillPath(con);
             break;
         }
         case drawGeometricShapeLeftHalfCircular:{
             // 左半圆 右半正方形
             x += width * 0.5;
             y += height * 0.5;
             CGFloat radius = width * 0.5;
             
             CGContextRef con = UIGraphicsGetCurrentContext();
             CGContextAddArc(con, x, y, radius, M_PI_2, M_PI + M_PI_2, 0);
             CGContextAddLineToPoint(con, x + radius + 1, y - height * 0.5);
             CGContextAddLineToPoint(con, x + radius + 1, y + height * 0.5);
             CGContextClosePath(con);
             CGContextSetFillColorWithColor(con, self.color.CGColor);
             CGContextFillPath(con);
             break;
         }
         case drawGeometricShapeRightHalfCircular: {
             // 右半圆 左半正方形
             x += width * 0.5;
             y += height * 0.5;
             CGFloat radius = width * 0.5;
             CGContextRef con = UIGraphicsGetCurrentContext();
             CGContextAddArc(con, x, y, radius, M_PI_2, M_PI + M_PI_2, 1);
             CGContextAddLineToPoint(con, x - radius - 1, y - height * 0.5);
             CGContextAddLineToPoint(con, x - radius - 1, y + height * 0.5);
             CGContextClosePath(con);
             CGContextSetFillColorWithColor(con, self.color.CGColor);
             CGContextFillPath(con);
             break;
         }
         case drawGeometricShapeNone: {
             // 空白就什么都不做
             break;
         }
         default:
             break;
     }
 }*/

@end
