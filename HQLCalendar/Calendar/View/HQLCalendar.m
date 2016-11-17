//
//  HQLCalender.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/15.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLCalendar.h"
#import "HQLCalendarView.h"
#import "UIView+ST.h"

#define kTitleViewHeight 30

@interface HQLCalendar () <HQLCalendarViewDelegate>

@property (strong, nonatomic) NSMutableArray <HQLCalendarView *>*viewArray;

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) HQLDateModel *currentDate;

@property (strong, nonatomic) UIButton *lastButton;

@property (strong, nonatomic) UIButton *nextButton;

@property (weak, nonatomic) UIView *line;

@end

@implementation HQLCalendar

- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        self.currentDate = dateModel;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    self.titleView.width = self.width;
    self.line.width = self.width;
    
    self.lastButton.y = (self.titleView.height - self.lastButton.height) * 0.5;
    self.lastButton.x = margin;
    
    self.nextButton.y = (self.titleView.height - self.nextButton.height) * 0.5;
    self.nextButton.x = self.titleView.width - self.nextButton.width - margin;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.width - self.nextButton.width - self.lastButton.width - 2 * margin;
    self.titleLabel.y = (self.titleView.height - self.titleLabel.height) * 0.5;
    self.titleLabel.x = CGRectGetMaxX(self.lastButton.frame);
    
    [self calculateCalendarViewFrame];
}

#pragma mark - prepare UI 

- (void)prepareUI {
    [self addSubview:self.titleView];
    [self setBackgroundColor:[UIColor redColor]];
}

#pragma mark - event 

- (void)lastButtonDidClick:(UIButton *)lastButton {
    HQLCalendarView *lastView = self.viewArray.lastObject;
    [self.viewArray removeObject:lastView];
    [self.viewArray insertObject:lastView atIndex:0];
    [self setCurrentDate:[self getDate:self.currentDate isBefore:YES]];
    [self calculateCalendarViewFrame];
}

- (void)nextButtonDidClick:(UIButton *)nextButton {
    HQLCalendarView *firstView = self.viewArray.firstObject;
    [self.viewArray removeObject:firstView];
    [self.viewArray addObject:firstView];
    [self setCurrentDate:[self getDate:self.currentDate isBefore:NO]];
    [self calculateCalendarViewFrame];
}

- (HQLDateModel *)getDate:(HQLDateModel *)date isBefore:(BOOL)yesOrNo {
    HQLDateModel *targetDate = [[HQLDateModel alloc] initWithHQLDate:date];
    NSInteger conditionMonth = yesOrNo ? 1 : 12;
    NSInteger sign = yesOrNo ? -1 : 1;
    if (date.month == conditionMonth) {
        targetDate.year += sign;
        targetDate.month = yesOrNo ? 12 : 1;
    } else {
        targetDate.month += sign;
    }
    return targetDate;
}

- (void)calculateCalendarViewFrame {
    for (int i = 0; i < 3; i++) {
        HQLCalendarView *view = self.viewArray[i];
        if (i == 0) {
            view.x = -self.width;
        } else if (i == 1) {
            view.x = 0;
        } else {
            view.x = self.width;
        }
        view.y = CGRectGetMaxY(self.titleView.frame);
    }
    self.height = CGRectGetMaxY(self.viewArray[1].frame);
}

#pragma mark - calendar view delegate

- (void)calendarView:(HQLCalendarView *)caledarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end {
    if ([self.delegate respondsToSelector:@selector(calendar:calendarView:selectionStyle:beginDate:endDate:)]) {
        [self.delegate calendar:self calendarView:caledarView selectionStyle:style beginDate:begin endDate:end];
    }
}

#pragma mark - getter

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kTitleViewHeight)];
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        
        // bottomLine
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kTitleViewHeight, self.width, 0.5)];
        [line setBackgroundColor:HQLColor(220, 218, 220)];
        [_titleView addSubview:line];
        self.line = line;
        
        [_titleView addSubview:self.lastButton];
        [_titleView addSubview:self.nextButton];
        [_titleView addSubview:self.titleLabel];
    }
    return _titleView;
}

- (UIButton *)lastButton {
    if (!_lastButton) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastButton setTitle:@"last" forState:UIControlStateNormal];
        [_lastButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_lastButton sizeToFit];
        [_lastButton addTarget:self action:@selector(lastButtonDidClick:)];
    }
    return _lastButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"next" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_nextButton sizeToFit];
        [_nextButton addTarget:self action:@selector(nextButtonDidClick:)];
    }
    return _nextButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:HQLColor(51, 51, 51)];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        _titleLabel.width = self.width - self.nextButton.width - self.lastButton.width - 2 * 5;
    }
    return _titleLabel;
}

- (NSMutableArray<HQLCalendarView *> *)viewArray {
    if (!_viewArray) {
        if (self.currentDate == nil) return nil;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
        for (int i = 0; i < 3;  i++) {
            HQLDateModel *date = self.currentDate;
            if (i != 1) {
                date = [self getDate:date isBefore:(i == 0)];
            }
            HQLCalendarView *view = [[HQLCalendarView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.width, 100) dateModel:date];
            view.delegate = self;
            view.selectionStyle = self.selectionStyle;
            view.allowSelectedFutureDate = self.allowSelectedFutureDate;
            [self addSubview:view];
            [array addObject:view];
        }
        _viewArray = array;
//        [self setCurrentDate:self.currentDate];
    }
    return _viewArray;
}

#pragma mark - setter

- (void)setCurrentDate:(HQLDateModel *)currentDate {
    currentDate.day = 1;
    _currentDate = currentDate;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月"];
    [self.titleLabel setText:[formatter stringFromDate:[currentDate changeToNSDate]]];
    
    // 设置日期
//    if (self.viewArray.count == 0 || self.viewArray == nil) return;
    if (![self.viewArray[0].dateModel isEqualHQLDateWithOutTime:[self getDate:currentDate isBefore:YES]]) {
        // 前一个月是否相等
        NSLog(@"1------%@", self.viewArray[0].dateModel);
        self.viewArray.firstObject.dateModel = [self getDate:currentDate isBefore:YES];
        [self.viewArray.firstObject reloadData];
    }
    if (![self.viewArray[1].dateModel isEqualHQLDateWithOutTime:currentDate]) {
        NSLog(@"2------%@", self.viewArray[1].dateModel);
        self.viewArray[1].dateModel = currentDate;
        [self.viewArray[1] reloadData];
    }
    if (![self.viewArray[2].dateModel isEqualHQLDateWithOutTime:[self getDate:currentDate isBefore:NO]]) {
        NSLog(@"3------%@", self.viewArray[2].dateModel);
        self.viewArray[2].dateModel = [self getDate:currentDate isBefore:NO];
        [self.viewArray[2] reloadData];
    }
}

- (void)setAllowSelectedFutureDate:(BOOL)allowSelectedFutureDate {
    _allowSelectedFutureDate = allowSelectedFutureDate;
    if (self.viewArray.count == 0 || !self.viewArray) return;
    for (HQLCalendarView *view in self.viewArray) {
        [view setAllowSelectedFutureDate:allowSelectedFutureDate];
    }
}

- (void)setSelectionStyle:(HQLCalendarViewSelectionStyle)selectionStyle {
    _selectionStyle = selectionStyle;
    if (self.viewArray.count == 0 || !self.viewArray) return;
    for (HQLCalendarView *view in self.viewArray) {
        [view setSelectionStyle:selectionStyle];
    }
}

@end
