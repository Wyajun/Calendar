//
//  ViewController.m
//  日历控件
//
//  Created by 王亚军 on 16/5/23.
//  Copyright © 2016年 王亚军. All rights reserved.
//

#import "ViewController.h"
#import "TJVerticalCalendarView.h"
#import "tjHorizontalCalendarView.h"
#import "masonry.h"
#import "TJCalendarConfigModel.h"
@interface ViewController ()
@property(nonatomic,strong)TJCalendarConfigModel *configModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    TJHorizontalCalendarView *calenderView = [[TJHorizontalCalendarView alloc] initWithFrame:CGRectMake(15, 60, self.view.frame.size.width - 30, 400)];
    [self.view addSubview:calenderView];
//    [calenderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(60, 15, 0, 15));
//    }];
    calenderView.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
