//
//  HQLDrawGeometricShapeView.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/11.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLDrawGeometricShapeView.h"

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

- (void)drawRect:(CGRect)rect {
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
}

- (void)setColor:(UIColor *)color {
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShape:(HQLDrawGeometricShape)shape {
    _shape = shape;
    
    // 重绘
    [self setNeedsDisplay];
}

@end
