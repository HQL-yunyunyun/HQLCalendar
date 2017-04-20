//
//  HQLDateModel.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/18.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWeekdayNum 7 // 一周七天 / 从星期天开始

typedef enum {
    calendarViewSelectionStyleDay = 0,  // 日期选中时的模式,选中单日
    calendarViewSelectionStyleWeek ,    // 日期选中时的模式,选中一周
    calendarViewSelectionStyleMonth,    //  日期选中时的模式,选中一个月
    calendarViewSelectionStyleCustom  //  日期选中时的模式,自定义区间
} HQLCalendarViewSelectionStyle;

typedef enum {
    calendarViewSelectionStyleCustomBeginDate = 0,     // 自定义区间的开始
    calendarViewSelectionStyleCustomMiddleDate,          // 自定义区间的中间
    calendarViewSelectionStyleCustomEndDate               // 自定义区间的结束
} HQLCalendarViewSelectionStyleCustom;

@interface HQLDateModel : NSObject

@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger day;
@property (assign, nonatomic) NSInteger hour;
@property (assign, nonatomic) NSInteger minute;
@property (assign, nonatomic) NSInteger second;

- (instancetype)initWithYear:(NSInteger) year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

- (instancetype)initWithYear:(NSInteger) year month:(NSInteger)month day:(NSInteger)day;

- (instancetype)initwithNSDate:(NSDate *)date;

- (instancetype)initWithHQLDate:(HQLDateModel *)date;

// 当前日期
- (instancetype)initCurrentDate;

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

- (BOOL)isEqualHQLDate:(HQLDateModel *)date;

/**
 单纯比较日期，不比较时间
 */
- (BOOL)isEqualHQLDateWithOutTime:(HQLDateModel *)date;

// 单纯比较日期， 不比较时间， 若self大于date 则为1 ，相等为0 ，小于为-1
- (int)compareWithHQLDateWithOutTime:(HQLDateModel *)date;

// 单纯比较月份，不比较时间，若self大于date 则为1 ，相等为0 ，小于为-1
- (int)compareMonthWithHQLDateWithOutTime:(HQLDateModel *)date;

// 比较日期大小， 若self大于date 则为1 ，相等为0 ，小于为-1
- (int)compareWithHQLDate:(HQLDateModel *)date;

// 返回当前日期在该月中是第几周
- (NSInteger)weekOfMonth;

// 获取格式化日期字符串
- (NSString *)getFormatStringWithDateFormat:(NSString *)format;

+ (NSInteger)rowOfCalenderInMonth:(NSInteger)month year:(NSInteger)year;

+ (NSUInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

+ (NSInteger)weekdayOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

+ (instancetype)HQLDate;

/**
 返回一个数组,该数组按照当前日期,将该月的日期都分别添加到对应的weekday
 */
/*- (NSMutableArray <NSMutableArray *>*)dataSourceOfCurrentMonth;
 + (NSMutableArray <NSMutableArray *>*)dataSourceOfYear:(NSInteger)year month:(NSInteger)month;*/

@end
