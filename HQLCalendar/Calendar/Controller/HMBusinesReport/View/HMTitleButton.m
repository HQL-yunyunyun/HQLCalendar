//
//  HMTitleButton.m
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/21.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import "HMTitleButton.h"

@implementation HMTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 图片
//    self.imageView.height = self.height * 0.2;
//    self.imageView.width = self.height * 0.35;

//    self.imageView.x = self.width - self.imageView.width;//self.height * 0.1;
    self.imageView.x = (self.width + self.titleLabel.width) * 0.5;
    self.imageView.centerY = self.height * 0.5;
    
    // 文字
//    self.titleLabel.width = self.width - self.imageView.width;
    self.titleLabel.y = 0; //CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.height = self.height;// - self.titleLabel.y;
//    self.titleLabel.x = 0;
    self.titleLabel.centerX = self.width * 0.5;
}

@end
