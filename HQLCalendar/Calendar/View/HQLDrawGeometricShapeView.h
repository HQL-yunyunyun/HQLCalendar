//
//  HQLDrawGeometricShapeView.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/11.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    drawGeometricShapeCircular = 0,                 // 圆形
    drawGeometricShapeRect ,                           // 长方形
    drawGeometricShapeLeftHalfCircular,           // 左半圆 右半正方形
    drawGeometricShapeRightHalfCircular,        // 右半圆 左半正方形
    drawGeometricShapeCircularRing  ,             //  圆环
    drawGeometricShapeNone                           //  空白
} HQLDrawGeometricShape;

@interface HQLDrawGeometricShapeView : UIView

@property (assign, nonatomic) HQLDrawGeometricShape shape;

@property (strong, nonatomic) UIColor *color;

@end
