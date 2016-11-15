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

#define kTitleViewHeight 50

@interface HQLCalendar ()

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
    
    self.titleView.width = self.width;
    self.line.width = self.width;
    
    self.lastButton.y = (self.titleView.height - self.lastButton.height) * 0.5;
    self.lastButton.x = 5;
    
    self.nextButton.y = (self.titleView.height - self.nextButton.height) * 0.5;
    self.nextButton.x = self.titleView.width - self.nextButton.width - 5;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.width = self.width - self.nextButton.width - self.lastButton.width - 2 * 5;
    self.titleLabel.y = (self.titleView.height - self.titleLabel.height) * 0.5;
    self.titleLabel.x = CGRectGetMaxX(self.lastButton.frame);
}

#pragma mark - prepare UI 

- (void)prepareUI {
    [self titleView];
}

#pragma mark - event 

- (void)lastButtonDidClick:(UIButton *)lastButton {

}

- (void)nextButtonDidClick:(UIButton *)nextButton {

}

#pragma mark - getter

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, kTitleViewHeight)];
        [_titleView setBackgroundColor:[UIColor whiteColor]];
        
        // bottomLine
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [line setBackgroundColor:HQLColor(220, 218, 220)];
        [_titleView addSubview:line];
        self.line = line;
        
        [_titleView addSubview:self.lastButton];
        [_titleView addSubview:self.nextButton];
    }
    return _titleView;
}

- (UIButton *)lastButton {
    if (!_lastButton) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastButton setTitle:@"last" forState:UIControlStateNormal];
        [_lastButton sizeToFit];
        [_lastButton addTarget:self action:@selector(lastButtonDidClick:)];
    }
    return _lastButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"next" forState:UIControlStateNormal];
        [_nextButton sizeToFit];
        [_nextButton addTarget:self action:@selector(nextButtonDidClick:)];
    }
    return _nextButton;
}

#pragma mark - setter

- (void)setCurrentDate:(HQLDateModel *)currentDate {
    currentDate.day = 1;
    _currentDate = currentDate;
}

@end
