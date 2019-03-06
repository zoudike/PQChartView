//
//  PQChartView.m
//  chartDemo
//
//  Created by pqwen on 2019/3/3.
//  Copyright © 2019年 pqwen. All rights reserved.
//

#import "PQChartView.h"

#define kDefaultSingleWidth 74.0f

#define kPointWidth 8.0f

#define kLeftMargin 35.0f

#define kRightMargin 37.0f

#define kBottomTitleHeight  40.0f

#define kDefaultLineColor   [UIColor colorWithRed:0x58/255.0f green:0xA7/255.0f blue:0xFF/255.0f alpha:1.0]

@interface PQChartView ()

@property (nonatomic, assign)CGFloat max;

@property (nonatomic, assign)CGFloat min;

@property (nonatomic, copy) NSArray *points;//各个点的坐标

@property (nonatomic, strong) UIBezierPath *linePath;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PQChartView

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray<PQChartPoint *> *)dataSource {
    if (self = [super initWithFrame:frame]) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.scrollView removeFromSuperview];
    //1、先计算出数据源每个单位占屏幕单位
    [self calculateDataSource];
    //2、添加scrollview
    [self addScrollView];
    //2、确定每个点的位置，并添加每个点的点击事件
    [self drawPoints];
    //3、连接起各个点
    [self addLineAndDashLine];
    //4、画底部遮罩层
    [self addMask];
    //添加横坐标标签
    [self addHorizontalTitleLabel];
    
}

- (void)calculateDataSource {
    //计算平均每个单位的高度
    __block CGFloat max = self.dataSource.firstObject.yPoint;
    __block CGFloat min = self.dataSource.firstObject.yPoint;
    [self.dataSource enumerateObjectsUsingBlock:^(PQChartPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.yPoint > max) {
            max = obj.yPoint;
        }
        if (obj.yPoint < min) {
            min = obj.yPoint;
        }
    }];
    self.max = max;
    self.min = min;
}

- (void)addScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    CGFloat singleWidth = self.singleWidth ? self.singleWidth : kDefaultSingleWidth;
    self.scrollView.contentSize = CGSizeMake(MAX((self.dataSource.count-1) * singleWidth + kLeftMargin + kRightMargin, self.scrollView.frame.size.width), self.scrollView.frame.size.height);
    [self addSubview:self.scrollView];
}

- (void)drawPoints {
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    CGFloat singleWidth = self.singleWidth ? self.singleWidth : kDefaultSingleWidth;
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        CGFloat dataX = self.dataSource[i].xPoint;
        CGFloat dataY = self.dataSource[i].yPoint;
        UIButton *curBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kPointWidth, kPointWidth)];
        [self.scrollView addSubview:curBtn];
        CGFloat frameHeight = self.frame.size.height;
        CGFloat centerY = frameHeight - (self.startHeightScale * frameHeight + (dataY - self.min) / (self.max - self.min) * (self.endHeightScale - self.startHeightScale) * frameHeight);
        curBtn.center = CGPointMake(kLeftMargin + dataX * singleWidth, centerY);
        [curBtn setBackgroundImage:[UIImage imageNamed:@"point"] forState:UIControlStateNormal];
        [curBtn setBackgroundImage:[UIImage imageNamed:@"circle"] forState:UIControlStateSelected];
        CGPoint point = CGPointMake(curBtn.center.x, curBtn.center.y);
        [tempArr addObject:@(point)];
    }
    self.points = [tempArr copy];
}

- (void)addLineAndDashLine {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    self.linePath = linePath;
    for (NSInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [self.points[i] CGPointValue];
        if (i == 0) {
            [linePath moveToPoint:CGPointMake(point.x, point.y)];
        } else {
            [linePath addLineToPoint:CGPointMake(point.x, point.y)];
        }
        UIBezierPath *dashPath = [UIBezierPath bezierPath];
        [dashPath moveToPoint:CGPointMake(point.x, 0)];
        [dashPath addLineToPoint:CGPointMake(point.x, self.scrollView.frame.size.height - kBottomTitleHeight)];
        CAShapeLayer *dashLayer = [CAShapeLayer layer];
        dashLayer.path = dashPath.CGPath;
        dashLayer.strokeColor = [UIColor colorWithRed:0xD2/255.0F green:0xD2/255.0F blue:0xD2/255.0F alpha:1.0].CGColor;
        [dashLayer setLineDashPattern:@[@(2),@(2)]];
        [self.scrollView.layer insertSublayer:dashLayer atIndex:2];
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 2.0f;
    layer.path = linePath.CGPath;
    layer.strokeColor  = self.lineColor ? (self.lineColor.CGColor) : kDefaultLineColor.CGColor ;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.scrollView.layer addSublayer:layer];
}

- (void)addMask {
    CGPoint firstPoint = [self.points.firstObject CGPointValue];
    CGPoint lastPoint =  [self.points.lastObject CGPointValue];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithCGPath:self.linePath.CGPath];
    [maskPath addLineToPoint:CGPointMake(lastPoint.x, self.frame.size.height)];
    [maskPath addLineToPoint:CGPointMake(kLeftMargin, self.frame.size.height)];
    [maskPath addLineToPoint:CGPointMake(kLeftMargin, firstPoint.y)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    maskLayer.fillColor = [UIColor colorWithRed:0xF6/255.0f green:0xFA/255.0f blue:0xFF/255.0F alpha:1.0].CGColor;
    CAShapeLayer *baseLayer = [CAShapeLayer layer];
    baseLayer.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height - kBottomTitleHeight);
    baseLayer.backgroundColor = [UIColor colorWithRed:0xF6/255.0f green:0xFA/255.0f blue:0xFF/255.0F alpha:1.0].CGColor;
    baseLayer.mask = maskLayer;
    [self.scrollView.layer insertSublayer:baseLayer atIndex:0];
}

- (void)addHorizontalTitleLabel {
    for (NSInteger i = 0; i < self.horizontalTitleArray.count; i++) {
        CGPoint curPoint = [self.points[i] CGPointValue];
        NSString *curTitle = self.horizontalTitleArray[i];
        NSString *curDataContent = self.dataSource[i].content;
        UILabel *curTitleLabel = [[UILabel alloc] init];
        curTitleLabel.text = curTitle;
        curTitleLabel.textColor = [UIColor colorWithRed:0x55/255.0f green:0x55/255.0f blue:0x55/255.0f alpha:1.0];
        curTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        [curTitleLabel sizeToFit];
        curTitleLabel.center = CGPointMake(curPoint.x, self.scrollView.frame.size.height - 18);
        [self.scrollView addSubview:curTitleLabel];
        
        UILabel *curDataLabel = [[UILabel alloc] init];
        curDataLabel.text = curDataContent;
        curDataLabel.textColor = [UIColor colorWithRed:0x55/255.0f green:0x55/255.0f blue:0x55/255.0f alpha:1.0];
        curDataLabel.font = [UIFont systemFontOfSize:13.0f];
        [curDataLabel sizeToFit];
        curDataLabel.center = CGPointMake(curPoint.x, curPoint.y - 18);
        [self.scrollView addSubview:curDataLabel];
    }
}

@end
