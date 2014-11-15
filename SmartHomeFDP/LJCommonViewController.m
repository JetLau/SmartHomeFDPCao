//
//  LJCommonViewController.m
//  NewProject
//
//  Created by eddie on 14-9-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "LJCommonViewController.h"
#import "LJCommonCell.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "LJCommonSwitchItem.h"
#import "LJCommonArrowItem.h"
#import "LJCommonLabelItem.h"
#import <objc/runtime.h>

@interface LJCommonViewController ()
@property(strong,nonatomic)NSMutableArray *groups;

@end

@implementation LJCommonViewController

/**
 用一个模型来描述每组的信息：组头，组尾，这组的所有模型
 用一个模型来描述每行的信息：图标，标题，子标题，右边的样式（箭头，文字，数字，开关，打钩）
 */

#pragma mark -懒加载
-(NSMutableArray *)groups
{
    if(_groups==nil)
    {
        _groups=[[NSMutableArray alloc] init];
    }
    
    return _groups;
}

//屏蔽tableview的样式设置
-(id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.tableView.sectionFooterHeight=0;
//    self.tableView.sectionHeaderHeight=20;
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //不显示垂直的滚动条
    self.tableView.showsVerticalScrollIndicator=NO;
    

}

#pragma mark -tableview的代理
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    LJCommonGroup *group = self.groups[section];
    return group.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.获取cell
    LJCommonCell *cell = [LJCommonCell cellWithTableView:tableView];
    //2.设置cell显示数据
    LJCommonGroup *group = self.groups[indexPath.section];
    LJCommonItem *item = group.items[indexPath.row];
    cell.item = item;
    [cell setIndexPath:indexPath rowsInSection:group.items.count];
    //3.返回cell
    return  cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    LJCommonGroup *group = self.groups[section];
    return group.groupheader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
//    titleLabel.textColor=[UIColor blackColor];
//    
//    LJCommonGroup *group = self.groups[section];
//    titleLabel.text=group.groupheader;
//    
//    return titleLabel;
//}

#pragma mark-点击cell的代理方法
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.取出这行对应的item模型
    LJCommonGroup *group = self.groups[indexPath.section];
    LJCommonItem *item = group.items[indexPath.row];
    
    //2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        UIViewController *destVc =[[item.destVcClass alloc] init];
        
        //设置destVc的属性值，将mode属性设置为0(study)\1(use)\2(others)
//        NSLog(@"%@",item.parameterDic);
//        //从类中获取成员变量parameterDic
//        Ivar ivar=class_getInstanceVariable([destVc class], "parameterDic");
//        //为对象destVc的成员变量parameterDic赋值
//        object_setIvar(destVc, ivar, [item.parameterDic copy]);
//        
        [self.navigationController pushViewController:destVc animated:YES];
    }
    
    //3.判断有无需要执行的代码段
    if (item.operation) {
        item.operation();
    }
}

@end
