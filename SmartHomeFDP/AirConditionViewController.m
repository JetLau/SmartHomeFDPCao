//
//  AirConditionViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "AirConditionViewController.h"
#import "RMDevice.h"
#import "RMDeviceManager.h"
@implementation AirConditionViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"空调"];
}

-(int)addDevice
{
    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
    [rmDeviceManager initRMDeviceManage];
    
    RMDevice *rmDevice=[[RMDevice alloc]init];
    rmDevice.type=@"AirCondition";
    
    NSDictionary *dic0=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:0], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:1], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    NSDictionary *dic2=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:2], @"buttonId",@"",@"sendData",@"",@"buttonInfo",nil];
    
    [rmDevice addRMButton:dic0];
    [rmDevice addRMButton:dic1];
    [rmDevice addRMButton:dic2];
    
    NSLog(@"AirCondition add to plist");
    return [rmDeviceManager addRMDeviceInfoIntoFile:rmDevice];
}

@end
