//
//  PQViewController.m
//  PQChartView
//
//  Created by zoudike on 03/05/2019.
//  Copyright (c) 2019 zoudike. All rights reserved.
//

#import "PQViewController.h"
#import <PQChartView/PQChartPoint.h>
#import <PQChartView/PQChartView.h>

@interface PQViewController ()

@end

@implementation PQViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self addChartView];
}

- (void)addChartView {
    NSArray *tempX = @[@(0),@(1),@(2),@(3),@(4),@(5),@(6)];
    NSArray *tempY = @[@(12),@(32),@(23),@(24),@(45),@(16),@(47)];
    NSArray *contentArray = @[@"节点1",@"节点2",@"节点3",@"节点4",@"节点5",@"节点6",@"节点7"];
    NSArray *horizontalTitleArray = @[@"12",@"32",@"23",@"24",@"45",@"16",@"47"];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 7; i++) {
        PQChartPoint *point = [[PQChartPoint alloc] init];
        point.xPoint = [tempX[i] floatValue];
        point.yPoint = [tempY[i] floatValue];
        point.content = contentArray[i];
        [tempArray addObject:point];
    }
    
    PQChartView *chartView = [[PQChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 500) dataSource:[tempArray copy]];
    chartView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chartView];
    chartView.startHeightScale = 0.3;
    chartView.endHeightScale = 0.7;
    chartView.horizontalTitleArray = horizontalTitleArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
