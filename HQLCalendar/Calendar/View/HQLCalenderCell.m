//
//  HQLCalenderCell.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLCalenderCell.h"
#import "HQLCalenderView.h"
#import "UIView+ST.h"
#import "HQLDrawGeometricShapeView.h"

@interface HQLCalenderCell ()

@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) HQLDrawGeometricShapeView *selectedView; // 选中View

@end

@implementation HQLCalenderCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.dateLabel sizeToFit];
    self.dateLabel.width = self.width;
    self.dateLabel.x = (self.width - self.dateLabel.width) * 0.5;
    self.dateLabel.y = (self.height - self.dateLabel.height) * 0.5;
    
    if (!self.dateModel.isZero) {
        self.selectedView.width = self.width;
        self.selectedView.height = self.height;
    }
}

#pragma mark - setter 

- (void)setDateModel:(HQLDateModel *)dateModel {
    _dateModel = dateModel;
    [self.dateLabel setText:@""];
    if (dateModel.isZero == YES) return;
    [self.dateLabel setText:[NSString stringWithFormat:@"%ld", dateModel.day]];
    
    HQLDrawGeometricShape shape = drawGeometricShapeNone;
    UIColor *selectedColor = nil;
    if (self.HQL_SelectionStyle == calenderViewSelectionStyleWeek) {
        if ([dateModel weekdayOfCurrentDate] == 1) {
            // 周日
            shape =drawGeometricShapeLeftHalfCircular;
        } else if ([dateModel weekdayOfCurrentDate] == 7) {
            // 周六
            shape = drawGeometricShapeRightHalfCircular;
        } else {
            // 周中
            shape = drawGeometricShapeRect;
        }
    }
    if (dateModel.isSelected) {
        selectedColor = [UIColor orangeColor];
        if (self.HQL_SelectionStyle == calenderViewSelectionStyleDay) {
            shape = drawGeometricShapeCircular;
        } else if (self.HQL_SelectionStyle == calenderViewSelectionStyleCustom) {
            switch (dateModel.customStyle) {
                case calenderViewSelectionStyleCustomBeginDate: {
                    // 开始
                    shape = drawGeometricShapeLeftHalfCircular;
                    break;
                }
                case calenderViewSelectionStyleCustomMiddleDate: {
                    // 中间
                    shape = drawGeometricShapeRect;
                    break;
                }
                case calenderViewSelectionStyleCustomEndDate: {
                    // 结束
                    shape = drawGeometricShapeRightHalfCircular;
                    break;
                }
            }
        }
    } else {
        if (self.HQL_SelectionStyle == calenderViewSelectionStyleWeek) {
            selectedColor = [UIColor lightGrayColor];
        }
    }
    if (selectedColor != nil) {
        [self.selectedView setColor:selectedColor];
        [self.selectedView setShape:shape];
    }
}

#pragma mark - getter

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont systemFontOfSize:15]];
        [_dateLabel setTextColor:[UIColor blackColor]];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];    
//        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

- (HQLDrawGeometricShapeView *)selectedView {
    if (!_selectedView) {
        _selectedView = [[HQLDrawGeometricShapeView alloc] initWithFrame:self.bounds];
        [_selectedView setShape:drawGeometricShapeNone];
        [self insertSubview:_selectedView atIndex:0];
    }
    return _selectedView;
}

@end
