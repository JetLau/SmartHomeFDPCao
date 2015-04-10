//
//  DeviceInfoManagerForCell.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-24.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "DeviceInfoManagerForCell.h"
#import "RMDeviceManager.h"
#import "TCPDeviceManager.h"

@implementation DeviceInfoManagerForCell

+(instancetype)createDeviceInfoManagerForCell
{
    DeviceInfoManagerForCell *deviceInfoManagerForCell=[[DeviceInfoManagerForCell alloc]init];
    deviceInfoManagerForCell.rmDeviceManager=[RMDeviceManager createRMDeviceManager];
    deviceInfoManagerForCell.tcpDeviceManager=[TCPDeviceManager createTCPDeviceManager];
    
    return deviceInfoManagerForCell;
}
@end
