//
//  HQLCalender.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/15.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQLCalendarView.h"

@class HQLDateModel;

@interface HQLCalendar : UIView

/**
 选中模式
 */
@property (assign, nonatomic) HQLCalendarViewSelectionStyle selectionStyle;

/**
 是否可以选中未来的日期,默认为NO
 */
@property (assign, nonatomic, getter=isAllowSelectedFutureDate) BOOL allowSelectedFutureDate;

// 原始dateModel 高度不可控制
- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel;

@end
