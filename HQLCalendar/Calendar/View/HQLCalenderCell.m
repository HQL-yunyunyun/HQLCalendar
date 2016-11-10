//
//  HQLCalenderCell.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/10.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "HQLCalenderCell.h"
#import "HQLCalenderView.h"
#import "UIView+ST.h"

@interface HQLCalenderCell ()

@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation HQLCalenderCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.dateLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.dateLabel sizeToFit];
    self.dateLabel.x = (self.width - self.dateLabel.width) * 0.5;
    self.dateLabel.y = (self.height - self.dateLabel.height) * 0.5;
}

#pragma mark - setter 

- (void)setDateModel:(HQLDateModel *)dateModel {
    _dateModel = dateModel;
    if (dateModel.isZero == YES) {
        [self.dateLabel setText:@""];
    } else {
        [self.dateLabel setText:[NSString stringWithFormat:@"%ld", dateModel.day]];
    }
}

#pragma mark - getter

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont systemFontOfSize:15]];
        [_dateLabel setTextColor:[UIColor blackColor]];
//        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

@end
