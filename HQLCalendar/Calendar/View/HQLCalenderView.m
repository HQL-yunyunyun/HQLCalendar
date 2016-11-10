//
//  HQLCalenderView.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLCalenderView.h"
#import "HQLCalenderCell.h"
#import "UIView+ST.h"

#define kWeekdayNum 7
#define kCalenderCellReuseID @"calenderCellReuseID"

@interface HQLCalenderView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) NSMutableArray <UILabel *>*headerLabelArray;

// 数据的个数 = (该月日历的row * 7)  ---> 需要把日历前后没有数据的地方填充起来
@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation HQLCalenderView

- (void)dealloc {
    NSLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel {
    // 高度不可控
    if (self = [super initWithFrame:frame]) {
        self.dateModel = dateModel;
        [self prepareUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self calcuateCollectionFrame];
}

#pragma mark - prepare UI

- (void)prepareUI {
    [self setBackgroundColor:[UIColor blueColor]];
}

#pragma mark - event

#pragma mark - collection view delegate

#pragma mark - collection view dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HQLCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalenderCellReuseID forIndexPath:indexPath];
    cell.dateModel = self.dataSource[indexPath.item];
    return cell;
}

- (void)calcuateCollectionFrame {
    CGFloat itemHeight = self.frame.size.width / kWeekdayNum;
    self.collectionViewFlowLayout.itemSize = CGSizeMake(itemHeight, itemHeight);
    [self.collectionView reloadData];
    // 计算collectionView的高度
    NSInteger row = self.dataSource.count / 7;
    self.collectionView.height = row * itemHeight;
    self.collectionView.width = self.width;
    self.viewHeight = CGRectGetMaxY(self.collectionView.frame);
    self.height = self.viewHeight;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
//    [self calcuateCollectionFrame];
}

- (void)setDateModel:(HQLDateModel *)dateModel {
    if (dateModel == nil) return;
    _dateModel = dateModel;
    
    // 设置dataSource
    NSInteger firstWeekday = [HQLDateModel weekdayOfYear:dateModel.year month:dateModel.month day:1];
    NSInteger num = [dateModel numberOfDaysInCurrentMonth];
    NSInteger count = [dateModel rowOfCalenderInCurrentMonth] * kWeekdayNum;
    NSInteger firstRowBlankCount = firstWeekday - 1; // 第一行需要填充的个数
    for (int i = 0; i < count; i++) {
        if (i >= firstRowBlankCount && i < num + firstRowBlankCount) {
            // 真正的数据
            [self.dataSource addObject:[[HQLDateModel alloc] initWithYear:dateModel.year month:dateModel.month day:i - firstRowBlankCount + 1]];
        } else {
            // 填充的空白
            [self.dataSource addObject:[[HQLDateModel alloc] initWithZero]];
        }
    }
    [self calcuateCollectionFrame];
}

#pragma mark - getter

- (NSArray *)weekdayArray {
    return @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
}

- (UIView *)headerView {
    if (!_headerView) {
        // 创建
    }
    return _headerView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setBackgroundColor:[UIColor redColor]];
        [_collectionView registerClass:[HQLCalenderCell class] forCellWithReuseIdentifier:kCalenderCellReuseID];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        CGFloat itemW = self.frame.size.width / kWeekdayNum;
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionViewFlowLayout = flowLayout;
    }
    return _collectionViewFlowLayout;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray<UILabel *> *)headerLabelArray {
    if (!_headerLabelArray) {
        _headerLabelArray = [NSMutableArray arrayWithCapacity:kWeekdayNum];
    }
    return _headerLabelArray;
}

@end

#pragma mark - date model

@implementation HQLDateModel

#pragma mark - instance method

- (instancetype)initWithZero {
    if (self = [super init]) {
        self.zero = YES;
    }
    return self;
}

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    if (self = [super init]) {
        if (![self checkDataWithYear:year month:month day:day hour:hour minute:minute second:second]) {
            return nil;
        }
        self.year = year;
        self.month = month;
        self.day = day;
        self.hour = hour;
        self.minute = minute;
        self.second = second;
        self.zero = NO;
    }
    return self;
}

- (instancetype)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [self initWithYear:year month:month day:day hour:0 minute:0 second:0];
}

- (instancetype)initwithNSDate:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger year = [cal component:NSCalendarUnitYear fromDate:date];
    NSInteger month = [cal component:NSCalendarUnitMonth fromDate:date];
    NSInteger day = [cal component:NSCalendarUnitDay fromDate:date];
    NSInteger hour = [cal component:NSCalendarUnitHour fromDate:date];
    NSInteger minute = [cal component:NSCalendarUnitMinute fromDate:date];
    NSInteger second = [cal component:NSCalendarUnitSecond fromDate:date];
    return [self initWithYear:year month:month day:day hour:hour minute:minute second:second];
}

- (instancetype)initWithHQLDate:(HQLDateModel *)date {
    return [self initWithYear:date.year month:date.month day:date.day hour:date.hour minute:date.minute second:date.second];
}

- (NSString *)description {
    return  [NSString stringWithFormat:@"year : %ld, month : %ld, day : %ld, hour : %ld, minute : %ld, second : %ld",(long)self.year, (long)self.month, (long)self.day, (long)self.hour, (long)self.minute, (long)self.second];
}

#pragma mark - event

- (NSDate *)changeToNSDate {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:self.year];
    [comp setMonth:self.month];
    [comp setDay:self.day];
    [comp setHour:self.hour];
    [comp setMinute:self.minute];
    [comp setSecond:self.second];
    return [cal dateFromComponents:comp];
}

- (BOOL)checkDataWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    // 判断日期是否正确
    NSInteger maxDays = 0;
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        // 闰年
        maxDays = 29;
    } else {
        // 平年
        maxDays = 28;
    }
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
        maxDays = 31;
    } else {
        maxDays = 30;
    }
    if (day > maxDays) {
        return NO;
    }
    if (month < 1 || month > 12 || hour < 0 || hour > 24 || day < 1 || day > 31 || minute < 0 || minute > 60 || second < 0 || second > 60) {
        return NO;
    }
    return YES;
}

- (NSInteger)numberOfDaysInCurrentMonth {
    NSDate *date = [self changeToNSDate];
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
}

- (NSInteger)rowOfCalenderInCurrentMonth {
    NSInteger number = [self numberOfDaysInCurrentMonth]; // 该月的天数
    NSInteger weekday = [self weekdayOfCurrentDate]; // 1号是星期几
    NSInteger firstRowNumber = kWeekdayNum - weekday + 1; // 日历第一行填充数据的个数
    NSInteger remainder = (number - firstRowNumber) % kWeekdayNum; // 最后一行剩余的个数
    // 行数 = 1(第一行) + ((每月个数 - 第一行填充的个数) / 7) +
    return (1 + ((number - firstRowNumber) / kWeekdayNum) + (remainder == 0 ? 0 : 1));
}

- (NSInteger)weekdayOfCurrentDate {
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [self changeToNSDate];
    return [calender component:NSCalendarUnitWeekday fromDate:date];
}

#pragma mark class method

+ (NSInteger)rowOfCalenderInMonth:(NSInteger)month year:(NSInteger)year {
    HQLDateModel *date = [[HQLDateModel alloc] initWithYear:year month:month day:1];
    return [date rowOfCalenderInCurrentMonth];
}

+ (NSUInteger)numberOfDaysInMonth:(NSInteger)month year:(NSInteger)year {
    if (month > 12 || month < 1) return 0;
    HQLDateModel *date = [[HQLDateModel alloc] initWithYear:year month:month day:1];
    return [date numberOfDaysInCurrentMonth];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calender dateFromComponents:comps];
}

+ (NSInteger)weekdayOfYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [[[HQLDateModel alloc] initWithYear:year month:month day:day] weekdayOfCurrentDate];
}

#pragma mark - setter

- (void)setMonth:(NSInteger)month {
    if (month < 1 || month > 12) {
        return;
    }
    _month = month;
}

- (void)setHour:(NSInteger)hour {
    if (hour < 0 || hour > 24) {
        return;
    }
    _hour = hour;
}

- (void)setDay:(NSInteger)day {
    if (day < 1 || day > 31) {
        return;
    }
    _day = day;
}

- (void)setMinute:(NSInteger)minute {
    if (minute < 0 || minute > 60) {
        return;
    }
    _minute = minute;
}

- (void)setSecond:(NSInteger)second {
    if (second < 0 || second > 60) {
        return;
    }
    _second = second;
}

/* - (NSMutableArray<NSMutableArray *> *)dataSourceOfCurrentMonth {
 NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:kWeekdayNum];
 for (int i = 0; i < kWeekdayNum; i++) {
 [dataSource addObject:[NSMutableArray array]];
 }
 // 1号开始
 HQLDateMode *first = [[HQLDateMode alloc] initWithHQLDate:self];
 first.day = 1;
 NSInteger number = [first numberOfDaysInCurrentMonth];
 NSInteger lastWeekday = [first weekdayOfCurrentDate];
 [dataSource[lastWeekday - 1] addObject:first];
 for (int i = 2 ; i <= number; i++) {
 HQLDateMode *date = [[HQLDateMode alloc] initWithHQLDate:first];
 date.day = i;
 NSInteger weekday = lastWeekday == 7 ? 1 : (lastWeekday + 1);
 [dataSource[weekday - 1] addObject:date];
 lastWeekday = weekday;
 }
 return dataSource;
 }

+ (NSMutableArray<NSMutableArray *> *)dataSourceOfYear:(NSInteger)year month:(NSInteger)month {
    HQLDateMode *date = [[HQLDateMode alloc] initWithYear:year month:month day:1];
    return [date dataSourceOfCurrentMonth];
}*/

@end
