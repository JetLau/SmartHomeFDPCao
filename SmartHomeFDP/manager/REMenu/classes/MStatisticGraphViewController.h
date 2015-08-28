//
//  MStatisticGraphViewController.h
//  SmartHomeFDP
//
//  Created by cisl on 15/8/28.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
@interface MStatisticGraphViewController : UIViewController<PNChartDelegate>

@property int type;
@property (nonatomic) PNBarChart * barChart;
@property (nonatomic) PNCircleChart * circleChart;
@property (nonatomic) PNPieChart *pieChart;


@end
