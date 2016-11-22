//
//  HQLCalenderView.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLCalendarView.h"
#import "HQLCalendarCell.h"
#import "UIView+ST.h"

#define kCalenderCellReuseID @"calenderCellReuseID" // reuseID
#define kItemWidth (self.selectionStyle==calendarViewSelectionStyleMonth?(self.collectionViewWidth/kMonthStyleRowCount):(self.collectionViewWidth/kWeekdayNum)) // collectionView item的宽度
#define kItemHeight (self.selectionStyle==calendarViewSelectionStyleMonth?(kItemWidth * 0.8):kItemWidth)  // collectionView item的高度
#define kMonthStyleRowCount 3  // monthStyle 下每行有多少个
#define kMonthNum 12

@interface HQLCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic) NSMutableArray <UILabel *>*headerLabelArray;

@property (weak, nonatomic) UIView *headerViewBottomLine;

// 数据的个数 = (该月日历的row * 7)  ---> 需要把日历前后没有数据的地方填充起来
@property (strong, nonatomic) NSMutableArray *dataSource;

// 计算出collectionView的宽度
@property (assign, nonatomic) CGFloat collectionViewWidth;

// 记录当前选中的日期
@property (strong, nonatomic) HQLDateModel *dayRecord;

// 记录当前选中的周
@property (strong, nonatomic) NSMutableArray <HQLDateModel *>* weekRecord;

// 记录当前选中的自定义区间
@property (strong, nonatomic) NSMutableArray <HQLDateModel *>* customRecord;

// 记录选中的月
@property (strong, nonatomic) HQLDateModel *monthRecord;

@end

@implementation HQLCalendarView

- (void)dealloc {
    HQLLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame dateModel:(HQLDateModel *)dateModel {
    // 高度不可控
    if (self = [super initWithFrame:frame]) {
        self.dateModel = dateModel;
        [self prepareUI];
    }
    return self;
}

- (instancetype)initMonthStyleViewWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectionStyle = calendarViewSelectionStyleMonth;
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

// 刷新
- (void)reloadData {
    [self calcuateViewFrame];
}

// 获取week的日期数组
- (NSMutableArray <NSIndexPath *>*)getWeekIndexPathWithDate:(HQLDateModel *)date isSeleted:(BOOL)selected recordArray:(NSMutableArray <HQLDateModel *>*)recordArray{
    if (date == nil) return nil;
    NSMutableArray *indexPathArray = [NSMutableArray array];
    NSInteger front = [date weekdayOfCurrentDate] - 1; // 求出星期天到当前日期的天数
    NSInteger back = 7 - [date weekdayOfCurrentDate]; // 求出当前日期到星期六的天数
    [self setupWeekIndexPath:indexPathArray recordArray:recordArray region:front isFront:YES currentIndexPath:[self getIndexOfDate:date] isSelected:selected];
    [self setupWeekIndexPath:indexPathArray recordArray:recordArray region:back isFront:NO currentIndexPath:[self getIndexOfDate:date] isSelected:selected];
    return indexPathArray;
}

// 设置week的in的Path
- (void)setupWeekIndexPath:(NSMutableArray *)indexPath recordArray:(NSMutableArray <HQLDateModel *>*)recordArray region:(NSInteger)region isFront:(BOOL)yesOrNo currentIndexPath:(NSIndexPath *)currentIndexPath isSelected:(BOOL)selected{
    HQLDateModel *lastDate = nil;
    for (int i = (yesOrNo ? 0 : 1) ; i <= region; i++) {
        NSInteger sign = yesOrNo ? -1 : 1;
        HQLDateModel *date = self.dataSource[currentIndexPath.item + (i * sign)];
        if (date.isZero == YES || ([date compareWithHQLDateWithOutTime:[[HQLDateModel alloc] initCurrentDate]] == 1 && !self.isAllowSelectedFutureDate)) break;
        date.selected = selected;
        // 要保持顺序
        if (yesOrNo) {
            [recordArray insertObject:date atIndex:0];
        } else {
            [recordArray addObject:date];
        }
        [indexPath addObject:[self getIndexOfDate:date]];
        lastDate = date;
    }
}

// 只处理一周的日期部分不在本月的情况
- (HQLDateModel *)setupWeekBeginDateAndEndDateWithRegion:(NSInteger)region isFront:(BOOL)yesOrNo currentDate:(HQLDateModel *)currentDate {
    NSInteger year = currentDate.year;
    NSInteger month = currentDate.month;
    NSInteger day = currentDate.day + (yesOrNo ? -region : region);
    
    if (yesOrNo) {
        if ((currentDate.day - region - 1) < 0) {
            month = currentDate.month - 1;
            day = [HQLDateModel numberOfDaysInMonth:month year:year] - labs((currentDate.day - region));
        }
    } else {
        if ((currentDate.day + region) > [currentDate numberOfDaysInCurrentMonth]) {
            month = currentDate.month +1;
            day = labs(((currentDate.day + region) - [currentDate numberOfDaysInCurrentMonth]));
        }
    }
    
    if (month < 1) {
        year -= 1;
        month = 12;
    } else if (month > 12) {
        year += 1;
        month = 1;
    }
    
    HQLDateModel *date = [[HQLDateModel alloc] initWithYear:year month:month day:day];
    if (yesOrNo) {
        date.hour = 0;
        date.minute = 0;
        date.second = 0;
    } else {
        // 比较,若date > currentDate,则返回currentDate
        date.hour = 23;
        date.minute = 59;
        date.second = 59;
        if ([date compareWithHQLDateWithOutTime:[[HQLDateModel alloc] initCurrentDate]] >= 0 && !self.isAllowSelectedFutureDate) {
            date = [[HQLDateModel alloc] initCurrentDate];
        }
    }
    return date;
}

- (void)calcuateViewFrame {
    // 计算headerView的frame
    self.headerView.height = self.selectionStyle == calendarViewSelectionStyleMonth ? 0 : kItemHeight;
    self.headerView.width = self.width;
    self.headerViewBottomLine.y = kItemHeight;
    self.headerViewBottomLine.width = self.width;
    // 计算label的frame
    UILabel *lastLabel = nil;
    for (UILabel *label in self.headerLabelArray) {
        label.height = kItemHeight * 0.8;
        label.width = kItemWidth;
        label.y = 0;
        label.x = CGRectGetMaxX(lastLabel.frame);
        lastLabel = label;
    }
    // 计算collectionView的frame
    self.collectionViewFlowLayout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
    [self.collectionView reloadData];
    // 计算collectionView的高度
    NSInteger row = self.selectionStyle == calendarViewSelectionStyleMonth ? self.dataSource.count / kMonthStyleRowCount : self.dataSource.count / kWeekdayNum;
    self.collectionView.y = CGRectGetMaxY(self.headerView.frame);
    self.collectionView.height = row * kItemHeight;
    self.collectionView.width = self.collectionViewWidth;
    self.collectionView.x = (self.width - self.collectionViewWidth) * 0.5;
    // 整个View的height
    self.viewHeight = CGRectGetMaxY(self.collectionView.frame);
    self.height = self.viewHeight;
}

// 获取与date相同日期的index
- (NSIndexPath *)getIndexOfDate:(HQLDateModel *)date {
    NSInteger firstRowBlankCount = [HQLDateModel weekdayOfYear:date.year month:date.month day:1] - 1;
    return [NSIndexPath indexPathForItem:(firstRowBlankCount + date.day - 1) inSection:0];
}

// 选择本月第一个星期或最后一个星期
- (void)selectedFirstOrLastWeek:(BOOL)yesOrNo isSelectFirstWeek:(BOOL)isSelectFirst {
    if (self.dataSource.count !=0 && yesOrNo && self.selectionStyle == calendarViewSelectionStyleWeek) {
        NSInteger day = isSelectFirst ? 1 : [self.dateModel numberOfDaysInCurrentMonth];
        [self selectDate:[[HQLDateModel alloc] initWithYear:self.dateModel.year month:self.dateModel.month day:day] isTriggerDelegate:NO];
    }
}

// 选择或取消选择date
- (void)selectOrDeselectDate:(HQLDateModel *)date isSelect:(BOOL)yesOrNo {
    if (date == nil) return;
    if (self.selectionStyle != calendarViewSelectionStyleCustom) {
        NSMutableArray *indexPathArray = [NSMutableArray array];
        if (self.selectionStyle == calendarViewSelectionStyleDay) {
            // 天
            NSIndexPath *indexPath = [self getIndexOfDate:date];
            [indexPathArray addObject:indexPath];
            HQLDateModel *model = self.dataSource[indexPath.item];
            model.selected = yesOrNo;
            self.dayRecord = yesOrNo ? model : nil;
        } else if (self.selectionStyle == calendarViewSelectionStyleWeek) {
            // 周
            indexPathArray = [self getWeekIndexPathWithDate:date isSeleted:yesOrNo recordArray:yesOrNo ? self.weekRecord : nil];
            if (!yesOrNo) {
                [self.weekRecord removeAllObjects];
            }
        } else if (self.selectionStyle == calendarViewSelectionStyleMonth) {
            // 月
            indexPathArray = @[[NSIndexPath indexPathForItem:date.month - 1 inSection:0]].mutableCopy;
            HQLDateModel *model = self.dataSource[date.month - 1];
            model.selected = yesOrNo;
            self.monthRecord = yesOrNo ? model : nil;
        }
        [self.collectionView reloadItemsAtIndexPaths:indexPathArray];
    } else {
        // 选择模式为自定义
    }
}

- (void)selectDate:(HQLDateModel *)date isTriggerDelegate:(BOOL)yesOrNo {
    if (yesOrNo) {
        NSIndexPath *indexPath = [self getIndexOfDate:date];
        if (self.selectionStyle == calendarViewSelectionStyleMonth) {
            indexPath = [NSIndexPath indexPathForItem:date.month - 1 inSection:0];
        }
        [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
    } else {
        [self selectOrDeselectDate:date isSelect:YES];
    }
}

- (void)deselectDate:(HQLDateModel *)date {
    [self selectOrDeselectDate:date isSelect:NO];
}

#pragma mark - collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HQLDateModel *model = self.dataSource[indexPath.item];
    if (model.isZero == YES || model.isAllowSelectedFutureDate == NO) return;
    
    if (self.selectionStyle != calendarViewSelectionStyleCustom) {
        // 不是自定义区间
        BOOL isDeselect = NO;
        HQLDateModel *deselectDate = nil; // 需要取消选择的日期
        NSInteger front = 0; // 前区间
        NSInteger back = 0; // 后区间
        
        if (self.selectionStyle == calendarViewSelectionStyleDay) {
            if (self.dayRecord != model) {
                deselectDate = self.dayRecord;
                isDeselect = YES;
            }
            // 设置区间
            front = 0;
            back = 0;
        } else if (self.selectionStyle == calendarViewSelectionStyleWeek) {
            // 判断选择的是否是当前选择的周
            BOOL isCurrentWeek = NO;
            for (HQLDateModel *date in self.weekRecord) {
                if (date == model) {
                    isCurrentWeek = YES;
                }
            }
            if (isCurrentWeek == NO) {
                deselectDate = self.weekRecord.firstObject;
                isDeselect = YES;
            }
            
            // 其他时间 --- 默认的做法
            front = [model weekdayOfCurrentDate] - 1; // 求出星期天到当前日期的天数
            back = 7 - [model weekdayOfCurrentDate]; // 求出当前日期到星期六的天数
        } else if (self.selectionStyle == calendarViewSelectionStyleMonth) {
            // 选择月
            if (self.monthRecord != model) {
                deselectDate = self.monthRecord;
                isDeselect = YES;
            }
            
            NSInteger mid = [model numberOfDaysInCurrentMonth] / 2;
            front = mid - 1;
            back = [model numberOfDaysInCurrentMonth] - mid;
            
        }
        
        if (isDeselect) {
            [self deselectDate:deselectDate];
            [self selectDate:model isTriggerDelegate:NO];
        }
        HQLDateModel *begin = [self setupWeekBeginDateAndEndDateWithRegion:front isFront:YES currentDate:model];
        HQLDateModel *end = [self setupWeekBeginDateAndEndDateWithRegion:back isFront:NO currentDate:model];
        if ([self.delegate respondsToSelector:@selector(calendarView:selectionStyle:beginDate:endDate:)]) {
            [self.delegate calendarView:self selectionStyle:self.selectionStyle beginDate:begin endDate:end];
        }
        
    } else {
        // 自定义区间
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
    HQLCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalenderCellReuseID forIndexPath:indexPath];
    cell.HQL_SelectionStyle = self.selectionStyle;
//    cell.showDescString = YES;
    cell.dateModel = self.dataSource[indexPath.item];
    return cell;
}

#pragma mark - setter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
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
    if (self.selectionStyle != calendarViewSelectionStyleMonth) {
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
    } else {
        // 月的dataSource
        for (int i = 0; i < kMonthNum; i++ ) {
            NSInteger day = [HQLDateModel numberOfDaysInMonth:i+1 year:dateModel.year] / 2;
            [self.dataSource addObject:[[HQLDateModel alloc] initWithYear:dateModel.year month:i + 1 day:day]];
        }
    }
    [self setAllowSelectedFutureDate:self.isAllowSelectedFutureDate]; // 是否允许选择未来日期
    [self setSelectedLastWeek:self.selectedLastWeek]; // 选择最后一个星期
    [self setSelectedFirstWeek:self.selectedFirstWeek]; // 选择第一个星期
}

- (void)setAllowSelectedFutureDate:(BOOL)allowSelectedFutureDate {
    _allowSelectedFutureDate = allowSelectedFutureDate;
    
    if (self.dataSource.count != 0) {
        HQLDateModel *today = [[HQLDateModel alloc] initCurrentDate];
        for (HQLDateModel *date in self.dataSource) {
            date.allowSelectedFutureDate = allowSelectedFutureDate ? YES : [today compareWithHQLDateWithOutTime:date] > -1;
        }
    }
}

- (void)setSelectedLastWeek:(BOOL)selectedLastWeek {
    _selectedLastWeek = selectedLastWeek;
    if (self.selectionStyle == calendarViewSelectionStyleMonth) return;
    if (selectedLastWeek) {
        self.selectedFirstWeek = NO;
    }
    [self selectedFirstOrLastWeek:selectedLastWeek isSelectFirstWeek:NO];
}

- (void)setSelectedFirstWeek:(BOOL)selectedFirstWeek {
    _selectedFirstWeek = selectedFirstWeek;
    if (self.selectionStyle == calendarViewSelectionStyleMonth) return;
    if (selectedFirstWeek) {
        self.selectedLastWeek = NO;
    }
    [self selectedFirstOrLastWeek:selectedFirstWeek isSelectFirstWeek:YES];
}

- (void)setSelectionStyle:(HQLCalendarViewSelectionStyle)selectionStyle {
    _selectionStyle = selectionStyle;
    
    if (selectionStyle == calendarViewSelectionStyleMonth) {
        // 重新设置当前dataSource
        [self.headerView setHidden:YES];
        HQLDateModel *today = self.dateModel == nil ? [HQLDateModel HQLDate] : self.dateModel;
        [self setDateModel:today];
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
        [_collectionView registerClass:[HQLCalendarCell class] forCellWithReuseIdentifier:kCalenderCellReuseID];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(kItemWidth, kItemHeight); // item 为正方形
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

- (NSMutableArray<HQLDateModel *> *)weekRecord {
    if (!_weekRecord) {
        _weekRecord = [NSMutableArray array];
    }
    return _weekRecord;
}

- (NSMutableArray<HQLDateModel *> *)customRecord {
    if (!_customRecord) {
        _customRecord = [NSMutableArray array];
    }
    return _customRecord;
}

@end
