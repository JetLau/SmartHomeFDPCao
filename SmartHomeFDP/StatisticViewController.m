//
//  StatisticViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-12-22.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "StatisticViewController.h"
#import "LJCommonGroup.h"
#import "LJCommonLabelItem.h"
#import "StatisticFileManager.h"
@interface StatisticViewController ()

@property (nonatomic,strong) NSMutableArray *groups;

@end

@implementation StatisticViewController
#pragma mark -懒加载
-(NSMutableArray *) groups
{
    if (_groups == nil) {
        _groups = [[NSMutableArray alloc] init];
    }
    
    return _groups;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏tabbar工具条
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self setupGroups];
}

-(void) viewWillAppear:(BOOL)animated
{
    
}

-(void)setupGroups
{
    [self setGroup0];
}

-(void)setGroup0
{
    //1.创建组
    LJCommonGroup *group = [LJCommonGroup group];
    [self.groups addObject:group];
    
    StatisticFileManager *statisticManager = [StatisticFileManager createStatisticManager];
    NSMutableArray * statisticArray = [statisticManager readStatisticInfo];
    NSMutableDictionary *typeDic;
    for (typeDic in statisticArray) {
        if ([[typeDic objectForKey:@"type"] isEqualToString:@"Voice"]) {
            LJCommonLabelItem *item1 = [LJCommonLabelItem itemWithTitle:@"语音控制成功"];
            item1.text =[[typeDic objectForKey:@"successTimes"]stringValue];
            [group.items addObject:item1];
            
            LJCommonLabelItem *item2 = [LJCommonLabelItem itemWithTitle:@"语音控制失败"];
            item2.text =[[typeDic objectForKey:@"failTimes"]stringValue];
            [group.items addObject:item2];
        }else{
        
            LJCommonLabelItem *item = [LJCommonLabelItem itemWithTitle:[typeDic objectForKey:@"name"]];
            item.text = [[typeDic objectForKey:@"times"] stringValue];
            [group.items addObject:item];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
