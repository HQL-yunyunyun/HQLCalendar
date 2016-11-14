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
    self.dateLabel.y = (self.height * sign - self.dateLabel.height) * 0.5;
    if (self.isShowDescString) {
        [self.descLabel sizeToFit];
        self.descLabel.width = self.width;
        self.descLabel.x = 0;
        self.descLabel.y = self.height * 0.8 - self.descLabel.height * 0.5;
    }
    
    
    [self sendSubviewToBack:self.selectedView];
    self.selectedView.width = self.width;
    self.selectedView.height = self.height;
}

#pragma mark - setter 

- (void)setShowDescString:(BOOL)showDescString {
    _showDescString = showDescString;
    if (showDescString) {
        [self addSubview:self.descLabel];
    }
}

- (void)setDateModel:(HQLDateModel *)dateModel {
    _dateModel = dateModel;
    [self.dateLabel setText:@""];
    if (dateModel.isZero == YES) {
        self.selectedView.shape = drawGeometricShapeNone;
        return;
    }
    [self.dateLabel setText:[NSString stringWithFormat:@"%ld", dateModel.day]];
    
    [self.descLabel setText:@"测试"];
    
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
        
        if (self.HQL_SelectionStyle == calendarViewSelectionStyleDay) { // 选择单日的情况
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
            selectedColor = [UIColor lightGrayColor];
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
