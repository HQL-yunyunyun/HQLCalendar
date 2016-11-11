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

#define kWeekdayNum 7 // 一周七天 / 从星期天开始
#define kCalenderCellReuseID @"calenderCellReuseID" // reuseID
#define kItemWidth (self.collectionViewWidth / kWeekdayNum) // collectionView item的宽度
#define kItemHeight (kItemWidth * 0.8) // collectionView item的高度

#define HQLColorWithAlpha(r,g,b,a) [UIColor colorWithRed:( r / 255.0)  green:( g / 255.0) blue:( b / 255.0) alpha:a]
#define HQLColor(r,g,b) HQLColorWithAlpha(r,g,b,1)

@interface HQLCalenderView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) NSMutableArray <UILabel *>*headerLabelArray;

@property (weak, nonatomic) UIView *headerViewBottomLine;

// 数据的个数 = (该月日历的row * 7)  ---> 需要把日历前后没有数据的地方填充起来
@property (strong, nonatomic) NSMutableArray *dataSource;

// 计算出collectionView的宽度
@property (assign, nonatomic) CGFloat collectionViewWidth;

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
    [self calcuateViewFrame];
}

#pragma mark - prepare UI

- (void)prepareUI {
    [self setBackgroundColor:[UIColor whiteColor]];
}

#pragma mark - event

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击");
    HQLDateModel *model = self.dataSource[indexPath.item];
    if (self.selectionStyle == calenderViewSelectionStyleDay) {
        model.selected = !model.isSelected;
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } else if (self.selectionStyle == calenderViewSelectionStyleWeek) {
    
    } else if (self.selectionStyle == calenderViewSelectionStyleCustom) {
    
    }
}

#pragma mark - collection view dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HQLCalenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalenderCellReuseID forIndexPath:indexPath];
    cell.HQL_SelectionStyle = self.selectionStyle;
    cell.dateModel = self.dataSource[indexPath.item];
    return cell;
}

- (void)calcuateViewFrame {
    // 计算headerView的frame
    self.headerView.height = kItemHeight;
    self.headerView.width = self.width;
    self.headerViewBottomLine.y = kItemHeight;
    self.headerViewBottomLine.width = self.width;
    // 计算label的frame
    UILabel *lastLabel = nil;
    for (UILabel *label in self.headerLabelArray) {
        label.height = kItemHeight;
        label.width = kItemWidth;
        label.y = 0;
        label.x = CGRectGetMaxX(lastLabel.frame);
        lastLabel = label;
    }
    // 计算collectionView的frame
    self.collectionViewFlowLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    [self.collectionView reloadData];
    // 计算collectionView的高度
    NSInteger row = self.dataSource.count / 7;
    self.collectionView.y = CGRectGetMaxY(self.headerView.frame);
    self.collectionView.height = row * kItemWidth;
    self.collectionView.width = self.collectionViewWidth;
    self.collectionView.x = (self.width - self.collectionViewWidth) * 0.5;
    // 整个View的height
    self.viewHeight = CGRectGetMaxY(self.collectionView.frame);
    self.height = self.viewHeight;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
//    [self calcuateCollectionFrame];
    NSInteger itemWidth = frame.size.width / kWeekdayNum;
    self.collectionViewWidth = itemWidth * kWeekdayNum;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    [self.collectionView setBackgroundColor:backgroundColor];
    [self.headerView setBackgroundColor:backgroundColor];
}

- (void)setDateModel:(HQLDateModel *)dateModel {
    if (dateModel == nil) return;
    _dateModel = dateModel;
    [self.dataSource removeAllObjects];
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
}

#pragma mark - getter

- (NSArray *)weekdayArray {
    return @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
}

- (UIView *)headerView {
    if (!_headerView) {
        // 创建
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kItemHeight)];
        [self addSubview:_headerView];
        // label
        for (NSString *title in [self weekdayArray]) {
            UILabel *label = [[UILabel alloc] init];
            UIColor *titleColor = HQLColor(51, 51, 51);
            if ([title isEqualToString:@"日"] || [title isEqualToString:@"六"]) {
                titleColor = [UIColor orangeColor];
            }
            [label setTextColor:titleColor];
            [label setFont:[UIFont systemFontOfSize:14]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setText:title];
            [label sizeToFit];
            [_headerView addSubview:label];
            [self.headerLabelArray addObject:label];
        }
        // lineView
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kItemHeight, self.width, 0.5)];
        [lineView setBackgroundColor:HQLColor(220, 218, 220)];
        [_headerView addSubview:lineView];
        self.headerViewBottomLine = lineView;
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
//        [_collectionView setBackgroundColor:[UIColor blueColor]];
        [_collectionView registerClass:[HQLCalenderCell class] forCellWithReuseIdentifier:kCalenderCellReuseID];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(kItemWidth, kItemWidth); // item 为正方形
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
    } else if (month != 2) {
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
