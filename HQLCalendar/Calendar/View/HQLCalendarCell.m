//
//  HQLCalenderCell.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLCalendarCell.h"
#import "HQLCalendarView.h"
#import "UIView+ST.h"
#import "HQLDrawGeometricShapeView.h"

#define HQLColorWithAlpha(r,g,b,a) [UIColor colorWithRed:( r / 255.0)  green:( g / 255.0) blue:( b / 255.0) alpha:a]
#define HQLColor(r,g,b) HQLColorWithAlpha(r,g,b,1)

@interface HQLCalendarCell ()

@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) UILabel *descLabel;

@property (strong, nonatomic) HQLDrawGeometricShapeView *selectedView; // 选中View

@end

@implementation HQLCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.dateLabel sizeToFit];
    self.dateLabel.width = self.width;
    self.dateLabel.x = 0;
    double sign = self.isShowDescString ? 0.6 : 1;
    self.dateLabel.y = (self.height * sign - self.dateLabel.height) * 0.5 + (self.isShowDescString ? 3 : 0);
    if (self.isShowDescString) {
        [self.descLabel sizeToFit];
        self.descLabel.width = self.width;
        self.descLabel.x = 0;
        self.descLabel.y = (self.height * 0.8 - self.descLabel.height * 0.5) - 2;
    }
    
    
    [self sendSubviewToBack:self.selectedView];
    self.selectedView.width = self.width;
    self.selectedView.height = self.height;
}

#pragma mark - event 

- (NSString *)getCellSting {
    NSString *string = nil;
    if (self.HQL_SelectionStyle == calendarViewSelectionStyleMonth) {
        switch (self.dateModel.month) {
            case 1: { string = @"一月" ; break; }
            case 2: { string = @"二月" ; break; }
            case 3: { string = @"三月" ; break; }
            case 4: { string = @"四月" ; break; }
            case 5: { string = @"五月" ; break; }
            case 6: { string = @"六月" ; break; }
            case 7: { string = @"七月" ; break; }
            case 8: { string = @"八月" ; break; }
            case 9: { string = @"九月" ; break; }
            case 10: { string = @"十月" ; break; }
            case 11: { string = @"十一月" ; break; }
            case 12: { string = @"十二月" ; break; }
        }
    } else {
        string = [NSString stringWithFormat:@"%ld", (long)self.dateModel.day];
    }
    return string;
}

#pragma mark - setter 

- (void)setShowDescString:(BOOL)showDescString {
    _showDescString = showDescString;
    if (showDescString) {
        [self addSubview:self.descLabel];
    } else {
        [self.descLabel removeFromSuperview];
    }
}

- (void)setHQL_SelectionStyle:(HQLCalendarViewSelectionStyle)HQL_SelectionStyle {
    _HQL_SelectionStyle = HQL_SelectionStyle;
    
    if (HQL_SelectionStyle == calendarViewSelectionStyleMonth) {
        [self.dateLabel setFont:[UIFont systemFontOfSize:18]];
        [self.descLabel setFont:[UIFont systemFontOfSize:15]];
        
        [self.contentView.layer setBorderColor:HQLColor(220, 218, 220).CGColor];
        [self.contentView.layer setBorderWidth:0.5];
    }
}

- (void)setDateModel:(HQLDateModel *)dateModel {
    _dateModel = dateModel;
    [self.dateLabel setText:@""];
    if (dateModel.isZero == YES) {
        self.selectedView.shape = drawGeometricShapeNone;
        [self setShowDescString:NO];
        return;
    }
    
    [self.dateLabel setText:[self getCellSting]];
//    [self.descLabel setText:@"测试"];
    
    if (!dateModel.isAllowSelectedFutureDate) {
        // 不能选择未来的日期
        [self.dateLabel setTextColor:HQLColor(170, 170, 170)];
        self.selectedView.shape = drawGeometricShapeNone;
        [self setShowDescString:NO];
        return;
    }
    
    // 正常的情况
    HQLDrawGeometricShape shape = drawGeometricShapeNone;
    UIColor *selectedColor = self.backgroundColor;
    
    if (self.HQL_SelectionStyle == calendarViewSelectionStyleWeek) { // 选择一周的情况
        if ([dateModel weekdayOfCurrentDate] == 1) {
            shape =drawGeometricShapeLeftHalfCircular; // 周日
        } else if ([dateModel weekdayOfCurrentDate] == 7) {
            shape = drawGeometricShapeRightHalfCircular; // 周六
        } else {
            shape = drawGeometricShapeRect; // 周中
        }
    }
    if (dateModel.isSelected) {
        [self.dateLabel setTextColor:[UIColor whiteColor]];
        [self.descLabel setTextColor:[UIColor whiteColor]];
        selectedColor = [UIColor orangeColor];
        
        if (self.HQL_SelectionStyle == calendarViewSelectionStyleDay || self.HQL_SelectionStyle == calendarViewSelectionStyleMonth) { // 选择单日的情况
            shape = drawGeometricShapeCircular;     // 选择日
        } else if (self.HQL_SelectionStyle == calendarViewSelectionStyleCustom) { // 选择自定义区间
            if (dateModel.customStyle == calendarViewSelectionStyleCustomBeginDate) {
                shape = drawGeometricShapeLeftHalfCircular; // 开始
            } else if (dateModel.customStyle == calendarViewSelectionStyleCustomMiddleDate) {
                shape = drawGeometricShapeRect; // 中间
            } else {
                shape = drawGeometricShapeRightHalfCircular; // 结束
            }
        }
    } else {
        // 没有选中
        [self.dateLabel setTextColor:[UIColor blackColor]];
        [self.descLabel setTextColor:[UIColor redColor]];
        selectedColor = self.backgroundColor;
        
        if (self.HQL_SelectionStyle == calendarViewSelectionStyleWeek) {
            selectedColor = HQLColor(250, 248, 250);
        }
        if (self.HQL_SelectionStyle == calendarViewSelectionStyleDay && [[HQLDateModel HQLDate] isEqualHQLDateWithOutTime:dateModel]) {
            selectedColor = [UIColor orangeColor];
            shape = drawGeometricShapeCircularRing;
            
            [self.dateLabel setTextColor:[UIColor orangeColor]];
            [self.descLabel setTextColor:[UIColor orangeColor]];
        }
    }
    [self.selectedView setColor:selectedColor];
    [self.selectedView setShape:shape];
}

#pragma mark - getter

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont systemFontOfSize:15]];
        [_dateLabel setTextColor:[UIColor blackColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _dateLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setFont:[UIFont systemFontOfSize:13]];
        [_descLabel setTextColor:[UIColor blackColor]];
        [_descLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _descLabel;
}

- (HQLDrawGeometricShapeView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[HQLDrawGeometricShapeView alloc] initWithFrame:self.bounds];
        [_selectedView setColor:self.backgroundColor];
        [_selectedView setShape:drawGeometricShapeNone];
        [self insertSubview:_selectedView atIndex:0];
    }
    return _selectedView;
}

@end
