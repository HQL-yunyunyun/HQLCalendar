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

//@property (assign, nonatomic, getter=isShowDescString) BOOL showDescString;

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
    double sign = self.descLabel.hidden ? 1 : 0.6;
    self.dateLabel.y = (self.height * sign - self.dateLabel.height) * 0.5 + (self.descLabel.hidden ? 0 : 3);
    if (!self.descLabel.hidden) {
        [self.descLabel sizeToFit];
        self.descLabel.width = self.width;
        self.descLabel.x = 0;
        self.descLabel.y = (self.height * 0.8 - self.descLabel.height * 0.5) - 2;
    }
}

#pragma mark - event 

- (NSString *)getCellSting {
    NSString *string = nil;
    if (self.HQL_SelectionStyle == calendarViewSelectionStyleMonth) {
        switch (self.model.date.month) {
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
        string = [NSString stringWithFormat:@"%ld", (long)self.model.date.day];
    }
    return string;
}

#pragma mark - setter

- (void)setHQL_SelectionStyle:(HQLCalendarViewSelectionStyle)HQL_SelectionStyle {
    _HQL_SelectionStyle = HQL_SelectionStyle;
    
    if (HQL_SelectionStyle == calendarViewSelectionStyleMonth) {
        [self.dateLabel setFont:[UIFont systemFontOfSize:18]];
        [self.descLabel setFont:[UIFont systemFontOfSize:15]];
        
        [self.contentView.layer setBorderColor:HQLColor(220, 218, 220).CGColor];
        [self.contentView.layer setBorderWidth:0.5];
    } else {
        [self.dateLabel setFont:[UIFont systemFontOfSize:14]];
        [self.descLabel setFont:[UIFont systemFontOfSize:11]];
        
        [self.contentView.layer setBorderWidth:0];
    }
}

- (void)setModel:(HQLCalendarModel *)model {
    _model = model;
    
    // 重设selectedView的宽高
    [self sendSubviewToBack:self.selectedView];
    self.selectedView.width = self.width;
    self.selectedView.height = self.height;
    
    if (model.isZero == YES) {
        [self.dateLabel setText:@""];
        self.selectedView.shape = drawGeometricShapeNone;
        [self.descLabel setHidden:YES];
        [self setNeedsLayout];
        return;
    }
    
    [self.dateLabel setText:[self getCellSting]];
    
    if (![self isAllowSelectedCell]) {
        // 不能选择未来的日期
        [self.dateLabel setTextColor:HQLColor(170, 170, 170)];
        self.selectedView.shape = drawGeometricShapeNone;
        [self.descLabel setHidden:YES];
        [self setNeedsLayout];
        return;
    }
    
    if (model.descString) {
        [self.descLabel setText:model.descString];
    }
    [self.descLabel setHidden:!model.descString];
    // 正常的情况
    HQLDrawGeometricShape shape = drawGeometricShapeNone;
    UIColor *selectedColor = self.backgroundColor;
    if (self.HQL_SelectionStyle == calendarViewSelectionStyleWeek) { // 选择一周的情况
        if ([model.date weekdayOfCurrentDate] == 1) {
            shape =drawGeometricShapeLeftHalfCircular; // 周日
        } else if ([model.date weekdayOfCurrentDate] == 7) {
            shape = drawGeometricShapeRightHalfCircular; // 周六
        } else if ([model.date compareWithHQLDateWithOutTime:[HQLDateModel HQLDate]] == 0) {
            if (model.isAllowSelectedFutureDate) {
                if (model.isAllowSelectedPassedDate) {
                    // 允许选择未来和过去
                    shape = drawGeometricShapeRect;
                } else {
                    // 允许选择未来 不允许选择过去
                    shape = drawGeometricShapeLeftHalfCircular;
                }
            } else {
                if (model.isAllowSelectedPassedDate) {
                    // 不允许选择未来，但允许选择过去
                    shape = drawGeometricShapeRightHalfCircular;
                } else {
                    // 两个都不允许
                    shape = drawGeometricShapeCircular;
                }
            }
        } else {
            shape = drawGeometricShapeRect; // 周中
        }
    }
    
    if (model.isSelected) {
        [self.dateLabel setTextColor:model.dateSelectColor ? model.dateSelectColor : [UIColor whiteColor]];
        [self.descLabel setTextColor:model.descSelectColor ? model.descSelectColor : [UIColor whiteColor]];
//        selectedColor = [UIColor orangeColor];
        selectedColor = model.tintColor ? model.tintColor : [UIColor orangeColor];
        
        if (self.HQL_SelectionStyle == calendarViewSelectionStyleDay || self.HQL_SelectionStyle == calendarViewSelectionStyleMonth) { // 选择单日的情况
            shape = drawGeometricShapeCircular;     // 选择日
        } else if (self.HQL_SelectionStyle == calendarViewSelectionStyleCustom) { // 选择自定义区间
            if (model.customStyle == calendarViewSelectionStyleCustomBeginDate) {
                shape = drawGeometricShapeLeftHalfCircular; // 开始
            } else if (model.customStyle == calendarViewSelectionStyleCustomMiddleDate) {
                shape = drawGeometricShapeRect; // 中间
            } else {
                shape = drawGeometricShapeRightHalfCircular; // 结束
            }
        }
    } else {
        // 没有选中
        [self.dateLabel setTextColor:model.dateNormalColor ? model.dateNormalColor : [UIColor blackColor]];
        [self.descLabel setTextColor:model.descNormalColor ? model.descNormalColor : [UIColor orangeColor]];
        selectedColor = self.backgroundColor;
        
        if (self.HQL_SelectionStyle == calendarViewSelectionStyleWeek) {
            selectedColor = HQLColor(250, 248, 250);
        }
        if (self.HQL_SelectionStyle == calendarViewSelectionStyleDay && [[HQLDateModel HQLDate] isEqualHQLDateWithOutTime:model.date]) {
//            selectedColor = [UIColor orangeColor];
            selectedColor = model.tintColor ? model.tintColor : [UIColor orangeColor];
            shape = drawGeometricShapeCircularRing;
            
            [self.dateLabel setTextColor:selectedColor];
            [self.descLabel setTextColor:selectedColor];
//            [self.dateLabel setTextColor:[UIColor orangeColor]];
//            [self.descLabel setTextColor:[UIColor orangeColor]];
        }
    }
    [self.selectedView setColor:selectedColor];
    [self.selectedView setShape:shape];
    [self setNeedsLayout];
}

// 根据model 自行判断cell是否可以被选中
- (BOOL)isAllowSelectedCell {
    HQLDateModel *today = [[HQLDateModel alloc] initCurrentDate];
    NSInteger dayCompareResult = [self.model.date compareWithHQLDateWithOutTime:today];
    NSInteger monthCompareResult = [self.model.date compareMonthWithHQLDateWithOutTime:today];
    
    if (self.model.allowSelectedFutureDate) {
        if (self.model.allowSelectedPassedDate) {
            // 都为yes
            return YES;
        } else {
            // 允许选择未来 但不允许选择过去 ---> model.date 要大于 today
            if (self.HQL_SelectionStyle != calendarViewSelectionStyleMonth) {
                return dayCompareResult > -1;
            } else { // 月的比较
                return monthCompareResult > -1;
            }
        }
    } else {
        // 允许选择过去 不允许选择未来 ---> model.date 要小于 today
        if (self.model.allowSelectedPassedDate) {
            if (self.HQL_SelectionStyle != calendarViewSelectionStyleMonth) {
                return dayCompareResult < 1;
            } else { // 月的比较
                return monthCompareResult < 1;
            }
        } else {
            // 都不允许的情况下 ---> 只有当天能选择
            if (self.HQL_SelectionStyle != calendarViewSelectionStyleMonth) {
                return dayCompareResult == 0;
            } else {
                return monthCompareResult == 0;
            }
        }
    }
}

#pragma mark - getter

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont systemFontOfSize:14]];
        [_dateLabel setTextColor:[UIColor blackColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _dateLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        [_descLabel setFont:[UIFont systemFontOfSize:11]];
        [_descLabel setTextColor:[UIColor blackColor]];
        [_descLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_descLabel];
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

@implementation HQLCalendarModel

- (instancetype)initWithZero {
    if (self = [super init]) {
        self.zero = YES;
    }
    return self;
}

@end

