//
//  HQLCalenderCell.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQLCalendarView.h"

@class HQLDateModel, HQLCalendarModel;

@interface HQLCalendarCell : UICollectionViewCell

@property (strong, nonatomic) HQLCalendarModel *model;

/**
 选中模式
 */
@property (assign, nonatomic) HQLCalendarViewSelectionStyle HQL_SelectionStyle;

/**
 根据model的 isAllowSelectedFutureDate 和 isAllowSelectedPassedDate 来比较当前日期，返回是否可以选择

 @return 结果
 */
- (BOOL)isAllowSelectedCell;

/**
 是否选中当前日期
 */
//@property (assign, nonatomic, getter=isSelectedCurrentDate) BOOL selectedCurrentDate;

/**
 是否可以选中未来的日期
 */
//@property (assign, nonatomic, getter=isAllowSelectedFutureDate) BOOL allowSelectedFutureDate;

/**
 是否显示描述string
 */
//@property (assign, nonatomic, getter=isShowDescString) BOOL showDescString;

@end

@interface HQLCalendarModel : NSObject

@property (strong, nonatomic) HQLDateModel *date;

@property (assign, nonatomic, getter=isZero) BOOL zero; // 空model

@property (assign, nonatomic, getter=isSelected) BOOL selected;

@property (assign, nonatomic) HQLCalendarViewSelectionStyleCustom customStyle;

/**
 是否可以选中未来的日期
 */
@property (assign, nonatomic, getter=isAllowSelectedFutureDate) BOOL allowSelectedFutureDate;

/**
 是否可以选中过去日期
 */
@property (assign, nonatomic, getter=isAllowSelectedPassedDate) BOOL allowSelectedPassedDate;

@property (copy, nonatomic) NSString *descString;
@property (strong, nonatomic) UIColor *descNormalColor;
@property (strong, nonatomic) UIColor *descSelectColor;

@property (strong, nonatomic) UIColor *dateNormalColor;
@property (strong, nonatomic) UIColor *dateSelectColor;

/**
 shapeColor
 */
@property (strong, nonatomic) UIColor *tintColor;

- (instancetype)initWithZero; // 创建一个空的model

@end

