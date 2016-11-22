//
//  HMPopMenuDataSource.m
//  HuanMoneyBoss
//
//  Created by Xiang on 16/6/22.
//  Copyright © 2016年 微加科技. All rights reserved.
//

#import "HMPopMenuDataSource.h"
#import "HMPopMenuCell.h"

@interface HMPopMenuDataSource ()

@property (nonatomic, copy) TableViewCellConfigureBlock configureCellBlock;
@property (nonatomic, strong) Class Cellclass;
@property (nonatomic, strong) NSArray * modelArray;

@end

@implementation HMPopMenuDataSource

- (instancetype) init {
    
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype) initWithItems:(NSArray *)anItems
                     cellClass:(Class)cellClass
            configureCellBlock:(TableViewCellConfigureBlock)aConfigureCellBlock {
    
    if (self = [super init]) {
        
        self.modelArray = anItems;
        self.configureCellBlock = [aConfigureCellBlock copy];
        self.Cellclass = cellClass;
    }
    return self;
}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArray.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMPopMenuCell * cell = [[self.Cellclass class] cellInitWithTableView:tableView];
    self.configureCellBlock(cell,self.modelArray[indexPath.row]);
    return cell;
}

@end
