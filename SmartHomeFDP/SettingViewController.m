//
//  SetterViewController.m
//  SmartHomeFDP
//
//  Created by cisl on 14-11-3.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "SettingViewController.h"
#import "LJCommonGroup.h"
#import "LJCommonItem.h"
#import "JSONKit.h"
#import "RootController.h"
#import "TCPDeviceManager.h"
#import "RMDeviceManager.h"
#import "SmartHomeAPIs.h"
#import "ProgressHUD.h"
#import "StatisticViewController.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationItem setTitle:@"设置"];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.blEasyConfig=[InitBroadLink initBroadLinkDevices];

    [self setupGroups];
}

-(void)setupGroups
{
    [self setGroup0];
    [self setGroup1];
}

-(void)setGroup0
{
    LJCommonGroup *LJGroup=[[LJCommonGroup alloc]init];
    [self.groups addObject:LJGroup];
    
    LJCommonItem *downloadItem=[LJCommonItem itemWithTitle:@"下载设备"];
    [LJGroup.items addObject:downloadItem];
//    LJCommonItem *statisticItem=[LJCommonItem itemWithTitle:@"操作统计"];
//    [LJGroup.items addObject:statisticItem];
}

-(void)setGroup1
{
    LJCommonGroup *LJGroup=[[LJCommonGroup alloc]init];
    [self.groups addObject:LJGroup];
    
    LJCommonItem *outItem=[LJCommonItem itemWithTitle:@"退出登录"];
    
    [LJGroup.items addObject:outItem];
}

#pragma mark-点击cell的代理方法
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if (indexPath.item==0) {
            [self downloadDevices];
        }else if(indexPath.item == 1){
//            StatisticViewController *statisticViewController = [[StatisticViewController alloc] init];
//            [statisticViewController.navigationItem setTitle:@"操作统计"];
//            [self.navigationController pushViewController:statisticViewController animated:YES];
        }
    }
    if(indexPath.section==1&&indexPath.item==0)
    {
        [self logOutSystem];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)logOutSystem
{
    //删除userdefaults中的用户信息
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"username"];
    [userDefaults removeObjectForKey:@"password"];
    
    RootController *rootController=(RootController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootController switchToLoginView];
}

-(void)downloadDevices
{
    //下载TCP设备列表
    dispatch_async(kBgQueue,
                   ^{
                       NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                       NSString *username=[defaults objectForKey:@"username"];
                       
                       NSDictionary *jsonDic=[SmartHomeAPIs GetTCPDeviceList:username];
                       if(jsonDic==nil)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [ProgressHUD showError:@"设备下载失败"];
                           });
                           return ;
                       }
                       NSDictionary *jsonMap=[jsonDic objectForKey:@"jsonMap"];
                       
                       if(jsonMap==nil)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [ProgressHUD showError:@"设备下载失败"];
                           });
                           return;
                       }
                       NSArray *array=[jsonMap objectForKey:@"list"];
                       
                       TCPDeviceManager *tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
                       [tcpDeviceManager saveTCPDeviceInfoToFile:array];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"设备下载完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                           [alertView show];
                       });
                       
                   });
    //下载遥控列表
    dispatch_async(kBgQueue,
                   ^{
                       [self.blEasyConfig listRefresh];
                       NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                       NSString *username=[defaults objectForKey:@"username"];
                       
                       NSDictionary *jsonDic=[SmartHomeAPIs GetRemoteList:username];
                       if(jsonDic==nil)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [ProgressHUD showError:@"遥控列表下载失败"];
                           });
                           return ;
                       }
                       NSDictionary *jsonMap=[jsonDic objectForKey:@"jsonMap"];
                       
                       if(jsonMap==nil)
                       {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [ProgressHUD showError:@"遥控列表下载失败"];
                           });
                           return;
                       }
                       NSArray *array=[jsonMap objectForKey:@"result"];
                       NSLog(@"remoteArray : %@",array);
                       RMDeviceManager *rmDeviceManager = [RMDeviceManager createRMDeviceManager];
                       [rmDeviceManager saveRemoteListInfoToFile:array];

                       dispatch_async(dispatch_get_main_queue(), ^{
                           
                           UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:nil message:@"遥控列表下载完成" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                           [alertView show];
                       });
                       
                   });
    
}

@end
