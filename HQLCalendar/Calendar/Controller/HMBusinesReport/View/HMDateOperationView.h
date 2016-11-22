//
//  HMDateOperationView.h
//  HuanMoney
//
//  Created by weplus on 2016/11/21.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMDateOperationView, HQLDateModel;

@protocol HMDateOperationViewDelegate <NSObject>

@optional
- (void)dateOperationView:(HMDateOperationView *)operationView didSelectBeginDate:(HQLDateModel *)begin endDate:(HQLDateModel *)end;

@end

@interface HMDateOperationView : UIView

@property (assign, nonatomic) id <HMDateOperationViewDelegate>delegate;

- (void)selectDate:(HQLDateModel *)date isTriggerDelegate:(BOOL)yesOrNo;

@end
