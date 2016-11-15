//
//  HQLCalenderCell.h
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQLCalendarView.h"

@class HQLDateModel;

@interface HQLCalendarCell : UICollectionViewCell

@property (strong, nonatomic) HQLDateModel *dateModel;

/**
 选中模式
 */
@property (assign, nonatomic) HQLCalendarViewSelectionStyle HQL_SelectionStyle;

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
@property (assign, nonatomic, getter=isShowDescString) BOOL showDescString;

@end
