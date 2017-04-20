//
//  testController.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/9.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "testController.h"
#import "HQLCalendarView.h"
#import "HQLCalendar.h"

#define kWeekdayNum 7



@interface testController () <HQLCalendarViewDelegate, HQLCalendarDelegate>

@property (strong, nonatomic) NSMutableArray <NSMutableArray *>*dataSource;

@end

@implementation testController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat beginTime = [[NSDate date] timeIntervalSince1970] * 1000;
    HQLCalendarView *view = [[HQLCalendarView alloc] initWithFrame:self.view.bounds dateModel:[[HQLDateModel alloc] initWithYear:2016 month:11 day:1]];
    CGRect viewf = view.frame;
    viewf.origin.y = 100;
    view.frame = viewf;
    view.delegate = self;
    [self.view addSubview:view];
    if (self.mode == 1) {
        view.selectionStyle = calendarViewSelectionStyleMonth;
        view.allowSelectedFutureDate = NO;
        view.selectedFirstWeek = YES;
    } else if (self.mode == 2) {
        view.selectionStyle = calendarViewSelectionStyleWeek;
        view.allowSelectedFutureDate = YES;
//        view.selectedLastWeek = YES;
    } else if (self.mode == 3) {
        view.selectionStyle = calendarViewSelectionStyleDay;
        view.allowSelectedFutureDate = NO;
    } else if (self.mode == 4) {
        view.selectionStyle = calendarViewSelectionStyleDay;
        view.allowSelectedFutureDate = YES;
    } else if (self.mode == 5) {
        [view setHidden:YES];
        
        HQLCalendar *calendar = [[HQLCalendar alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 200) dateModel:[[HQLDateModel alloc] initWithYear:2017 month:11 day:1]];
        calendar.selectionStyle = calendarViewSelectionStyleMonth;
        calendar.delegate = self;
        //        calendar.allowSelectedFutureDate = YES;
        [self.view addSubview:calendar];
    }
    CGFloat endTime = [[NSDate date] timeIntervalSince1970] * 1000;
    HQLLog(@"%f", endTime - beginTime);
}

- (void)calendar:(HQLCalendar *)calendar calendarView:(HQLCalendarView *)calendarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end {
    HQLLog(@"------------------------------");
    HQLLog(@"begin ---: %@ \n ------------------------ \n end ---: %@ \n", begin, end);
    HQLLog(@"------------------------------");
}

- (void)calendarView:(HQLCalendarView *)caledarView selectionStyle:(HQLCalendarViewSelectionStyle)style beginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end {
    HQLLog(@"begin ---: %@ \n end ---: %@ \n", begin, end);
}

@end
