//
//  HQLCalenderView.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQLDateModel;

@interface HQLCalenderView : UIView

//@property (assign, nonatomic) NSInteger year;
//@property (assign, nonatomic) NSInteger month;

/**
 输入要显示的月份的dateModel
 */
@property (strong, nonatomic) HQLDateModel *dateModel;
@property (assign, nonatomic) CGFloat viewHeight;

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
