//
//  HQLCalenderView.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQLDateModel.h"

#define HQLColorWithAlpha(r,g,b,a) [UIColor colorWithRed:( r / 255.0)  green:( g / 255.0) blue:( b / 255.0) alpha:a]
#define HQLColor(r,g,b) HQLColorWithAlpha(r,g,b,1)

#ifdef DEBUG
#define ZXString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define HQLLog(...) printf("<<%s 第%d行>>: %s\n\n", [ZXString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define HQLLog(...)
#endif

@class HQLCalendarView, HQLCalendarModel;

@protocol HQLCalendarViewDelegate <NSObject>

@optional
- (void)calendarView:(HQLCalendarView *)calendarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end;

- (void)calendarViewSelectCustom:(HQLCalendarView *)calendarView selectDate:(HQLDateModel *)date;

- (void)calendarViewDidSetDataSource:(HQLCalendarView *)calendar selectionStyle:(HQLCalendarViewSelectionStyle) style date:(HQLDateModel *)date;

/**
 获取cell的descString和descColor

 @param calendarView self
 @param style        当前calendarView的selectionStyle(若style == calendarViewSelectionStyleMonth,返回十二个月的数据;否则返回一个月的数据)
 @param date         当前日期 (若style == calendarViewSelectionStyleMonth,使用date.year来获取数据;否则使用date.year date.month来获取数据)

 @return calendarModel来装数据
 */
- (NSArray <HQLCalendarModel *>*)calendarViewGetDateConfig:(HQLCalendarView *)calendarView selectionStyle:(HQLCalendarViewSelectionStyle)style date:(HQLDateModel *)date;

@end

@interface HQLCalendarView : UIView

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
 是否选中当前日期 -- 没实现
 */
@property (assign, nonatomic, getter=isSelectedCurrentDate) BOOL selectedCurrentDate;

/**
 是否可以选中未来的日期,默认为NO
 */
@property (assign, nonatomic, getter=isAllowSelectedFutureDate) BOOL allowSelectedFutureDate;

/**
 是否可以选中已过去的日期,默认为YES
 */
@property (assign, nonatomic, getter=isAllowSelectedPassedDate) BOOL allowSelectedPassedDate;

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


/**
 创建一个selectionStyle为month的日历
 */
- (instancetype)initMonthStyleViewWithFrame:(CGRect)frame;

// 选择某个日期
- (void)selectDate:(HQLDateModel *)date isTriggerDelegate:(BOOL)yesOrNo;

// 取消选择某个日期
- (void)deselectDate:(HQLDateModel *)date;

- (void)reloadData;

/**
 给当前calendarView的dataSource赋值(desc等配置)

 @param configArray 主要赋值
 @param style       style,如果style与当前style不相等,则不会赋值(主要分辨选择月和其他情况)
 @param date        configArray的日期(月跟年)
 */
- (void)reloadDataWithCellConfig:(NSArray <HQLCalendarModel *>*)configArray stytle:(HQLCalendarViewSelectionStyle)style date:(HQLDateModel *)date;

@end
