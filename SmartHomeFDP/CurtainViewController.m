//
//  CurtainViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-8.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "CurtainViewController.h"
#import "RMDevice.h"
#import "RMDeviceManager.h"

@implementation CurtainViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.navigationItem setTitle:@"窗帘"];
}

//-(int)addDevice
//{
//    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
//    [rmDeviceManager initRMDeviceManage];
//    
//    int remoteCount = [rmDeviceManager getRemoteCount:@"Curtain"];
//    RMDevice *rmDevice=[[RMDevice alloc]init];
//    rmDevice.type=@"Curtain";
//    rmDevice.name=[@"窗帘" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
//
//    
//    NSDictionary *dic0=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:0], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:1], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    NSDictionary *dic2=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:2], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//
//    
//    [rmDevice addRMButton:dic0];
//    [rmDevice addRMButton:dic1];
//    [rmDevice addRMButton:dic2];
//    
//    dispatch_async(remoteQueue, ^{
//        NSMutableDictionary *remoteDic = [[NSMutableDictionary alloc] init];
//        [remoteDic setObject:@"addRemote" forKey:@"command"];
//        [remoteDic setObject:self.info.mac forKey:@"mac"];
//        [remoteDic setObject:rmDevice.name forKey:@"name"];
//        [remoteDic setObject:rmDevice.type forKey:@"type"];
//        //NSLog(@"TV =%@",remoteDic);
//       // [SmartHomeAPIs AddRemote:remoteDic];
//    });
//    
//    NSLog(@"Curtain add to plist");
//    return [rmDeviceManager addRMDeviceInfoIntoFile:rmDevice];
//}

@end
