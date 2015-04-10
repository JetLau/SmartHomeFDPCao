//
//  TVViewController.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-6.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "TVViewController.h"
#import "RMDeviceManager.h"
#import "RMButton.h"
#import "RMDevice.h"
#import "BtnStudyViewController.h"
#import "MJExtension.h"

@interface TVViewController ()
{
    //dispatch_queue_t networkQueue;
}
@end

@implementation TVViewController
//@synthesize mode;
//@synthesize parameterDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.info = super.info;
        //self.view.backgroundColor = [UIColor colorWithRed:240 green:239 blue:244 alpha:1.0];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

//-(int)addDevice
//{
//    RMDeviceManager *rmDeviceManager=[[RMDeviceManager alloc]init];
//    [rmDeviceManager initRMDeviceManage];
//    
//    int remoteCount = [rmDeviceManager getRemoteCount:@"TV"];
//    RMDevice *rmDevice=[[RMDevice alloc]init];
//    rmDevice.type=@"TV";
//    rmDevice.name=[@"电视" stringByAppendingFormat:@"%@",[NSNumber numberWithInt:remoteCount+1]];
//    
//    
//    NSDictionary *dic0=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:0], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    NSDictionary *dic1=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:1], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    NSDictionary *dic2=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:2], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    NSDictionary *dic3=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:3], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    NSDictionary *dic4=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:4], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    NSDictionary *dic5=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:5], @"buttonId",@"",@"sendData",@"",@"buttonInfo",@"",@"btnName",nil];
//    
//    [rmDevice addRMButton:dic0];
//    [rmDevice addRMButton:dic1];
//    [rmDevice addRMButton:dic2];
//    [rmDevice addRMButton:dic3];
//    [rmDevice addRMButton:dic4];
//    [rmDevice addRMButton:dic5];
//    //向服务器发送添加remote的信息
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
//    NSLog(@"TV add to plist");
//    return [rmDeviceManager addRMDeviceInfoIntoFile:rmDevice];
//}


@end