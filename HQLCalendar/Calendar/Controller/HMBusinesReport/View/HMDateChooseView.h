//
//  HMDateChooseView.h
//  
//
//  Created by weplus on 2016/11/21.
//
//

#import <UIKit/UIKit.h>
#import "HQLCalendar.h"

@class HMDateChooseView;

@protocol HMDateChooseViewDelegate <NSObject>

@optional;
- (void)dateChooseView:(HMDateChooseView *)chooseView didSelectBeginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end titleString:(NSString *)titleString;

- (void)dateChooseView:(HMDateChooseView *)chooseView didChangeSelectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end titleString:(NSString *)titleString;

- (void)dateChooseViewDidShow:(HMDateChooseView *)chooseView;

- (void)dateChooseViewDidHide:(HMDateChooseView *)chooseView;

@end

@interface HMDateChooseView : UIView

@property (assign, nonatomic) id <HMDateChooseViewDelegate>delegate;

@property (strong, nonatomic) HQLDateModel *dateModel;

- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel;

/**
 选择上一天或下一天

 @param isLast Yes 为选择上一天，NO为选择下一天
 */
- (void)selectLastOrNextDay:(BOOL)isLast;

/**
 选择上一周或下一周

 @param isLast YES为选择上一周，NO为选择下一周
 */
- (void)selectLastOrNextWeek:(BOOL)isLast;

/**
 选择上个月或下个月
 
 @param isLast YES为选择上个月，NO为选择下个月
 */
- (void)selectLastOrNextMonth:(BOOL)isLast;

- (void)selectDate:(HQLDateModel *)date isTriggerDelegate:(BOOL)yesOrNo;

- (void)showInParentsView:(UIView *)view;

- (void)hideView;

@end
