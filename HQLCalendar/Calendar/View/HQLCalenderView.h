//
//  HQLCalenderView.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HQLDateModel, HQLCalenderView;

typedef enum {
    calenderViewSelectionStyleDay = 0,  // 日期选中时的模式,选中单日
    calenderViewSelectionStyleWeek ,    // 日期选中时的模式,选中一周
    calenderViewSelectionStyleCustom  //  日期选中时的模式,自定义区间
} HQLCalenderViewSelectionStyle;

typedef enum {
    calenderViewSelectionStyleCustomBeginDate = 0,     // 自定义区间的开始
    calenderViewSelectionStyleCustomMiddleDate,          // 自定义区间的中间
    calenderViewSelectionStyleCustomEndDate               // 自定义区间的结束
} HQLCalenderViewSelectionStyleCustom;

@protocol HQLCalenderViewDelegate <NSObject>

@optional
- (void)calenderView:(HQLCalenderView *)calederView selectionStyle:(HQLCalenderViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end;

@end

@interface HQLCalenderView : UIView

//@property (assign, nonatomic) NSInteger year;
//@property (assign, nonatomic) NSInteger month;

/**
 输入要显示的月份的dateModel
 */
@property (strong, nonatomic) HQLDateModel *dateModel;
@property (assign, nonatomic) CGFloat viewHeight;
@property (assign, nonatomic) id <HQLCalenderViewDelegate>delegate;

/**
 选中模式
 */
@property (assign, nonatomic) HQLCalenderViewSelectionStyle selectionStyle;

/**
 是否选中当前日期
 */
@property (assign, nonatomic, getter=isSelectedCurrentDate) BOOL selectedCurrentDate;

/**
 是否可以选中未来的日期
 */
@property (assign, nonatomic, getter=isAllowSelectedFutureDate) BOOL allowSelectedFutureDate;

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

@property (assign, nonatomic) HQLCalenderViewSelectionStyleCustom customStyle;

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
