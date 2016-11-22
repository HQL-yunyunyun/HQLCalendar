//
//  HMDateOperationView.m
//  HuanMoney
//
//  Created by weplus on 2016/11/21.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import "HMDateOperationView.h"
#import "HQLCalendar.h"
#import "HMTitleButton.h"
#import "HMDateChooseView.h"

#define kLastButtonTag 1991
#define kNextButtonTag 9119

@interface HMDateOperationView () <HMDateChooseViewDelegate>

@property (strong, nonatomic) UIButton *dateButton;

@property (strong, nonatomic) HMTitleButton *nextButton;

@property (strong, nonatomic) UIButton *lastButton;

@property (assign, nonatomic) HQLCalendarViewSelectionStyle currentStyle; // 默认为dateStyle

@property (strong, nonatomic) HMDateChooseView *chooseView;

@end

@implementation HMDateOperationView

- (void)dealloc {
    ZXLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        [self setCurrentStyle:calendarViewSelectionStyleDay];
//        [self.chooseView selectDate:[HQLDateModel HQLDate] isTriggerDelegate:YES];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.height = 50;
    self.width = ZXScreenW;
    CGFloat margin = 16;
    
    self.dateButton.width = ZXScreenW;
    [self.dateButton sizeToFit];
    self.dateButton.centerY = self.height * 0.5;
    self.dateButton.centerX = self.width * 0.5;
    
    [self.lastButton sizeToFit];
    self.lastButton.x = margin;
    self.lastButton.centerY = self.height * 0.5;
    
    [self.nextButton sizeToFit];
    self.nextButton.x = self.width - self.nextButton.width - margin;
    self.nextButton.centerY = self.height * 0.5;
}

#pragma mark - prepare UI

- (void)prepareUI {
    [self addSubview:self.dateButton];
    [self addSubview:self.lastButton];
    [self addSubview:self.nextButton];
}

#pragma mark - event

- (void)lastOrNextButtonDidClick:(UIButton *)button {
    if (button.tag != kLastButtonTag && button.tag != kNextButtonTag) return;
    BOOL isLast = button.tag == kLastButtonTag;
    if (self.currentStyle == calendarViewSelectionStyleDay) {
        [self.chooseView selectLastOrNextDay:isLast];
    } else if (self.currentStyle == calendarViewSelectionStyleWeek) {
        [self.chooseView selectLastOrNextWeek:isLast];
    } else if (self.currentStyle == calendarViewSelectionStyleMonth) {
        [self.chooseView selectLastOrNextMonth:isLast];
    }
}

- (void)dateButtonDidClick:(UIButton *)button {
    button.selected = !button.isSelected;
    if (button.isSelected) {
        [self.chooseView showInParentsView:[UIApplication sharedApplication].keyWindow];
    } else {
        [self.chooseView hideView];
    }
}

- (void)selectDate:(HQLDateModel *)date isTriggerDelegate:(BOOL)yesOrNo {
    [self.chooseView selectDate:date isTriggerDelegate:yesOrNo];
}

#pragma mark - date choose view delegate

- (void)dateChooseView:(HMDateChooseView *)chooseView didChangeSelectionStyle:(HQLCalendarViewSelectionStyle)style titleString:(NSString *)titleString {
    [self.dateButton setTitle:titleString forState:UIControlStateNormal];
    self.currentStyle = style;
    [self setNeedsLayout];
}

- (void)dateChooseView:(HMDateChooseView *)chooseView didSelectBeginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end titleString:(NSString *)titleString {
    [self.dateButton setTitle:titleString forState:UIControlStateNormal];
    [self setNeedsLayout];
    if ([end isEqualHQLDateWithOutTime:[HQLDateModel HQLDate]]) {
        [self.nextButton setEnabled:NO];
    } else {
        [self.nextButton setEnabled:YES];
    }
}

#pragma mark - setter

- (void)setCurrentStyle:(HQLCalendarViewSelectionStyle)currentStyle {
    _currentStyle = currentStyle;
    
    NSString *lastButtonString = nil;
    NSString *nextButtonString = nil;
    if (currentStyle == calendarViewSelectionStyleDay) {
        lastButtonString = @"前一天";
        nextButtonString = @"后一天";
    } else if (currentStyle == calendarViewSelectionStyleWeek) {
        lastButtonString = @"前一周";
        nextButtonString = @"后一周";
    } else if (currentStyle == calendarViewSelectionStyleMonth) {
        lastButtonString = @"前一月";
        nextButtonString = @"后一月";
    }
    [self.lastButton setTitle:lastButtonString forState:UIControlStateNormal];
    [self.nextButton setTitle:nextButtonString forState:UIControlStateNormal];
}

#pragma mark - getter

- (HMDateChooseView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[HMDateChooseView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) dateModel:[HQLDateModel HQLDate]];
        _chooseView.delegate = self;
    }
    return _chooseView;
}

- (UIButton *)dateButton {
    if (!_dateButton) {
        _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateButton setImage:[UIImage imageNamed:@"check_box_icon_selected"] forState:UIControlStateNormal];
        [_dateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_dateButton setTitleColor:ZXColor(51, 51, 51) forState:UIControlStateNormal];
        [_dateButton setBackgroundColor:ZXColor(230, 228, 230)];
        [_dateButton addTarget:self action:@selector(dateButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _dateButton.layer.cornerRadius = 3.0f;
        _dateButton.layer.masksToBounds = YES;
    }
    return _dateButton;
}

- (HMTitleButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [HMTitleButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setImage:[UIImage imageNamed:@"icon_next_button_gray"] forState:UIControlStateNormal];
        [_nextButton setTitleColor:ZXColor(220, 218, 220) forState:UIControlStateDisabled];
        [_nextButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_nextButton setTitleColor:ZXColor(51, 51, 51) forState:UIControlStateNormal];
        [_nextButton setTag:kNextButtonTag];
        [_nextButton addTarget:self action:@selector(lastOrNextButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UIButton *)lastButton {
    if (!_lastButton) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastButton setImage:[UIImage imageNamed:@"icon_last_button_gray"] forState:UIControlStateNormal];
        [_lastButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_lastButton setTitleColor:ZXColor(51, 51, 51) forState:UIControlStateNormal];
        [_lastButton setTag:kLastButtonTag];
        [_lastButton addTarget:self action:@selector(lastOrNextButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastButton;
}

@end
