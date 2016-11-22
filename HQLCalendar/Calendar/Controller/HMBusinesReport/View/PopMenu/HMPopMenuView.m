//
//  HMPopMenuView.m
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/22.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import "HMPopMenuView.h"
#import "HMPopMenuCell.h"
#import "HMPopMenuDelegate.h"
#import "HMPopMenuDataSource.h"
#import "HMPopMenu.h"

#define WBNUMBER 5

@interface HMPopMenuView ()
@property (nonatomic, strong) HMPopMenuDataSource * tableViewDataSource;
@property (nonatomic, strong) HMPopMenuDelegate   * tableViewDelegate;
@end

@implementation HMPopMenuView

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
                     menuWidth:(CGFloat)menuWidth
                         items:(NSArray *)items
                        action:(void(^)(NSInteger index))action {
    if (self = [super initWithFrame:frame]) {
        self.menuWidth = menuWidth;
        self.menuItem = items;
        self.action = [action copy];
        
        self.tableViewDataSource = [[HMPopMenuDataSource alloc]initWithItems:items cellClass:[HMPopMenuCell class] configureCellBlock:^(HMPopMenuCell *cell, HMPopMenu *model) {
            HMPopMenuCell * tableViewCell = (HMPopMenuCell *)cell;
            tableViewCell.titleString = model.title;
//            tableViewCell.textLabel.text = model.title;
            //tableViewCell.imageView.image = [UIImage imageNamed:model.image];
        }];
        self.tableViewDelegate = [[HMPopMenuDelegate alloc] initWithDidSelectRowAtIndexPath:^(NSInteger indexRow) {
            if (self.action) {
                [self hideMenu];
                self.action(indexRow);
            }
        }];
        
        
        self.tableView = [[UITableView alloc] initWithFrame:[self menuFrame] style:UITableViewStylePlain];
        self.tableView.dataSource = self.tableViewDataSource;
        self.tableView.delegate   = self.tableViewDelegate;
        self.tableView.layer.cornerRadius = 10.0f;
        self.tableView.layer.anchorPoint = CGPointMake(0.5, 0);
        self.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.tableView.rowHeight = 44;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.tableView];
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [window addSubview:self];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        
    }
    return self;
}

- (CGRect)menuFrame {
    CGFloat num = self.menuItem.count > WBNUMBER ? WBNUMBER : self.menuItem.count;
    CGFloat menuX = [UIScreen mainScreen].bounds.size.width / 2 - self.menuWidth / 2;
    CGFloat menuY = 74 - 22 * num;
    CGFloat width = self.menuWidth;
    CGFloat heigh = 44 * num;
    return (CGRect){menuX,menuY,width,heigh};
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect {
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    CGFloat location = ZXScreenW / 2;
    CGContextMoveToPoint(context,
                         location -  10, 74);//设置起点
    
    CGContextAddLineToPoint(context,
                            location,  64);
    
    CGContextAddLineToPoint(context,
                            location + 10, 74);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor whiteColor] setFill];  //设置填充色
    
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
}

- (void) hideMenu {
    // 通知代理（调用代理的方法）
    // respondsToSelector:能判断某个对象是否实现了某个方法
    if ([self.delegate respondsToSelector:@selector(popMenuViewGetHidden:)]) {
        [self.delegate popMenuViewGetHidden:self];
    }
    
    [UIView animateWithDuration:0.15 animations:^{
        self.tableView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        [self removeFromSuperview];
        self.tableView = nil;
        //self = nil;
    }];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hideMenu];
}

@end
