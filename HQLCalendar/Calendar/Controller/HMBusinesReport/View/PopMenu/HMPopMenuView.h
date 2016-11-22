//
//  HMPopMenuView.h
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/22.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMPopMenuView;

@protocol HMPopMenuViewDelegate <NSObject>

@optional
- (void)popMenuViewGetHidden:(HMPopMenuView *)view;
@end

@interface HMPopMenuView : UIView

@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, copy) void(^action)(NSInteger index);
@property (nonatomic, copy) NSArray * menuItem;
@property (nonatomic, strong) UITableView * tableView;


- (instancetype) initWithFrame:(CGRect)frame
                     menuWidth:(CGFloat)menuWidth
                         items:(NSArray *)items
                        action:(void(^)(NSInteger index))action;
- (void) hideMenu;

/** 代理对象 */
@property (nonatomic, weak) id<HMPopMenuViewDelegate> delegate;

@end
