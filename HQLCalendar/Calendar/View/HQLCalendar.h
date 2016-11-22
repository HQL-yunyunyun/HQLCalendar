//
//  HQLCalender.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/15.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQLCalendarView.h"

@class HQLDateModel, HQLCalendar;

@protocol HQLCalendarDelegate <NSObject>

- (void)calendar:(HQLCalendar *)calendar calendarView:(HQLCalendarView *)calendarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end;

@end

@interface HQLCalendar : UIView

/**
 选中模式
 */
@property (assign, nonatomic) HQLCalendarViewSelectionStyle selectionStyle;

/**
 是否可以选中未来的日期,默认为NO
 */
@property (assign, nonatomic, getter=isAllowSelectedFutureDate) BOOL allowSelectedFutureDate;

@property (assign, nonatomic) id <HQLCalendarDelegate>delegate;

// 原始dateModel 高度不可控制
- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel;

/**
 设置当前时间
 */
- (void)setDateModel:(HQLDateModel *)dateModel;

/**
 选择某一个时间
 */
- (void)selectDateModel:(HQLDateModel *)dateModel isTriggerDelegate:(BOOL)yesOrNo;

- (void)reloadDate;

@end
