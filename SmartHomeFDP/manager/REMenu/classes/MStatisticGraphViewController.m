//
//  MStatisticGraphViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/28.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "MStatisticGraphViewController.h"
#import "OEMSQueryTableViewCell.h"
#import "DiffEnqueryDeviceTableViewController.h"
@interface MStatisticGraphViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MStatisticGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.type =4;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }

    if (self.type == 2) {
        
        //self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
        //        self.barChart.showLabel = NO;
        self.barChart.backgroundColor = [UIColor clearColor];
        self.barChart.yLabelFormatter = ^(CGFloat yValue){
            CGFloat yValueParsed = yValue;
            NSString * labelText = [NSString stringWithFormat:@"%0.f%%",yValueParsed];
            return labelText;
        };
        self.barChart.labelMarginTop = 5.0;
        self.barChart.showChartBorder = YES;
        [self.barChart setXLabels:@[@"电视",@"空调",@"门",@"窗",@"灯",@"自定义"]];
        //       self.barChart.yLabels = @[@-10,@0,@10];
        [self.barChart setYValues:@[@10.82,@1.88,@6.96,@33.93,@33.93,@11.1]];
        [self.barChart setStrokeColors:@[PNGreen,PNGreen,PNRed,PNGreen,PNGreen]];
        self.barChart.isGradientShow = YES;
        self.barChart.isShowNumbers = YES;
        
        [self.barChart strokeChart];
        
        self.barChart.delegate = self;
        
        //[self.view addSubview:self.barChart];
    }else if(self.type == 1){
        
        self.circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0,150.0, SCREEN_WIDTH, 100.0)
                                                          total:@100
                                                        current:@60
                                                      clockwise:YES];
        
        self.circleChart.backgroundColor = [UIColor clearColor];
        
        [self.circleChart setStrokeColor:[UIColor clearColor]];
        [self.circleChart setStrokeColorGradientStart:[UIColor blueColor]];
        [self.circleChart strokeChart];
        
        [self.view addSubview:self.circleChart];
    }else if(self.type == 0){
  
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNLightGreen description:@"1街"],
                           [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"2街"],
                           [PNPieChartDataItem dataItemWithValue:40 color:PNStarYellow description:@"3街"],
                           ];
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 100, 200.0, 200.0) items:items];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
        self.pieChart.showAbsoluteValues = NO;
        self.pieChart.showOnlyValues = NO;
        [self.pieChart strokeChart];
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked;
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.pieChart.delegate = self;

        UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
        [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];
        [self.view addSubview:legend];
        
        [self.view addSubview:self.pieChart];
        [self.dataTableView setHidden:YES];
        
    }
    
    [self.dataTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex{
    NSLog(@"Click on line %f, %f, line index is %d",point.x, point.y, (int)lineIndex);
}


- (void)userClickedOnBarAtIndex:(NSInteger)barIndex
{
    
    NSLog(@"Click on bar %@", @(barIndex));
    
    PNBar * bar = [self.barChart.bars objectAtIndex:barIndex];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    animation.fromValue = @1.0;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = @1.1;
    animation.duration = 0.2;
    animation.repeatCount = 0;
    animation.autoreverses = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [bar.layer addAnimation:animation forKey:@"Float"];
    
    self.statisticsData = [[NSMutableArray alloc] initWithObjects:@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),@(barIndex),nil];
    [self.dataTableView reloadData];
}

- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex{
    DiffEnqueryDeviceTableViewController *enqueryVCtl = [[DiffEnqueryDeviceTableViewController alloc] initWithNibName:@"DiffEnqueryDeviceTableViewController" bundle:nil];
    NSLog(@"Click on pie %@", @(pieIndex));

    if (pieIndex ==0) {
        [enqueryVCtl.navigationItem  setTitle:@"1街"];
    }else if (pieIndex ==1) {
        [enqueryVCtl.navigationItem  setTitle:@"2街"];
    }else if (pieIndex ==2) {
        [enqueryVCtl.navigationItem  setTitle:@"3街"];
    }
    [self.navigationController pushViewController:enqueryVCtl animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (OEMSQueryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.name.text = [NSString stringWithFormat:@"数据%@",[self.statisticsData objectAtIndex:[indexPath row]]];
 
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.statisticsData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataTableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
