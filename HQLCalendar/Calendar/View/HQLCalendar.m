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
#define kLastButtonTag 2112
#define kNextButtonTag 1221


@interface HQLCalendar () <HQLCalendarViewDelegate>

@property (strong, nonatomic) NSMutableArray <HQLCalendarView *>*viewArray;

@property (strong, nonatomic) UIView *titleView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) HQLDateModel *currentDate;

@property (strong, nonatomic) UIButton *lastButton;

@property (strong, nonatomic) UIButton *nextButton;

@property (weak, nonatomic) UIView *line;

@property (strong, nonatomic) NSMutableArray <HQLDateModel *>*dateRecord; // 记录当前选择的日期

@property (assign, nonatomic) BOOL isAnimate;

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
    HQLLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = 10;
    
    self.titleView.width = self.width;
    self.line.width = self.width;
    
    self.lastButton.width = 50;
    self.lastButton.y = (self.titleView.height - self.lastButton.height) * 0.5;
    self.lastButton.x = margin;
    
    self.nextButton.width = 50;
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
//    [self setBackgroundColor:[UIColor redColor]];
}

#pragma mark - event 

- (void)lastOrNextMonth:(UIButton *)button {
    if (self.isAnimate || (button.tag != kLastButtonTag && button.tag != kNextButtonTag)) {
        return;
    }
    self.isAnimate = YES;
    BOOL isLastButton = button.tag == kLastButtonTag;
    HQLCalendarView *operationView = isLastButton ? self.viewArray.lastObject : self.viewArray.firstObject;
    [self.viewArray removeObject:operationView];
    if (isLastButton) {
        [self.viewArray insertObject:operationView atIndex:0];
    } else {
        [self.viewArray addObject:operationView];
    }
    
    [self setCurrentDate:[self getDate:self.currentDate isBefore:isLastButton]];
    typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.viewArray[0] setHidden:isLastButton];
        [weakSelf.viewArray[1] setHidden:NO];
        [weakSelf.viewArray[2] setHidden:!isLastButton];
        [weakSelf calculateCalendarViewFrame];
    } completion:^(BOOL finished) {
        [weakSelf.viewArray.firstObject setHidden:YES];
        [weakSelf.viewArray.lastObject setHidden:YES];
        weakSelf.isAnimate = NO;
    }];
}

// 获取 上个月 或 下个月 的date
- (HQLDateModel *)getDate:(HQLDateModel *)date isBefore:(BOOL)yesOrNo {
    HQLDateModel *targetDate = [[HQLDateModel alloc] initWithHQLDate:date];
    if (self.selectionStyle != calendarViewSelectionStyleMonth) {
        NSInteger conditionMonth = yesOrNo ? 1 : 12;
        NSInteger sign = yesOrNo ? -1 : 1;
        if (date.month == conditionMonth) {
            targetDate.year += sign;
            targetDate.month = yesOrNo ? 12 : 1;
        } else {
            targetDate.month += sign;
        }
    } else {
        targetDate.year = yesOrNo ? targetDate.year - 1 : targetDate.year + 1;
    }
    return targetDate;
}

 // 计算frame值
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

// 选择当前日期
- (void)selectRecordDate {
    HQLCalendarView *view = self.viewArray[1];
    [self selectOrDeselectRecordDate:view isSelected:YES];
}

// 取消选择当前日期
- (void)deselectRecordDate {
    for (int i = 0; i < 3 ; i++) {
        HQLCalendarView *view = self.viewArray[i];
        if (i != 1) {
            [self selectOrDeselectRecordDate:view isSelected:NO];
        }
    }
}

// 选择或取消当前日期
- (void)selectOrDeselectRecordDate:(HQLCalendarView *)view isSelected:(BOOL)selected{
    for (HQLDateModel *date in self.dateRecord) {
        if (self.selectionStyle == calendarViewSelectionStyleMonth) {
            if (view.dateModel.year == date.year) {
                if (selected) {
                    [view selectDate:date];
                } else {
                    [view deselectDate:date];
                }
            }
        } else {
            if (view.dateModel.year == date.year && view.dateModel.month == date.month) {
                if (selected) {
                    [view selectDate:date];
                } else {
                    [view deselectDate:date];
                }
            }
        }
    }
}

- (NSString *)getDateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (self.selectionStyle == calendarViewSelectionStyleMonth) {
        [formatter setDateFormat:@"yyyy年"];
    } else {
        [formatter setDateFormat:@"yyyy年MM月"];
    }
    return [formatter stringFromDate:[self.currentDate changeToNSDate]];
}

#pragma mark - calendar view delegate

- (void)calendarView:(HQLCalendarView *)caledarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end {
    // 取消当前选择的日期
    if (![begin isEqualHQLDateWithOutTime:self.dateRecord.firstObject] && ![end isEqualHQLDateWithOutTime:self.dateRecord.lastObject]) {
        [self deselectRecordDate];
        // 记录当前选择的日期
        [self.dateRecord removeAllObjects];
        [self.dateRecord addObject:begin];
        [self.dateRecord addObject:end];
    }
    
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
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kTitleViewHeight - 0.5, self.width, 0.5)];
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
//        [_lastButton setTitle:@"last" forState:UIControlStateNormal];
        _lastButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_lastButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_last_button_orange" ofType:@"png"]] forState:UIControlStateNormal];
        [_lastButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_lastButton sizeToFit];
        [_lastButton setTag:kLastButtonTag];
        [_lastButton addTarget:self action:@selector(lastOrNextMonth:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_nextButton setTitle:@"next" forState:UIControlStateNormal];
        _nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_nextButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"icon_next_button_orange" ofType:@"png"]] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_nextButton sizeToFit];
        [_nextButton setTag:kNextButtonTag];
        [_nextButton addTarget:self action:@selector(lastOrNextMonth:) forControlEvents:UIControlEventTouchUpInside];
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
            view.hidden = (i != 1);
            [view reloadData];
            [self addSubview:view];
            [array addObject:view];
        }
        _viewArray = array;
    }
    return _viewArray;
}

- (NSMutableArray<HQLDateModel *> *)dateRecord {
    if (!_dateRecord) {
        _dateRecord = [NSMutableArray array];
    }
    return _dateRecord;
}

#pragma mark - setter

- (void)setCurrentDate:(HQLDateModel *)currentDate {
    currentDate.day = 1;
    _currentDate = currentDate;
    
    [self.titleLabel setText:[self getDateString]];
    
    // 设置日期
    if (![self isResetCalendarView:self.viewArray[0] date:[self getDate:currentDate isBefore:YES]]) {
        // 前一个月是否相等
        self.viewArray.firstObject.dateModel = [self getDate:currentDate isBefore:YES];
        [self.viewArray.firstObject reloadData];
    }
    if (![self isResetCalendarView:self.viewArray[1] date:currentDate]) {
        self.viewArray[1].dateModel = currentDate;
        [self.viewArray[1] reloadData];
    }
    if (![self isResetCalendarView:self.viewArray[2] date:[self getDate:currentDate isBefore:NO]]) {
        self.viewArray[2].dateModel = [self getDate:currentDate isBefore:NO];
        [self.viewArray[2] reloadData];
    }
    
    // 选择当前选择的日期
    [self selectRecordDate];
}

- (BOOL)isResetCalendarView:(HQLCalendarView *)view date:(HQLDateModel *)date {
    if (self.selectionStyle == calendarViewSelectionStyleMonth) {
        return view.dateModel.year == date.year;
    } else {
        return [view.dateModel isEqualHQLDateWithOutTime:date];
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
        [view reloadData];
    }
    if (selectionStyle == calendarViewSelectionStyleMonth) {
        [self.titleLabel setText:[self getDateString]];
    }
}

@end
