//
//  ViewController.m
//  HQLCalendar
//
//  Created by weplus on 2016/11/9.
//  Copyright © 2016年 weplus. All rights reserved.
//

#import "ViewController.h"
#import "testController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonDidClick:(UIButton *)sender {
    testController *test = [testController new];
    test.mode = sender.tag;
    [self.navigationController pushViewController:test animated:YES];
}


@end
