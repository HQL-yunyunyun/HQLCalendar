//
//  HMPopMenuCell.m
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/22.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import "HMPopMenuCell.h"

@interface HMPopMenuCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation HMPopMenuCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.numberOfLines = 0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype) cellInitWithTableView:(UITableView *)tableView {
    
    HMPopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[[self class] alloc] initWithStyle:0 reuseIdentifier:NSStringFromClass([self class])];
    }
    return cell;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    [self.titleLabel setFrame:self.bounds];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - setter

- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    [self.titleLabel setText:titleString];
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:ZXColor(51, 51, 51)];
        [_titleLabel setNumberOfLines:0];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
