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
    
    self.district = [[NSArray alloc] initWithObjects:@"朝阳",@"通州",@"五道口", nil];
    self.street = [[NSArray alloc] initWithObjects:@"张衡",@"蔡伦",@"张江高科", nil];
    self.currentRank = 0;
    
    [self.adressTableView registerNib:[UINib nibWithNibName:@"OEMSQueryTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *indentifier = @"cell";
    OEMSQueryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];


       
        if (self.currentRank > 0) {
            if ([indexPath row] == 0) {
                cell.name.text = @"返回";
            }else{
                cell.name.text = [self.street objectAtIndex:[indexPath row]-1];
            }
        }else{
            cell.name.text = [self.district objectAtIndex:[indexPath row]];
        }

    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.currentRank == 0) {
        return [self.district count];
    } else {
        return [self.street count]+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentRank > 0) {
        if ([indexPath row] == 0) {
            self.currentRank -= 1;
            [self.adressTableView reloadData];
        }else{
            self.currentAdress.text = [self.currentAdress.text stringByAppendingString:[self.street objectAtIndex:[indexPath row]-1]];
        }
    }else{
        
        self.currentRank += 1;
        self.currentAdress.text = [self.currentAdress.text stringByAppendingString:[self.district objectAtIndex:[indexPath row]]];
        [self.adressTableView reloadData];
    }
    
}

@end
