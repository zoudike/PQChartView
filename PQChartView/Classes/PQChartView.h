//
//  PQChartView.h
//  chartDemo
//
//  Created by pqwen on 2019/3/3.
//  Copyright © 2019年 pqwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PQChartPoint.h"

@interface PQChartView : UIView

@property (nonatomic, copy) NSArray <NSString *> *horizontalTitleArray;//x轴方向

@property (nonatomic, copy) NSArray <PQChartPoint *> *dataSource;//数据源

@property (nonatomic, strong) UIColor *lineColor;//连线颜色

@property (nonatomic, strong) UIColor *maskColor;//连线同x\y轴组成部分颜色

@property (nonatomic, assign) CGFloat singleWidth;//每个数据源x方向间隔，默认是74.0f

@property (nonatomic, assign) CGFloat startHeightScale;//起始高度，默认为0.35

@property (nonatomic, assign) CGFloat endHeightScale;//终止高度，默认为0.65

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray <PQChartPoint *> *)dataSource;

@end
