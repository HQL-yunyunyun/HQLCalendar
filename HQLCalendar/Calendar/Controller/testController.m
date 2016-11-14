//
//  testController.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/9.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "testController.h"
#import "HQLCalendarView.h"

#define kWeekdayNum 7

@interface testController () <HQLCalendarViewDelegate>

@property (strong, nonatomic) NSMutableArray <NSMutableArray *>*dataSource;

@end

@implementation testController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    HQLCalendarView *view = [[HQLCalendarView alloc] initWithFrame:self.view.bounds dateModel:[[HQLDateModel alloc] initWithYear:2017 month:2 day:28]];
    view.selectionStyle = calendarViewSelectionStyleDay;
    CGRect viewf = view.frame;
    viewf.origin.y = 100;
    view.frame = viewf;
    view.delegate = self;
//    view.dateModel = [[HQLDateModel alloc] initWithYear:2016 month:1 day:1];
    [self.view addSubview:view];
}

- (void)calendarView:(HQLCalendarView *)caledarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end {
    NSLog(@"begin ---: %@ \n end ---: %@ \n", begin, end);
}

- (NSInteger)rowOfMonth:(NSInteger)month year:(NSInteger)year {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [self dateWithYear:year month:month day:1]; // 每月一号
    NSInteger number = [self numberOfDaysInMonth:month year:year]; // 该月的天数
    NSInteger weekday = [calendar component:NSCalendarUnitWeekday fromDate:date]; // 1号是星期几
    NSInteger firstRowNumber = kWeekdayNum - weekday + 1; // 日历第一行填充数据的个数
    NSInteger remainder = (number - firstRowNumber) % kWeekdayNum; // 最后一行剩余的个数
    // 行数 = 1(第一行) + ((每月个数 - 第一行填充的个数) / 7) + 
    return (1 + ((number - firstRowNumber) / kWeekdayNum) + (remainder == 0 ? 0 : 1));
}

- (NSUInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year {
    if (month > 12 || month < 1) return 0;
    NSDate *date = [self dateWithYear:year month:month day:1];
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

- (NSUInteger)numberOfDaysInCurrentMonth
{
    // 频繁调用 [NSCalendar currentCalendar] 可能存在性能问题
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger year1 = [calender component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger month1 = [calender component:NSCalendarUnitMonth fromDate:[NSDate date]];
    return [self numberOfDaysInMonth:month1 year:year1];
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateFromComponents:comps];
}

- (NSMutableArray<NSMutableArray *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithCapacity:kWeekdayNum];
        for (int i = 0 ; i < kWeekdayNum; i++) {
            [_dataSource addObject:[NSMutableArray array]];
        }
    }
    return _dataSource;
}

@end
