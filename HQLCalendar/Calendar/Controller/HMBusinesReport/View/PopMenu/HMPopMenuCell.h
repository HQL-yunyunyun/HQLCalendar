//
//  HMPopMenuCell.h
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/22.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMPopMenuCell : UITableViewCell

/**
 *  使用 alloc 创建cell
 *
 *  @param tableView 表格控件
 *
 *  @return 创建的 cell
 *
 *  内已做复用处理
 *  如果有特殊要求 可以重写此方法
 */
+ (instancetype)cellInitWithTableView:(UITableView *)tableView;

@property (copy, nonatomic) NSString *titleString;

@end
