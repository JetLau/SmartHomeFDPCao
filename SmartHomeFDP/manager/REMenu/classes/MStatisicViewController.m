//
//  MStatisicViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/27.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "MStatisicViewController.h"
#import "NavigationViewController.h"
#import "OEMSQueryTableViewCell.h"
#import "MStatisticGraphViewController.h"
#import "OEMSEnergyGraphViewController.h"
@interface MStatisicViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation MStatisicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationItem setTitle:@"数据统计"];
    
    // Here self.navigationController is an instance of NavigationViewController (which is a root controller for the main window)
    //
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(toggleMenu)];
   
    [addressSegment addTarget:self action:@selector(addressSegmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [addressTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.city = [[NSArray alloc] initWithObjects:@"北京",@"上海",@"南京",@"北京",@"上海",@"南京", nil];
    self.district = [[NSArray alloc] initWithObjects:@"朝阳",@"通州",@"五道口",@"朝阳",@"通州",@"五道口", nil];
    self.street = [[NSArray alloc] initWithObjects:@"张衡",@"蔡伦",@"张江高科",@"张衡",@"蔡伦",@"张江高科", nil];
    
    self.address = [NSNumber numberWithInt:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    NavigationViewController *navigationController = (NavigationViewController *)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)addressSegmentChangedValue:(id)sender
{
    switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
        case 0:
            [addressTableView reloadData];
            [addressSegment setTitle:@"区" forSegmentAtIndex:1];
            //[self.addressDic setValue:@"" forKey:@"district"];
            [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
            //[self.addressDic setValue:@"" forKey:@"street"];
            [addressSegment setEnabled:NO forSegmentAtIndex:2];
            break;
        case 1:
            [addressTableView reloadData];
            [addressSegment setTitle:@"街道" forSegmentAtIndex:2];
            //[self.addressDic setValue:@"" forKey:@"street"];
            break;
        case 2:
            [addressTableView reloadData];
        default:
            break;
    }
    
    
}

- (OEMSQueryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if([addressSegment selectedSegmentIndex] == 0) {
        cell.name.text = [self.city objectAtIndex:[indexPath row]];
    } else if([addressSegment selectedSegmentIndex] == 1) {
        cell.name.text = [self.district objectAtIndex:[indexPath row]];
    } else {
        cell.name.text = [self.street objectAtIndex:[indexPath row]];
        
        
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([addressSegment selectedSegmentIndex] == 0) {
        return [self.city count];
    } else if ([addressSegment selectedSegmentIndex] == 1) {
        return [self.district count];
    } else {
        return [self.street count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([addressSegment selectedSegmentIndex] == 0) {
        [addressSegment setTitle:[self.city objectAtIndex:indexPath.row] forSegmentAtIndex:0];
        //[self.addressDic setValue:[self.city objectAtIndex:indexPath.row] forKey:@"city"];
        [addressSegment setEnabled:YES forSegmentAtIndex:1];
    } else if ([addressSegment selectedSegmentIndex] == 1) {
        [addressSegment setTitle:[self.district objectAtIndex:indexPath.row] forSegmentAtIndex:1];
        //[self.addressDic setValue:[self.district objectAtIndex:indexPath.row] forKey:@"district"];
        [addressSegment setEnabled:YES forSegmentAtIndex:2];
        
    } else {
        [addressSegment setTitle:[self.street objectAtIndex:indexPath.row] forSegmentAtIndex:2];
        //[self.addressDic setValue:[self.street objectAtIndex:indexPath.row] forKey:@"street"];
        
    }
    self.address = [NSNumber numberWithInt:1];
}

- (IBAction)queryBtnClicked:(UIButton *)sender {
    NSLog(@"address=%@,type = %d",self.address,[enquiryTypeSegment selectedSegmentIndex]);
    int type = [enquiryTypeSegment selectedSegmentIndex];
    
    MStatisticGraphViewController *graphVCtrl = [[MStatisticGraphViewController alloc] initWithNibName:@"MStatisticGraphViewController" bundle:nil];
    graphVCtrl.type =type;
    if (type ==0) {
        [graphVCtrl.navigationItem  setTitle:@"用户数量"];
    }else if (type ==1) {
        OEMSEnergyGraphViewController *egVctrl = [[OEMSEnergyGraphViewController alloc] initWithNibName:@"OEMSEnergyGraphViewController" bundle:nil];
        [egVctrl.navigationItem  setTitle:@"设备数量"];
        [self.navigationController pushViewController:egVctrl animated:YES];
        return;
    }else if (type ==2) {
        [graphVCtrl.navigationItem  setTitle:@"使用频率"];
    }
    [self.navigationController pushViewController:graphVCtrl animated:YES];
    
}


@end
