//
//  HQLCalenderView.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQLDateModel, HQLCalendarView;

typedef enum {
    calendarViewSelectionStyleDay = 0,  // 日期选中时的模式,选中单日
    calendarViewSelectionStyleWeek ,    // 日期选中时的模式,选中一周
    calendarViewSelectionStyleCustom  //  日期选中时的模式,自定义区间
} HQLCalendarViewSelectionStyle;

typedef enum {
    calendarViewSelectionStyleCustomBeginDate = 0,     // 自定义区间的开始
    calendarViewSelectionStyleCustomMiddleDate,          // 自定义区间的中间
    calendarViewSelectionStyleCustomEndDate               // 自定义区间的结束
} HQLCalendarViewSelectionStyleCustom;

@protocol HQLCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(HQLCalendarView *)caledarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end;

@end

@interface HQLCalendarView : UIView

//@property (assign, nonatomic) NSInteger year;
//@property (assign, nonatomic) NSInteger month;

/**
 输入要显示的月份的dateModel
 */
@property (strong, nonatomic) HQLDateModel *dateModel;
@property (assign, nonatomic) CGFloat viewHeight;
@property (assign, nonatomic) id <HQLCalendarViewDelegate>delegate;

/**
 选中模式
 */
@property (assign, nonatomic) HQLCalendarViewSelectionStyle selectionStyle;

/**
 是否选中当前日期
 */
@property (assign, nonatomic, getter=isSelectedCurrentDate) BOOL selectedCurrentDate;

/**
 是否可以选中未来的日期
 */
@property (assign, nonatomic, getter=isAllowSelectedFutureDate) BOOL allowSelectedFutureDate;

/**
 是否选中最后一个星期(只有在最后一个星期是不完整的情况下才有效)
 */
@property (assign, nonatomic, getter=isSelectedLastWeek) BOOL selectedLastWeek;

/**
 是否选中第一个星期(只有在第一个星期是不完整的情况下才有效)
 */
@property (assign, nonatomic, getter=isSelectedFirstWeek) BOOL selectedFirstWeek;

/**
 自定义区间的开始日期(如果开始日期是在当前月份)
 */
@property (strong, nonatomic) HQLDateModel *customBeginDate;

/**
 自定义区间的结束日期(如果结束日期是在当前月份)
 */
@property (strong, nonatomic) HQLDateModel *customEndDate;

/**
 是否选中整个月(自定义区间的结束日期或开始日期都不在本月,但本月却包含在自定义区间当中)
 */
@property (assign, nonatomic, getter=isCustomSelectedAll) BOOL customSelectedAll;

// 高度不可控制
- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel;

@end

@interface HQLDateModel : NSObject

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger hour;
@property (assign, nonatomic) NSInteger minute;
@property (assign, nonatomic) NSInteger second;
@property (assign, nonatomic, getter=isZero) BOOL zero; // 空model

@property (assign, nonatomic, getter=isSelected) BOOL selected;

@property (assign, nonatomic) HQLCalendarViewSelectionStyleCustom customStyle;

- (instancetype)initWithZero; // 创建一个空的model

- (instancetype)initWithYear:(NSInteger) year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

- (instancetype)initWithYear:(NSInteger) year month:(NSInteger)month day:(NSInteger)day;

- (instancetype)initwithNSDate:(NSDate *)date;

- (instancetype)initWithHQLDate:(HQLDateModel *)date;

- (NSDate *)changeToNSDate;

/**
 求出当前月份日历的行数
 */
- (NSInteger)rowOfCalenderInCurrentMonth;

/**
 求出当前月份的天数
 */
- (NSInteger)numberOfDaysInCurrentMonth;

/**
 当前日期的weekday
 1 - 周日 / 2 - 周一 / 3 - 周二 / 4 - 周三 / 5 - 周四 / 6 - 周五 / 7 - 周六
 */
- (NSInteger)weekdayOfCurrentDate;

+ (NSInteger)rowOfCalenderInMonth:(NSInteger)month year:(NSInteger)year;

+ (NSUInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

+ (NSInteger)weekdayOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;


/**
 返回一个数组,该数组按照当前日期,将该月的日期都分别添加到对应的weekday
 */
/*- (NSMutableArray <NSMutableArray *>*)dataSourceOfCurrentMonth;
+ (NSMutableArray <NSMutableArray *>*)dataSourceOfYear:(NSInteger)year month:(NSInteger)month;*/

@end
