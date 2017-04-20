//
//  HQLDateModel.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/18.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLDateModel.h"

@implementation HQLDateModel

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    if (self = [super init]) {
        if (![self checkDataWithYear:year month:month day:day hour:hour minute:minute second:second]) {
            return nil;
        }
        self.year = year;
        self.month = month;
        self.day = day;
        self.hour = hour;
        self.minute = minute;
        self.second = second;
    }
    return self;
}

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [self initWithYear:year month:month day:day hour:0 minute:0 second:0];
}

- (instancetype)initwithNSDate:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger year = [cal component:NSCalendarUnitYear fromDate:date];
    NSInteger month = [cal component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [cal component:NSCalendarUnitDay fromDate:date];
    NSInteger hour = [cal component:NSCalendarUnitHour fromDate:date];
    NSInteger minute = [cal component:NSCalendarUnitMinute fromDate:date];
    NSInteger second = [cal component:NSCalendarUnitSecond fromDate:date];
    return [self initWithYear:year month:month day:day hour:hour minute:minute second:second];
}

- (instancetype)initWithHQLDate:(HQLDateModel *)date {
    return [self initWithYear:date.year month:date.month day:date.day hour:date.hour minute:date.minute second:date.second];
}

- (instancetype)initCurrentDate {
    NSDate *date = [NSDate date];
    NSTimeInterval timeZone = [[NSTimeZone systemTimeZone] secondsFromGMT];
    [date dateByAddingTimeInterval:timeZone];
    return [self initwithNSDate:date];
}

- (NSString *)description {
    return  [NSString stringWithFormat:@"year : %ld, month : %ld, day : %ld, hour : %ld, minute : %ld, second : %ld",(long)self.year, (long)self.month, (long)self.day, (long)self.hour, (long)self.minute, (long)self.second];
}

#pragma mark - event

- (NSDate *)changeToNSDate {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:self.year];
    [comp setMonth:self.month];
    [comp setDay:self.day];
    [comp setHour:self.hour];
    [comp setMinute:self.minute];
    [comp setSecond:self.second];
    NSDate *date = [cal dateFromComponents:comp];
    NSTimeInterval timeZone = [[NSTimeZone systemTimeZone] secondsFromGMT];
    [date dateByAddingTimeInterval:timeZone];
    return date;
}

- (BOOL)checkDataWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    // 判断日期是否正确
    NSInteger maxDays = 0;
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        // 闰年
        maxDays = 29;
    } else {
        // 平年
        maxDays = 28;
    }
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        maxDays = 31;
    } else if (month != 2) {
        maxDays = 30;
    }
    if (day > maxDays) {
        return NO;
    }
    if (month < 1 || month > 12 || hour < 0 || hour > 24 || day < 1 || day > 31 || minute < 0 || minute > 60 || second < 0 || second > 60) {
        return NO;
    }
    return YES;
}

- (NSInteger)numberOfDaysInCurrentMonth {
    NSDate *date = [self changeToNSDate];
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

- (NSInteger)rowOfCalenderInCurrentMonth {
    NSInteger number = [self numberOfDaysInCurrentMonth]; // 该月的天数
    NSInteger weekday = [self weekdayOfCurrentDate]; // 1号是星期几
    NSInteger firstRowNumber = kWeekdayNum - weekday + 1; // 日历第一行填充数据的个数
    NSInteger remainder = (number - firstRowNumber) % kWeekdayNum; // 最后一行剩余的个数
    // 行数 = 1(第一行) + ((每月个数 - 第一行填充的个数) / 7) +
    return (1 + ((number - firstRowNumber) / kWeekdayNum) + (remainder == 0 ? 0 : 1));
}

- (NSInteger)weekdayOfCurrentDate {
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [self changeToNSDate];
    return [calender component:NSCalendarUnitWeekday fromDate:date];
}

- (BOOL)isEqualHQLDate:(HQLDateModel *)date {
    return (self.year == date.year && self.month == date.month && self.day == date.day && self.minute == date.minute && self.hour == date.hour && self.second == date.second);
}

- (BOOL)isEqualHQLDateWithOutTime:(HQLDateModel *)date {
    HQLDateModel *first = [[HQLDateModel alloc] initWithHQLDate:self];
    HQLDateModel *second = [[HQLDateModel alloc] initWithHQLDate:date];
    first.hour = second.hour = first.minute = second.minute = first.second = second.second = 0;
    return [first isEqualHQLDate:second];
}

- (int)compareWithHQLDate:(HQLDateModel *)date {
    NSTimeInterval firstTime = [[self changeToNSDate] timeIntervalSince1970];
    NSTimeInterval secondTime = [[date changeToNSDate] timeIntervalSince1970];
    int result = 1;
    if (firstTime == secondTime) {
        result = 0;
    } else if (firstTime > secondTime) {
        result = 1;
    } else {
        result = -1;
    }
    return result;
}

- (NSString *)getFormatStringWithDateFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:[self changeToNSDate]];
}

- (int)compareWithHQLDateWithOutTime:(HQLDateModel *)date {
    HQLDateModel *first = [[HQLDateModel alloc] initWithHQLDate:self];
    HQLDateModel *second = [[HQLDateModel alloc] initWithHQLDate:date];
    first.hour = second.hour = first.minute = second.minute = first.second = second.second = 0;
    return [first compareWithHQLDate:second];
}

- (int)compareMonthWithHQLDateWithOutTime:(HQLDateModel *)date {
    HQLDateModel *first = [[HQLDateModel alloc] initWithHQLDate:self];
    HQLDateModel *second = [[HQLDateModel alloc] initWithHQLDate:date];
    first.hour = second.hour = first.minute = second.minute = first.second = second.second = 0;
    first.day = second.day = 1; // 都为1号
    return [first compareWithHQLDate:second];
}

- (NSInteger)weekOfMonth {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar component:NSCalendarUnitWeekOfMonth fromDate:[self changeToNSDate]];
}

#pragma mark - class method

+ (NSInteger)rowOfCalenderInMonth:(NSInteger)month year:(NSInteger)year {
    HQLDateModel *date = [[HQLDateModel alloc] initWithYear:year month:month day:1];
    return [date rowOfCalenderInCurrentMonth];
}

+ (NSUInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year {
    if (month > 12 || month < 1) return 0;
    HQLDateModel *date = [[HQLDateModel alloc] initWithYear:year month:month day:1];
    return [date numberOfDaysInCurrentMonth];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateFromComponents:comps];
}

+ (NSInteger)weekdayOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [[[HQLDateModel alloc] initWithYear:year month:month day:day] weekdayOfCurrentDate];
}

+ (instancetype)HQLDate {
    return [[HQLDateModel alloc] initCurrentDate];
}

#pragma mark - setter

- (void)setMonth:(NSInteger)month {
    if (month < 1 || month > 12) {
        return;
    }
    _month = month;
}

- (void)setHour:(NSInteger)hour {
    if (hour < 0 || hour > 24) {
        return;
    }
    _hour = hour;
}

- (void)setDay:(NSInteger)day {
    if (day < 1 || day > 31) {
        return;
    }
    _day = day;
}

- (void)setMinute:(NSInteger)minute {
    if (minute < 0 || minute > 60) {
        return;
    }
    _minute = minute;
}

- (void)setSecond:(NSInteger)second {
    if (second < 0 || second > 60) {
        return;
    }
    _second = second;
}

@end
