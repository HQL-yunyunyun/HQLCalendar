//
//  HMPopMenuDelegate.h
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/22.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 点击cell事件回调
 */
typedef void(^TableViewDidSelectRowAtIndexPath)(NSInteger indexRow);

@interface HMPopMenuDelegate : NSObject<UITableViewDelegate>

/**
 * 对 cell 代理初始化
 */
- (instancetype) initWithDidSelectRowAtIndexPath:(TableViewDidSelectRowAtIndexPath)tableViewDidSelectRowAtIndexPath;

@end
