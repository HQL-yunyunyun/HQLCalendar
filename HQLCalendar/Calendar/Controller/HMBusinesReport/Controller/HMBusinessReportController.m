//
//  HMBusinessReportController.m
//  HuanMoney
//
//  Created by weplus on 2016/11/19.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import "HMBusinessReportController.h"
#import "HMTitleButton.h"
#import "HMPopMenu.h"
#import "HMPopMenuView.h"
#import "HMDateOperationView.h"
#import "HQLDateModel.h"

typedef enum {
    businessVolumeReport = 0,     // 营业额统计   数字对应着数组中的位置
    saleOfGoodsReport ,               // 销售商品统计
    memberReport ,                       // 会员统计
    cashierReport                           // 收银员收款统计
} reportType;

@interface HMBusinessReportController () <HMPopMenuViewDelegate, HMDateOperationViewDelegate>

@property (strong, nonatomic) HMTitleButton *titleButton;

@property (strong, nonatomic) HMPopMenuView *popMenuView;

@property (strong, nonatomic) UIButton *toggleButton; // 切换统计图

@property (strong, nonatomic) UIButton *shareButton; // 分享

@property (strong, nonatomic) HMDateOperationView *operationView;

@end

@implementation HMBusinessReportController

- (void)dealloc {
    ZXLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.operationView selectDate:[HQLDateModel HQLDate] isTriggerDelegate:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareUI];
}

#pragma mark - prepare UI

- (void)prepareUI {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    // 设置titleView
    UIView *titleView = [[UIView alloc] initWithFrame:self.titleButton.frame];
    titleView.backgroundColor = [UIColor clearColor];
    [titleView addSubview:self.titleButton];
    self.navigationItem.titleView = titleView;
    
    // 两个按钮
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:self.shareButton],
                                                                           [[UIBarButtonItem alloc] initWithCustomView:self.toggleButton]];
    [self.view addSubview:self.operationView];
}

#pragma mark - event

- (NSArray *)menuTitle {
    return @[
                @"营业额统计",
                @"销售商品统计",
                @"会员统计",
                @"收银员收款统计"
             ];
}

// titleButton click
- (void)titleClicked {
    ZXWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.titleButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }];
    
    // 设置popView的数据源
    NSMutableArray *obj = [NSMutableArray array];
    for (NSInteger i = 0; i < [self menuTitle].count; i++) {
        HMPopMenu * info = [HMPopMenu new];
        info.title = [self menuTitle][i];
        [obj addObject:info];
    }
    self.popMenuView = [[HMPopMenuView alloc] initWithFrame:self.view.bounds menuWidth:ZXScreenW / 2 + 20 items:obj action:^(NSInteger index) {
        [weakSelf.titleButton setTitle:[weakSelf menuTitle][index] forState:UIControlStateNormal];
        // 根据标题,请求不同的数据
        ZXLog(@"%ld", (long)index);
    }];
    self.popMenuView.delegate = self;
}

// 切换统计图
- (void)toggleButtonDidClick:(UIButton *)button {
    ZXLog(@"切换");
}

- (void)shareButtonDidClick:(UIButton *)button {
    ZXLog(@"share");
    
}

#pragma mark - date operation view delegate

- (void)dateOperationView:(HMDateOperationView *)operationView didSelectBeginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end {
    ZXLog(@"begin : %@ \n end : %@", begin, end);
}

#pragma mark - HMPopMenuViewDelegate

- (void)popMenuViewGetHidden:(HMPopMenuView *)view {
    ZXWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.titleButton.imageView.transform = CGAffineTransformMakeRotation(0);
    }];
}

#pragma mark - getter

- (HMDateOperationView *)operationView {
    if (!_operationView) {
        _operationView = [[HMDateOperationView alloc] initWithFrame:CGRectMake(0, 64, ZXScreenW, 50)];
        _operationView.delegate = self;
    }
    return _operationView;
}

- (HMTitleButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [[HMTitleButton alloc] initWithFrame:CGRectMake(0, 0, ZXScreenW / 2, 44)];
        [_titleButton setTitle:[self menuTitle].firstObject forState:UIControlStateNormal];
        [_titleButton setImage:[UIImage imageNamed:@"icon-rotation_button"] forState:UIControlStateNormal];
        _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleButton.titleLabel.numberOfLines = 0;
        [_titleButton setTitleColor:ZXColor(51, 51, 51) forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(titleClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleButton;
}

- (UIButton *)toggleButton {
    if (!_toggleButton) {
        _toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toggleButton setImage:[UIImage imageNamed:@"nav_lineChart"] forState:UIControlStateNormal];
        [_toggleButton setImage:[UIImage imageNamed:@"nav_barChart"] forState:UIControlStateSelected];
        [_toggleButton setTitle:@"lineChart" forState:UIControlStateNormal];
        [_toggleButton setTitle:@"barChart" forState:UIControlStateSelected];
        [_toggleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _toggleButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_toggleButton sizeToFit];
        [_toggleButton addTarget:self action:@selector(toggleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_shareButton setTitle:@"share" forState:UIControlStateNormal];
        [_shareButton sizeToFit];
        [_shareButton addTarget:self action:@selector(shareButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

#pragma mark - setter

@end
