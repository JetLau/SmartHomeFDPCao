//
//  LightViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-23.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "TCPDeviceViewController.h"
#import "TCPDevice.h"
#import "SmartHomeAPIs.h"
#import "ChangeTCPButtonInfoViewController.h"
#import "ChangeTCPDeviceNameViewController.h"
#import "ProgressHUD.h"
#import "StatisticFileManager.h"
@implementation TCPDeviceViewController
@synthesize deviceInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //隐藏tabbar工具条
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:deviceInfo.tcpDev_name];
    //隐藏tabbar工具条
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *changeNameItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(changeBarButtonItemClicked:)];
    
    [self.navigationItem setRightBarButtonItem:changeNameItem];
}

- (IBAction)buttonClicked:(UIButton *)sender
{
    switch (sender.tag) {
        case 0://开操作
        {
           // [self operateStatistics:deviceInfo.tcpDev_type andBtnId:0];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *mac=deviceInfo.tcpDev_mac;
                NSString *success=[SmartHomeAPIs OpenTCPDevice:mac type:deviceInfo.tcpDev_type];
                if([success isEqualToString:@"fail"])
                {
                    [SmartHomeAPIs AuthTCPDevice:mac type:deviceInfo.tcpDev_type];
                    success=[SmartHomeAPIs OpenTCPDevice:mac type:deviceInfo.tcpDev_type];
                }
                
                if([success isEqualToString:@"success"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"控制成功"];
                    });
                }
                else if([success isEqualToString:@"fail"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"操作失败，请检查网络！"];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:[NSString stringWithString:success]];
                    });
                }
            });
            
            break;
        }
        case 1://关操作
        {
            //[self operateStatistics:deviceInfo.tcpDev_type andBtnId:1];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *mac=deviceInfo.tcpDev_mac;
                NSString *success=[SmartHomeAPIs CloseTCPDevice:mac type:deviceInfo.tcpDev_type];
                if([success isEqualToString:@"fail"])
                {
                    [SmartHomeAPIs AuthTCPDevice:mac type:deviceInfo.tcpDev_type];
                    success=[SmartHomeAPIs CloseTCPDevice:mac type:deviceInfo.tcpDev_type];
                }
                
                if([success isEqualToString:@"success"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"控制成功"];
                    });
                }
                else if([success isEqualToString:@"fail"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:@"操作失败，请检查网络！"];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ProgressHUD showSuccess:[NSString stringWithString:success]];
                    });
                }
                
            });
            break;
        }
        default:
            break;
    }
}

-(void) operateStatistics:(NSString*)type andBtnId:(int)btnId
{
    dispatch_async(dispatch_get_main_queue(), ^{
        StatisticFileManager * statisticManager = [StatisticFileManager createStatisticManager];
        [statisticManager statisticOperateWithType:type andBtnId:btnId];
    });
}

- (IBAction)btnLongPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIButton *button=(UIButton *)sender.view;
        
        ChangeTCPButtonInfoViewController *changeTCPButtonInfoViewController=[[ChangeTCPButtonInfoViewController alloc]init];
        changeTCPButtonInfoViewController.deviceInfo=deviceInfo;
        changeTCPButtonInfoViewController.buttonTag=button.tag;
        [changeTCPButtonInfoViewController.navigationItem setTitle:@"修改按钮信息"];
        [self.navigationController pushViewController:changeTCPButtonInfoViewController animated:YES];
    }
}

- (void)changeBarButtonItemClicked:(UIBarButtonItem *)item
{
    ChangeTCPDeviceNameViewController *changeTCPDeviceNameViewController=[[ChangeTCPDeviceNameViewController alloc]init];
    changeTCPDeviceNameViewController.deviceInfo=deviceInfo;
    changeTCPDeviceNameViewController.navigationItem.title=@"修改设备名称";
    
    [self.navigationController pushViewController:changeTCPDeviceNameViewController animated:YES];
}
@end
