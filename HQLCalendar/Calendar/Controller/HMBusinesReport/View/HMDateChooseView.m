//
//  HMDateChooseView.m
//  
//
//  Created by weplus on 2016/11/21.
//
//

#import "HMDateChooseView.h"

#define kPadding 16
#define kTopPadding 5
#define kSegmentedConrtolHeight 43

@interface HMDateChooseView () <HQLCalendarDelegate>

@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) HQLCalendar *calendar;

//@property (strong, nonatomic) HQLCalendar *weekChooseCalendar;
//
//@property (strong, nonatomic) HQLCalendar *monthChooseCalendar;

@property (strong, nonatomic) HQLDateModel *dayRecord;

@property (strong, nonatomic) HQLDateModel *weekRecord; // 只需要某一周的某一天就足够了

@property (strong, nonatomic) HQLDateModel *monthRecord;

@property (strong, nonatomic) UISegmentedControl *segmentedControl;

@property (assign, nonatomic) HQLCalendarViewSelectionStyle currentStyle;

@property (strong, nonatomic) UIView *contentView;

@property (assign, nonatomic) CGFloat viewY;

@end

@implementation HMDateChooseView

- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel {
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        self.dateModel = dateModel;
        self.viewY = frame.origin.y;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.width = ZXScreenW;
    self.height = ZXScreenH - self.viewY;
    self.x = 0;
    
    self.maskView.width = self.width;
    self.maskView.height = self.height;
    
    self.segmentedControl.width = self.width - 2 * kPadding;
    self.segmentedControl.x = kPadding;
    self.segmentedControl.y = kTopPadding;
    
    self.calendar.y = CGRectGetMaxY(self.segmentedControl.frame);
    self.calendar.x = 0;
    self.calendar.width = self.width;
    [self.calendar reloadDate];
    self.contentView.height = CGRectGetMaxY(self.calendar.frame);
}

- (void)dealloc {
    ZXLog(@"dealloc ---> %@", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - prepare UI

- (void)prepareUI {
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.maskView];
    [self addSubview:self.contentView];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarFrameChange) name:@"HQLCalendarFrameChange" object:nil];
}

#pragma mark - event

- (void)calendarFrameChange {
//    [self setNeedsLayout]; // 重新计算frame值
    self.contentView.height = CGRectGetMaxY(self.calendar.frame);
}

// item
- (NSArray *)segmentItems {
    return @[@"日", @"周", @"月"];
}

// 数字汉字
- (NSArray *)chineseNum {
    return @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"十一", @"十二"];
}

// 获取titleSting
- (NSString *)getTitleString {
    NSString *titleString = nil;
    NSDateFormatter *formatter = [NSDateFormatter new];
    if (self.currentStyle == calendarViewSelectionStyleDay) {
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        titleString = [formatter stringFromDate:[self.dayRecord changeToNSDate]];
    } else if (self.currentStyle == calendarViewSelectionStyleWeek) {
        [formatter setDateFormat:@"yyyy年MM月"];
        titleString = [NSString stringWithFormat:@"%@ 第%@周", [formatter stringFromDate:[self.weekRecord changeToNSDate]], [self chineseNum][[self.weekRecord weekOfMonth] - 1]];
    } else if (self.currentStyle == calendarViewSelectionStyleMonth) {
        [formatter setDateFormat:@"yyyy年MM月"];
        titleString = [formatter stringFromDate:[self.monthRecord changeToNSDate]];
    }
    return titleString;
}

// segmentedControl的点击事件
- (void)segmentedControlDidclick:(UISegmentedControl *)control {
    self.currentStyle = (int)control.selectedSegmentIndex;
    [self.calendar setSelectionStyle:self.currentStyle];
    HQLDateModel *selectDate = nil;
    HQLDateModel *endDate = nil;
    if (control.selectedSegmentIndex == 0) {  // index : 0 为 日
        selectDate = self.dayRecord;
        endDate = [self setupWeekBeginDateAndEndDateWithRegion:0 isFront:NO currentDate:selectDate];
    } else if (control.selectedSegmentIndex == 1) { // 1 为 周
        selectDate = self.weekRecord;
        endDate = [self setupWeekBeginDateAndEndDateWithRegion:6 isFront:NO currentDate:selectDate];
    } else if (control.selectedSegmentIndex == 2) { // 2 为月
        selectDate = self.monthRecord;
        endDate = [self setupWeekBeginDateAndEndDateWithRegion:[selectDate numberOfDaysInCurrentMonth] - 1 isFront:NO currentDate:selectDate];
    }
    [self.calendar selectDateModel:selectDate isTriggerDelegate:NO];
    [self.calendar reloadDate];
    // delegate
    if ([self.delegate respondsToSelector:@selector(dateChooseView:didChangeSelectionStyle:beginDate:endDate:titleString:)]) {
        [self.delegate dateChooseView:self didChangeSelectionStyle:self.currentStyle beginDate:selectDate endDate:endDate titleString:[self getTitleString]];
    }
}

// 根据currentDate和区间确定日期
- (HQLDateModel *)setupWeekBeginDateAndEndDateWithRegion:(NSInteger)region isFront:(BOOL)yesOrNo currentDate:(HQLDateModel *)currentDate {
    NSInteger year = currentDate.year;
    NSInteger month = currentDate.month;
    NSInteger day = currentDate.day + (yesOrNo ? -region : region);
    
    if (yesOrNo) {
        if ((currentDate.day - region - 1) < 0) {
            month = currentDate.month - 1;
            if (month < 1) {
                year -= 1;
                month = 12;
            }
            day = [HQLDateModel numberOfDaysInMonth:month year:year] - labs((currentDate.day - region));
        }
    } else {
        if ((currentDate.day + region) > [currentDate numberOfDaysInCurrentMonth]) {
            month = currentDate.month +1;
            if (month > 12) {
                year += 1;
                month = 1;
            }
            day = labs(((currentDate.day + region) - [currentDate numberOfDaysInCurrentMonth]));
        }
    }
    
//    if (month < 1) {
//        year -= 1;
//        month = 12;
//    } else if (month > 12) {
//        year += 1;
//        month = 1;
//    }
    
    HQLDateModel *date = [[HQLDateModel alloc] initWithYear:year month:month day:day];
    if (!yesOrNo) {
        if ([date compareWithHQLDateWithOutTime:[[HQLDateModel alloc] initCurrentDate]] >= 0) {
            date = [[HQLDateModel alloc] initCurrentDate];
        }
    }
    return date;
}

// 选择上一天或下一天
- (void)selectLastOrNextDay:(BOOL)isLast {
    if (self.currentStyle != calendarViewSelectionStyleDay) return;
    HQLDateModel *date = [self setupWeekBeginDateAndEndDateWithRegion:1 isFront:isLast currentDate:self.dayRecord];
    [self.calendar selectDateModel:date isTriggerDelegate:YES];
}

// 选择上一周或下一周
- (void)selectLastOrNextWeek:(BOOL)isLast {
    if (self.currentStyle != calendarViewSelectionStyleWeek) return;
    HQLDateModel *date = [self setupWeekBeginDateAndEndDateWithRegion:isLast ? 1 : 7 isFront:isLast currentDate:self.weekRecord];
    [self.calendar selectDateModel:date isTriggerDelegate:YES];
}

// 选择上一月或下一月
- (void)selectLastOrNextMonth:(BOOL)isLast {
    if (self.currentStyle != calendarViewSelectionStyleMonth) return;
    NSInteger monthCount = [self.monthRecord numberOfDaysInCurrentMonth];
    HQLDateModel *date = [self setupWeekBeginDateAndEndDateWithRegion:isLast ? 1 : monthCount isFront:isLast currentDate:self.monthRecord];
    [self.calendar selectDateModel:date isTriggerDelegate:YES];
}

// showView
- (void)showInParentsView:(UIView *)view {
    ZXWeakSelf;
    [view addSubview:self];
    self.contentView.y = -self.contentView.height - self.viewY;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.y = 0;
        weakSelf.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if ([weakSelf.delegate respondsToSelector:@selector(dateChooseViewDidShow:)]) {
            [weakSelf.delegate dateChooseViewDidShow:weakSelf];
        }
    }];
}

// hideView
- (void)hideView {
    ZXWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.contentView.y = -weakSelf.contentView.height - weakSelf.viewY;
        weakSelf.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if ([weakSelf.delegate respondsToSelector:@selector(dateChooseViewDidHide:)]) {
            [weakSelf.delegate dateChooseViewDidHide:weakSelf];
        }
        [weakSelf removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if (touch.view == self.maskView) {
        [self hideView];
    }
}

- (void)selectDate:(HQLDateModel *)date isTriggerDelegate:(BOOL)yesOrNo {
    [self.calendar selectDateModel:date isTriggerDelegate:yesOrNo];
}

#pragma mark - calendar delegate

- (void)calendar:(HQLCalendar *)calendar calendarView:(HQLCalendarView *)calendarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end {
    // 记录最初的时间
    if (self.currentStyle == calendarViewSelectionStyleDay) {
        self.dayRecord = begin;
    } else if (self.currentStyle == calendarViewSelectionStyleWeek) {
        self.weekRecord = begin;
    } else if (self.currentStyle == calendarViewSelectionStyleMonth) {
        self.monthRecord = begin;
    }
    
    if ([self.delegate respondsToSelector:@selector(dateChooseView:didSelectBeginDate:endDate:titleString:)]) {
        [self.delegate dateChooseView:self didSelectBeginDate:begin endDate:end titleString:[self getTitleString]];
    }
}

#pragma mark - setter

- (void)setDateModel:(HQLDateModel *)dateModel {
    _dateModel = dateModel;
}

#pragma mark - getter

- (HQLDateModel *)dayRecord {
    if (!_dayRecord) {
        _dayRecord = [HQLDateModel HQLDate]; // 默认属性
    }
    return _dayRecord;
}

- (HQLDateModel *)weekRecord {
    if (!_weekRecord) {
        _weekRecord = [HQLDateModel HQLDate]; // 默认属性
        NSInteger front = [_weekRecord weekdayOfCurrentDate] - 1;
        _weekRecord = [self setupWeekBeginDateAndEndDateWithRegion:front isFront:YES currentDate:_weekRecord];
    }
    return _weekRecord; // weekRecord 永远都是当周的第一天
}

- (HQLDateModel *)monthRecord {
    if (!_monthRecord) {
        _monthRecord = [HQLDateModel HQLDate]; // 默认属性
        _monthRecord.day = 1;
    }
    return _monthRecord; // monthRecord 永远都是当月的1号
}

- (HQLCalendar *)calendar {
    if (!_calendar) {
        _calendar = [[HQLCalendar alloc] initWithFrame:CGRectMake(0, 0, ZXScreenW, ZXScreenH) dateModel:self.dateModel];
        _calendar.selectionStyle = calendarViewSelectionStyleDay;
//        _calendar.allowSelectedFutureDate = YES;
//        _calendar.allowSelectedPassedDate = NO;
        _calendar.delegate = self;
    }
    return _calendar;
}

- (UISegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:[self segmentItems]];
        _segmentedControl.frame = CGRectMake(kPadding, kTopPadding, ZXScreenW - 2 * kPadding, kSegmentedConrtolHeight - 2 * kTopPadding);
        _segmentedControl.tintColor = [UIColor orangeColor];
        [_segmentedControl addTarget:self action:@selector(segmentedControlDidclick:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
    }
    return _segmentedControl;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXScreenW, ZXScreenH)];
        _contentView.y = 0;
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView addSubview:self.segmentedControl];
        [_contentView addSubview:self.calendar];
    }
    return _contentView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXScreenW, ZXScreenH)];
        [_maskView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [_maskView setAlpha:0.0];
    }
    return _maskView;
}

@end
