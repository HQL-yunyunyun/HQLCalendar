//
//  HMPopMenuDataSource.h
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/22.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HMPopMenu, HMPopMenuCell;

/**
 * 由model 设置cell 的回调
 */
typedef void(^TableViewCellConfigureBlock) (HMPopMenuCell * cell, HMPopMenu * model);

@interface HMPopMenuDataSource : NSObject<UITableViewDataSource>

/**
 *  创建数据源管理
 *
 *  @param anItems             数据源
 *  @param cellClass           cell 类
 *  @param aConfigureCellBlock 设置cell的回调
 */
- (instancetype) initWithItems:(NSArray *)anItems
                     cellClass:(Class)cellClass
            configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock;

@end
